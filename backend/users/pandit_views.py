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

from .models import CustomUser, PanditProfile, ConsultationRequest, PanditPayout, PanditReview
from .pandit_serializers import (
    PanditProfileSerializer, ConsultationRequestSerializer,
    PanditPayoutSerializer, PanditReviewSerializer,
    PanditDashboardSerializer, EarningsSerializer
)


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
        """Get pending consultation requests"""
        requests = self.get_queryset().filter(status='pending')
        serializer = self.get_serializer(requests, many=True)
        return Response(serializer.data)
    
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
        
        # Update pandit availability to busy
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
            profile.availability_status = 'available'  # Back to available
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

