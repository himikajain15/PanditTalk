"""
API Views for Pandit App
Handles all pandit-specific operations
"""
from rest_framework import viewsets, status
from rest_framework.decorators import action, api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db.models import Sum, Q, Count
from django.utils import timezone
from datetime import timedelta
from decimal import Decimal
from pathlib import Path
from dotenv import load_dotenv
from google import genai
from google.genai import types
import os
import logging

from .models import CustomUser, PanditProfile, ConsultationRequest, PanditPayout, PanditReview, BlockedUser, VIPUser
from .pandit_serializers import (
    PanditProfileSerializer, ConsultationRequestSerializer,
    PanditPayoutSerializer, PanditReviewSerializer,
    PanditDashboardSerializer, EarningsSerializer
)

logger = logging.getLogger(__name__)


class IsPandit(IsAuthenticated):
    """Permission class to check if user is a pandit"""
    def has_permission(self, request, view):
        return super().has_permission(request, view) and request.user.is_pandit


class PanditProfileViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing pandit profile
    """
    serializer_class = PanditProfileSerializer
    permission_classes = [IsPandit]
    
    def get_queryset(self):
        return PanditProfile.objects.filter(user=self.request.user)
    
    def get_object(self):
        """Get current pandit's profile"""
        try:
            return PanditProfile.objects.get(user=self.request.user)
        except PanditProfile.DoesNotExist:
            return None
    
    @action(detail=False, methods=['get'])
    def me(self, request):
        """Get current pandit's profile"""
        try:
            profile = PanditProfile.objects.get(user=request.user)
            serializer = self.get_serializer(profile)
            return Response(serializer.data)
        except PanditProfile.DoesNotExist:
            return Response(
                {'error': 'Pandit profile not found'},
                status=status.HTTP_404_NOT_FOUND
            )
    
    @action(detail=False, methods=['post'])
    def update_availability(self, request):
        """Update pandit availability status"""
        try:
            profile = PanditProfile.objects.get(user=request.user)
            availability = request.data.get('availability_status')
            
            if availability not in ['available', 'busy', 'offline']:
                return Response(
                    {'error': 'Invalid availability status'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            profile.availability_status = availability
            profile.save()
            
            return Response({
                'message': f'Availability updated to {availability}',
                'availability_status': profile.availability_status
            })
        except PanditProfile.DoesNotExist:
            return Response(
                {'error': 'Pandit profile not found'},
                status=status.HTTP_404_NOT_FOUND
            )


class ConsultationRequestViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing consultation requests (Pandit side)
    """
    serializer_class = ConsultationRequestSerializer
    permission_classes = [IsPandit]
    
    def get_queryset(self):
        """Get consultations for current pandit"""
        return ConsultationRequest.objects.filter(
            pandit=self.request.user
        ).select_related('user', 'pandit').order_by('-created_at')
    
    @action(detail=False, methods=['get'])
    def pending(self, request):
        """Get pending consultation requests (exclude blocked users, prioritize VIP users)"""
        pandit = request.user
        
        # Get blocked user IDs
        blocked_user_ids = BlockedUser.objects.filter(pandit=pandit).values_list('blocked_user_id', flat=True)
        
        # Get VIP user IDs
        vip_user_ids = VIPUser.objects.filter(pandit=pandit).values_list('vip_user_id', flat=True)
        
        # Filter out blocked users
        requests = self.get_queryset().filter(status='pending').exclude(user_id__in=blocked_user_ids)
        
        # Order: VIP users first, then by created_at (newest first)
        from django.db.models import Case, When, IntegerField
        requests = requests.annotate(
            is_vip=Case(
                When(user_id__in=vip_user_ids, then=1),
                default=0,
                output_field=IntegerField()
            )
        ).order_by('-is_vip', '-created_at')
        
        serializer = self.get_serializer(requests, many=True)
        
        # Add VIP flag to each request in response
        data = serializer.data
        for i, req_data in enumerate(data):
            req_data['is_vip'] = req_data['user'] in vip_user_ids
        
        return Response(data)
    
    @action(detail=False, methods=['get'])
    def active(self, request):
        """Get active/in-progress consultations"""
        requests = self.get_queryset().filter(
            status__in=['accepted', 'in_progress']
        )
        serializer = self.get_serializer(requests, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def history(self, request):
        """Get completed consultations"""
        requests = self.get_queryset().filter(status='completed')
        serializer = self.get_serializer(requests, many=True)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def accept(self, request, pk=None):
        """Accept a consultation request"""
        consultation = self.get_object()
        
        if consultation.status != 'pending':
            return Response(
                {'error': 'Consultation is not in pending status'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        consultation.status = 'accepted'
        consultation.accepted_at = timezone.now()
        consultation.save()
        
        # Auto-set pandit availability to busy when accepting a consultation
        try:
            profile = request.user.pandit_profile
            profile.availability_status = 'busy'
            profile.save()
        except PanditProfile.DoesNotExist:
            pass
        
        # TODO: Send notification to user
        
        serializer = self.get_serializer(consultation)
        return Response({
            'message': 'Consultation accepted',
            'consultation': serializer.data
        })
    
    @action(detail=True, methods=['post'])
    def reject(self, request, pk=None):
        """Reject a consultation request"""
        consultation = self.get_object()
        
        if consultation.status != 'pending':
            return Response(
                {'error': 'Consultation is not in pending status'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        consultation.status = 'rejected'
        consultation.save()
        
        # Refund to user wallet
        user = consultation.user
        user.wallet_balance += consultation.amount
        user.save()
        
        # TODO: Send notification to user
        
        return Response({
            'message': 'Consultation rejected and amount refunded to user'
        })
    
    @action(detail=True, methods=['post'])
    def start(self, request, pk=None):
        """Mark consultation as started"""
        consultation = self.get_object()
        
        if consultation.status != 'accepted':
            return Response(
                {'error': 'Consultation must be accepted first'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        consultation.status = 'in_progress'
        consultation.started_at = timezone.now()
        consultation.save()
        
        # Ensure pandit is marked as busy
        try:
            profile = request.user.pandit_profile
            profile.availability_status = 'busy'
            profile.save()
        except PanditProfile.DoesNotExist:
            pass
        
        serializer = self.get_serializer(consultation)
        return Response({
            'message': 'Consultation started',
            'consultation': serializer.data
        })
    
    @action(detail=True, methods=['post'])
    def complete(self, request, pk=None):
        """Mark consultation as completed"""
        consultation = self.get_object()
        
        if consultation.status not in ['accepted', 'in_progress']:
            return Response(
                {'error': 'Consultation is not active'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        consultation.status = 'completed'
        consultation.ended_at = timezone.now()
        consultation.save()
        
        # Credit pandit wallet
        pandit = consultation.pandit
        pandit.wallet_balance += consultation.pandit_earnings
        pandit.save()
        
        # Update pandit profile stats
        try:
            profile = pandit.pandit_profile
            profile.total_consultations += 1
            profile.total_earnings += consultation.pandit_earnings
            
            # Auto-set back to available if no other active consultations
            active_consultations = ConsultationRequest.objects.filter(
                pandit=pandit,
                status__in=['accepted', 'in_progress']
            ).exclude(id=consultation.id).exists()
            
            if not active_consultations:
                # Only set to available if they were previously available (not manually set to offline)
                # For now, we'll set to available - pandit can manually go offline if needed
                profile.availability_status = 'available'
            
            profile.save()
        except PanditProfile.DoesNotExist:
            pass
        
        # TODO: Send notification to user to rate
        
        serializer = self.get_serializer(consultation)
        return Response({
            'message': 'Consultation completed',
            'earnings': str(consultation.pandit_earnings),
            'consultation': serializer.data
        })

    @action(detail=True, methods=['post'])
    def update_notes(self, request, pk=None):
        """
        Update pandit notes and recommended remedies for a consultation.
        """
        consultation = self.get_object()
        pandit_notes = request.data.get('pandit_notes', '')
        recommended_remedies = request.data.get('recommended_remedies', '')

        consultation.pandit_notes = pandit_notes
        consultation.recommended_remedies = recommended_remedies
        consultation.save()

        return Response({
            'message': 'Notes updated successfully',
            'pandit_notes': consultation.pandit_notes,
            'recommended_remedies': consultation.recommended_remedies,
        })

    @action(detail=True, methods=['post'])
    def ai_remedies(self, request, pk=None):
        """
        Generate AI-based remedy suggestions for this consultation using Gemini.
        """
        consultation = self.get_object()

        # Defensive .env load (in case settings didn't already)
        base_dir = Path(__file__).resolve().parents[1]
        env_path = base_dir / '.env'
        if env_path.exists():
            load_dotenv(env_path)

        gemini_api_key = os.getenv('GEMINI_API_KEY')
        if not gemini_api_key:
            return Response(
                {'error': 'Gemini API key not configured. Please set GEMINI_API_KEY in your .env file'},
                status=status.HTTP_503_SERVICE_UNAVAILABLE,
            )

        client = genai.Client(api_key=gemini_api_key)

        focus = request.data.get('focus', 'overall life, career, relationships and health')
        extra_notes = request.data.get('notes', '')

        user_name = consultation.user.username
        service_type = consultation.service_type
        user_query = consultation.user_query or ''
        birth_details = consultation.birth_details or {}

        birth_text_parts = []
        dob = birth_details.get('date_of_birth') or birth_details.get('dob')
        tob = birth_details.get('time_of_birth') or birth_details.get('tob')
        place = birth_details.get('place_of_birth') or birth_details.get('birth_place')

        if dob:
            birth_text_parts.append(f"Date of Birth: {dob}")
        if tob:
            birth_text_parts.append(f"Time of Birth: {tob}")
        if place:
            birth_text_parts.append(f"Place of Birth: {place}")

        birth_text = "\n".join(birth_text_parts) if birth_text_parts else "Birth details not fully provided."

        prompt = f"""
You are an expert Vedic astrologer and remedy specialist. You are helping another pandit on PanditTalk.

User name: {user_name}
Service type: {service_type}

User's main query / concern:
\"\"\"
{user_query}
\"\"\"

Birth details (if provided):
{birth_text}

Pandit's current notes (if any):
\"\"\"
{consultation.pandit_notes}
\"\"\"

Additional focus or context from pandit:
\"\"\"
{extra_notes}
\"\"\"

TASK:
- Suggest practical, ethical, easy-to-follow remedies focused on: {focus}.
- Use a warm, spiritual but clear tone.
- Avoid making any extreme medical, financial or guaranteed-outcome claims.
- Prefer time-bound, realistic practices (mantras, simple fasts, donations, mindset shifts).

FORMAT THE ANSWER AS MARKDOWN WITH THESE SECTIONS:
1. **Overall Energy & Root Cause**
2. **Key Remedies (bullet list)** – each with: what, how, how often, and duration.
3. **Do’s and Don’ts**
4. **How to Explain This to the User (1 short paragraph)**
"""

        try:
            response = client.models.generate_content(
                model='gemini-2.0-flash',
                contents=[prompt],
                config=types.GenerateContentConfig(
                    temperature=0.8,
                    top_p=0.9,
                    top_k=40,
                    max_output_tokens=1200,
                ),
            )

            remedies_text = response.text or ''
            # Optionally store as latest recommended remedies
            consultation.recommended_remedies = remedies_text
            consultation.save(update_fields=['recommended_remedies'])

            return Response({
                'success': True,
                'remedies': remedies_text,
            })
        except Exception as e:
            import traceback
            logger.error(f"AI remedies error: {type(e).__name__}: {e}")
            logger.error(traceback.format_exc())
            error_msg = str(e)
            error_type = type(e).__name__

            if any(k in error_msg.lower() for k in ['quota', 'billing', '429', 'resource_exhausted', 'permission_denied', '403']):
                return Response(
                    {
                        'error': 'Gemini API quota exceeded or API key invalid. Please check your API key.',
                        'error_type': 'quota_exceeded',
                    },
                    status=status.HTTP_503_SERVICE_UNAVAILABLE,
                )

            if 'api_key' in error_msg.lower() or 'authentication' in error_msg.lower() or '401' in error_msg or 'unauthorized' in error_msg.lower():
                return Response(
                    {
                        'error': 'Invalid Gemini API key. Please set a valid GEMINI_API_KEY in your .env file',
                        'error_type': 'authentication_error',
                    },
                    status=status.HTTP_401_UNAUTHORIZED,
                )

            return Response(
                {
                    'error': f'AI remedy generation failed: {error_msg}',
                    'error_type': error_type,
                },
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )


@api_view(['GET'])
@permission_classes([IsPandit])
def pandit_dashboard(request):
    """
    Get dashboard statistics for pandit
    """
    pandit = request.user
    today = timezone.now().date()
    
    # Today's earnings and consultations
    today_consultations = ConsultationRequest.objects.filter(
        pandit=pandit,
        status='completed',
        ended_at__date=today
    )
    
    today_earnings = today_consultations.aggregate(
        total=Sum('pandit_earnings')
    )['total'] or Decimal('0.00')
    
    today_count = today_consultations.count()
    
    # Pending requests count
    pending_count = ConsultationRequest.objects.filter(
        pandit=pandit,
        status='pending'
    ).count()
    
    # Get profile stats
    try:
        profile = pandit.pandit_profile
        total_earnings = profile.total_earnings
        total_consultations = profile.total_consultations
        average_rating = profile.average_rating
        availability_status = profile.availability_status
    except PanditProfile.DoesNotExist:
        total_earnings = Decimal('0.00')
        total_consultations = 0
        average_rating = Decimal('0.00')
        availability_status = 'offline'
    
    data = {
        'today_earnings': today_earnings,
        'today_consultations': today_count,
        'pending_requests': pending_count,
        'total_earnings': total_earnings,
        'total_consultations': total_consultations,
        'average_rating': average_rating,
        'wallet_balance': pandit.wallet_balance,
        'availability_status': availability_status
    }
    
    serializer = PanditDashboardSerializer(data)
    return Response(serializer.data)


@api_view(['GET'])
@permission_classes([IsPandit])
def pandit_earnings(request):
    """
    Get detailed earnings breakdown
    """
    pandit = request.user
    period = request.query_params.get('period', 'month')  # day, week, month
    
    # Calculate date range
    today = timezone.now().date()
    if period == 'day':
        start_date = today
        period_label = 'Today'
    elif period == 'week':
        start_date = today - timedelta(days=7)
        period_label = 'This Week'
    else:  # month
        start_date = today - timedelta(days=30)
        period_label = 'This Month'
    
    # Get consultations in period
    consultations = ConsultationRequest.objects.filter(
        pandit=pandit,
        status='completed',
        ended_at__date__gte=start_date
    )
    
    # Calculate totals
    total_amount = consultations.aggregate(
        total=Sum('pandit_earnings')
    )['total'] or Decimal('0.00')
    
    # Breakdown by service type
    chat_earnings = consultations.filter(service_type='chat').aggregate(
        total=Sum('pandit_earnings')
    )['total'] or Decimal('0.00')
    
    call_earnings = consultations.filter(service_type='call').aggregate(
        total=Sum('pandit_earnings')
    )['total'] or Decimal('0.00')
    
    video_earnings = consultations.filter(service_type='video').aggregate(
        total=Sum('pandit_earnings')
    )['total'] or Decimal('0.00')
    
    data = {
        'period': period_label,
        'total_amount': total_amount,
        'consultations_count': consultations.count(),
        'chat_earnings': chat_earnings,
        'call_earnings': call_earnings,
        'video_earnings': video_earnings
    }
    
    serializer = EarningsSerializer(data)
    return Response(serializer.data)


class PanditPayoutViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing payout requests
    """
    serializer_class = PanditPayoutSerializer
    permission_classes = [IsPandit]
    
    def get_queryset(self):
        return PanditPayout.objects.filter(
            pandit=self.request.user
        ).order_by('-requested_at')
    
    def create(self, request):
        """Request a payout"""
        pandit = request.user
        amount = Decimal(request.data.get('amount', 0))
        
        # Validate amount
        if amount <= 0:
            return Response(
                {'error': 'Invalid amount'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if amount > pandit.wallet_balance:
            return Response(
                {'error': 'Insufficient balance'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Get bank details from profile
        try:
            profile = pandit.pandit_profile
            bank_account = profile.bank_account_number
            bank_ifsc = profile.bank_ifsc
            account_holder = profile.bank_account_holder
            
            if not all([bank_account, bank_ifsc, account_holder]):
                return Response(
                    {'error': 'Please complete your bank details in profile'},
                    status=status.HTTP_400_BAD_REQUEST
                )
        except PanditProfile.DoesNotExist:
            return Response(
                {'error': 'Pandit profile not found'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        # Deduct from wallet
        pandit.wallet_balance -= amount
        pandit.save()
        
        # Create payout request
        payout = PanditPayout.objects.create(
            pandit=pandit,
            amount=amount,
            bank_account_number=bank_account,
            bank_ifsc=bank_ifsc,
            bank_account_holder=account_holder,
            status='pending'
        )
        
        serializer = self.get_serializer(payout)
        return Response({
            'message': 'Payout requested successfully',
            'payout': serializer.data
        }, status=status.HTTP_201_CREATED)


class PanditReviewViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for viewing reviews (read-only for pandits)
    """
    serializer_class = PanditReviewSerializer
    permission_classes = [IsPandit]
    
    def get_queryset(self):
        return PanditReview.objects.filter(
            pandit=self.request.user
        ).select_related('user', 'consultation').order_by('-created_at')


@api_view(['POST', 'DELETE'])
@permission_classes([IsPandit])
def block_user(request, user_id):
    """
    Block or unblock a user
    POST: Block a user
    DELETE: Unblock a user
    """
    pandit = request.user
    try:
        user_to_block = CustomUser.objects.get(id=user_id)
    except CustomUser.DoesNotExist:
        return Response(
            {'error': 'User not found'},
            status=status.HTTP_404_NOT_FOUND
        )
    
    if request.method == 'POST':
        # Block user
        reason = request.data.get('reason', '')
        blocked, created = BlockedUser.objects.get_or_create(
            pandit=pandit,
            blocked_user=user_to_block,
            defaults={'reason': reason}
        )
        
        if not created:
            return Response(
                {'message': 'User is already blocked'},
                status=status.HTTP_200_OK
            )
        
        return Response({
            'message': f'User {user_to_block.username} has been blocked',
            'blocked_user_id': user_to_block.id
        })
    
    elif request.method == 'DELETE':
        # Unblock user
        try:
            blocked = BlockedUser.objects.get(pandit=pandit, blocked_user=user_to_block)
            blocked.delete()
            return Response({
                'message': f'User {user_to_block.username} has been unblocked'
            })
        except BlockedUser.DoesNotExist:
            return Response(
                {'error': 'User is not blocked'},
                status=status.HTTP_404_NOT_FOUND
            )


@api_view(['POST', 'DELETE'])
@permission_classes([IsPandit])
def vip_user(request, user_id):
    """
    Mark or unmark a user as VIP
    POST: Mark as VIP
    DELETE: Remove VIP status
    """
    pandit = request.user
    try:
        user_to_vip = CustomUser.objects.get(id=user_id)
    except CustomUser.DoesNotExist:
        return Response(
            {'error': 'User not found'},
            status=status.HTTP_404_NOT_FOUND
        )
    
    if request.method == 'POST':
        # Mark as VIP
        notes = request.data.get('notes', '')
        vip, created = VIPUser.objects.get_or_create(
            pandit=pandit,
            vip_user=user_to_vip,
            defaults={'notes': notes}
        )
        
        if not created:
            # Update notes if already VIP
            vip.notes = notes
            vip.save()
            return Response({
                'message': f'VIP notes updated for {user_to_vip.username}',
                'vip_user_id': user_to_vip.id
            })
        
        return Response({
            'message': f'User {user_to_vip.username} has been marked as VIP',
            'vip_user_id': user_to_vip.id
        })
    
    elif request.method == 'DELETE':
        # Remove VIP status
        try:
            vip = VIPUser.objects.get(pandit=pandit, vip_user=user_to_vip)
            vip.delete()
            return Response({
                'message': f'VIP status removed for {user_to_vip.username}'
            })
        except VIPUser.DoesNotExist:
            return Response(
                {'error': 'User is not marked as VIP'},
                status=status.HTTP_404_NOT_FOUND
            )


@api_view(['GET'])
@permission_classes([IsPandit])
def get_blocked_users(request):
    """Get list of blocked users"""
    pandit = request.user
    blocked = BlockedUser.objects.filter(pandit=pandit).select_related('blocked_user')
    
    data = [{
        'user_id': b.blocked_user.id,
        'username': b.blocked_user.username,
        'phone': b.blocked_user.phone,
        'reason': b.reason,
        'blocked_at': b.created_at.isoformat()
    } for b in blocked]
    
    return Response(data)


@api_view(['GET'])
@permission_classes([IsPandit])
def get_vip_users(request):
    """Get list of VIP users"""
    pandit = request.user
    vip_users = VIPUser.objects.filter(pandit=pandit).select_related('vip_user')
    
    data = [{
        'user_id': v.vip_user.id,
        'username': v.vip_user.username,
        'phone': v.vip_user.phone,
        'notes': v.notes,
        'marked_at': v.created_at.isoformat()
    } for v in vip_users]
    
    return Response(data)

