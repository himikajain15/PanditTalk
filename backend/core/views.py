from rest_framework import generics, permissions, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from .models import PanditProfile, Booking, ChatThread, ChatMessage
from .models_referral import Referral
from .models_testimonials import Testimonial
from .models_calendar import CalendarEvent
from .models_scheduler import LiveSessionSlot
from .models_ruby import RubyRegistration
from .serializers import (
    PanditProfileSerializer, BookingSerializer,
    ChatThreadSerializer, ChatMessageSerializer,
    ReferralSerializer, TestimonialSerializer,
    CalendarEventSerializer, LiveSessionSlotSerializer,
    RubyRegistrationSerializer
)
from django.shortcuts import get_object_or_404
from django.utils import timezone
from django.db.models import Q, Sum
from users.models import CustomUser
from .google_sheets_service import GoogleSheetsService
import logging
import string
import random
from datetime import datetime, timedelta

logger = logging.getLogger(__name__)

# List and detail views for Pandits
class PanditListView(generics.ListAPIView):
    queryset = PanditProfile.objects.select_related('user').all()
    serializer_class = PanditProfileSerializer
    permission_classes = [permissions.AllowAny]

class PanditDetailView(generics.RetrieveAPIView):
    queryset = PanditProfile.objects.select_related('user').all()
    serializer_class = PanditProfileSerializer
    permission_classes = [permissions.AllowAny]

# Booking endpoints: create and list user's bookings
class BookingCreateView(generics.CreateAPIView):
    serializer_class = BookingSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_serializer_context(self):
        ctx = super().get_serializer_context()
        ctx.update({'request': self.request})
        return ctx

class BookingListView(generics.ListAPIView):
    serializer_class = BookingSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Booking.objects.filter(user=self.request.user).order_by('-created_at')

class BookingDetailView(generics.RetrieveAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = BookingSerializer
    lookup_url_kwarg = 'pk'

    def get_queryset(self):
        return Booking.objects.filter(user=self.request.user)

# Chat threads and messages (REST-based)
class ChatThreadListCreateView(generics.ListCreateAPIView):
    serializer_class = ChatThreadSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return ChatThread.objects.filter(user=self.request.user).order_by('-created_at')

    def get_serializer_context(self):
        ctx = super().get_serializer_context()
        ctx.update({'request': self.request})
        return ctx

class ChatMessageListCreateView(generics.ListCreateAPIView):
    serializer_class = ChatMessageSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        thread_id = self.kwargs.get('thread_id')
        thread = get_object_or_404(ChatThread, id=thread_id)
        # ensure user is participant
        if thread.user != self.request.user and thread.pandit.user != self.request.user:
            return ChatMessage.objects.none()
        return ChatMessage.objects.filter(thread=thread).order_by('created_at')

    def perform_create(self, serializer):
        thread_id = self.kwargs.get('thread_id')
        thread = get_object_or_404(ChatThread, id=thread_id)
        # ensure the requester can post
        if thread.user != self.request.user and thread.pandit.user != self.request.user:
            raise PermissionError("Not part of thread")
        serializer.save(sender_user=self.request.user, thread=thread)


@api_view(['POST', 'GET'])
@permission_classes([permissions.AllowAny])
def sync_pandits_from_sheets(request):
    """
    Sync Pandit data from Google Sheets.
    GET: Returns list of pandits from sheet (without syncing)
    POST: Syncs pandits from Google Sheets to database (creates/updates users and profiles)
    """
    sheets_service = GoogleSheetsService()
    
    if not sheets_service.is_available():
        return Response({
            "error": "Google Sheets integration not configured. Please set GOOGLE_SHEET_ID and GOOGLE_CREDENTIALS_JSON environment variables."
        }, status=status.HTTP_503_SERVICE_UNAVAILABLE)
    
    try:
        pandits_data = sheets_service.fetch_pandits_from_sheet()
        
        if request.method == 'GET':
            # Just return the data without syncing
            return Response({
                "count": len(pandits_data),
                "pandits": pandits_data
            }, status=status.HTTP_200_OK)
        
        # POST: Sync to database
        synced_count = 0
        updated_count = 0
        errors = []
        
        for pandit_data in pandits_data:
            try:
                phone = pandit_data.get('phone', '').strip()
                email = pandit_data.get('email', '').strip()
                name = pandit_data.get('name', '').strip()
                
                if not phone and not email:
                    errors.append(f"Skipping {name}: No phone or email")
                    continue
                
                # Try to find existing user by phone or email
                user = None
                if phone:
                    try:
                        user = CustomUser.objects.get(phone=phone)
                    except CustomUser.DoesNotExist:
                        pass
                
                if not user and email:
                    try:
                        user = CustomUser.objects.get(email=email)
                    except CustomUser.DoesNotExist:
                        pass
                
                # Create user if doesn't exist
                if not user:
                    username = phone.replace('+', '').replace(' ', '') if phone else email.split('@')[0]
                    # Ensure username is unique
                    base_username = username
                    counter = 1
                    while CustomUser.objects.filter(username=username).exists():
                        username = f"{base_username}{counter}"
                        counter += 1
                    
                    user = CustomUser.objects.create_user(
                        username=username,
                        email=email or f"{username}@pandittalk.com",
                        phone=phone,
                        is_pandit=True
                    )
                
                # Update user info
                if phone and not user.phone:
                    user.phone = phone
                if email and not user.email:
                    user.email = email
                user.is_pandit = True
                user.save()
                
                # Get or create PanditProfile
                pandit_profile, created = PanditProfile.objects.get_or_create(
                    user=user,
                    defaults={
                        'languages': pandit_data.get('languages', []),
                        'expertise': pandit_data.get('expertise', ''),
                        'experience_years': pandit_data.get('experience_years', 0),
                        'fee_per_minute': pandit_data.get('fee_per_minute', 0.0),
                        'rating': pandit_data.get('rating', 0.0),
                        'is_online': pandit_data.get('is_online', False),
                    }
                )
                
                if not created:
                    # Update existing profile
                    pandit_profile.languages = pandit_data.get('languages', [])
                    pandit_profile.expertise = pandit_data.get('expertise', '')
                    pandit_profile.experience_years = pandit_data.get('experience_years', 0)
                    pandit_profile.fee_per_minute = pandit_data.get('fee_per_minute', 0.0)
                    pandit_profile.rating = pandit_data.get('rating', 0.0)
                    pandit_profile.is_online = pandit_data.get('is_online', False)
                    pandit_profile.save()
                    updated_count += 1
                else:
                    synced_count += 1
                    
            except Exception as e:
                logger.error(f"Error syncing pandit {pandit_data.get('name')}: {e}")
                errors.append(f"Error syncing {pandit_data.get('name')}: {str(e)}")
        
        return Response({
            "success": True,
            "synced": synced_count,
            "updated": updated_count,
            "total": len(pandits_data),
            "errors": errors[:10] if errors else []  # Limit errors shown
        }, status=status.HTTP_200_OK)
        
    except Exception as e:
        logger.error(f"Error syncing pandits from Google Sheets: {e}")
        return Response({
            "error": str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


# ========== REFERRAL API ENDPOINTS ==========
class ReferralCreateView(generics.ListCreateAPIView):
    """Create or get user's referral code"""
    serializer_class = ReferralSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Referral.objects.filter(referrer=self.request.user)

    def perform_create(self, serializer):
        user = self.request.user
        # Check if user already has a referral code
        existing = Referral.objects.filter(referrer=user).first()
        if existing:
            # Return existing instead of creating new
            return
        
        # Generate unique referral code
        code = self._generate_referral_code(user)
        serializer.save(referrer=user, referral_code=code)

    def _generate_referral_code(self, user):
        """Generate a unique referral code based on username"""
        base = user.username.upper()[:6]
        random_part = ''.join(random.choices(string.ascii_uppercase + string.digits, k=4))
        code = f"{base}{random_part}"
        
        # Ensure uniqueness
        while Referral.objects.filter(referral_code=code).exists():
            random_part = ''.join(random.choices(string.ascii_uppercase + string.digits, k=4))
            code = f"{base}{random_part}"
        
        return code


class ReferralDetailView(generics.RetrieveAPIView):
    """Get user's referral details"""
    serializer_class = ReferralSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        referral, _ = Referral.objects.get_or_create(referrer=self.request.user)
        if not referral.referral_code:
            # Generate code if missing
            base = self.request.user.username.upper()[:6]
            random_part = ''.join(random.choices(string.ascii_uppercase + string.digits, k=4))
            code = f"{base}{random_part}"
            while Referral.objects.filter(referral_code=code).exists():
                random_part = ''.join(random.choices(string.ascii_uppercase + string.digits, k=4))
                code = f"{base}{random_part}"
            referral.referral_code = code
            referral.save()
        return referral


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def use_referral_code(request):
    """Use a referral code during registration"""
    code = request.data.get('referral_code', '').strip().upper()
    if not code:
        return Response({'error': 'Referral code is required'}, status=status.HTTP_400_BAD_REQUEST)
    
    try:
        referral = Referral.objects.get(referral_code=code, is_active=True)
        if referral.referrer == request.user:
            return Response({'error': 'Cannot use your own referral code'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Check if user already used a referral code
        if Referral.objects.filter(referred_user=request.user).exists():
            return Response({'error': 'You have already used a referral code'}, status=status.HTTP_400_BAD_REQUEST)
        
        # Link user to referral
        referral.referred_user = request.user
        referral.save()
        
        return Response({
            'success': True,
            'message': 'Referral code applied successfully',
            'referrer': referral.referrer.username
        })
    except Referral.DoesNotExist:
        return Response({'error': 'Invalid referral code'}, status=status.HTTP_404_NOT_FOUND)


# ========== TESTIMONIAL API ENDPOINTS ==========
class TestimonialListCreateView(generics.ListCreateAPIView):
    """List all approved testimonials or create new one"""
    serializer_class = TestimonialSerializer
    permission_classes = [permissions.AllowAny]

    def get_queryset(self):
        # For authenticated users, show their own + approved ones
        if self.request.user.is_authenticated:
            return Testimonial.objects.filter(
                Q(is_approved=True) | Q(user=self.request.user)
            ).order_by('-is_featured', '-created_at')
        # For anonymous, only approved
        return Testimonial.objects.filter(is_approved=True).order_by('-is_featured', '-created_at')

    def perform_create(self, serializer):
        if not self.request.user.is_authenticated:
            raise permissions.NotAuthenticated('Authentication required')
        serializer.save(user=self.request.user, is_approved=False)  # Requires admin approval


class TestimonialDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete a testimonial"""
    serializer_class = TestimonialSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Testimonial.objects.filter(user=self.request.user)


# ========== CALENDAR API ENDPOINTS ==========
class CalendarEventListCreateView(generics.ListCreateAPIView):
    """List calendar events or create new one"""
    serializer_class = CalendarEventSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        date_from = self.request.query_params.get('date_from')
        date_to = self.request.query_params.get('date_to')
        
        queryset = CalendarEvent.objects.filter(
            Q(user=self.request.user) | Q(is_public=True)
        )
        
        if date_from:
            queryset = queryset.filter(date__gte=date_from)
        if date_to:
            queryset = queryset.filter(date__lte=date_to)
        
        return queryset.order_by('date', 'time')

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)


class CalendarEventDetailView(generics.RetrieveUpdateDestroyAPIView):
    """Get, update, or delete a calendar event"""
    serializer_class = CalendarEventSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return CalendarEvent.objects.filter(user=self.request.user)


# ========== LIVE SESSION SCHEDULER API ENDPOINTS ==========
class LiveSessionSlotListCreateView(generics.ListCreateAPIView):
    """List available slots or create new slots"""
    serializer_class = LiveSessionSlotSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        date = self.request.query_params.get('date')
        pandit_id = self.request.query_params.get('pandit_id')
        
        queryset = LiveSessionSlot.objects.filter(is_booked=False)
        
        if date:
            queryset = queryset.filter(date=date)
        if pandit_id:
            queryset = queryset.filter(pandit_id=pandit_id)
        
        return queryset.order_by('date', 'start_time')

    def perform_create(self, serializer):
        # Only pandits can create slots
        if not hasattr(self.request.user, 'panditprofile'):
            raise permissions.PermissionDenied('Only pandits can create slots')
        serializer.save(pandit=self.request.user.panditprofile)


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def book_live_session_slot(request, slot_id):
    """Book a live session slot"""
    try:
        slot = LiveSessionSlot.objects.get(id=slot_id, is_booked=False)
        
        # Create booking
        booking = Booking.objects.create(
            user=request.user,
            pandit=slot.pandit,
            scheduled_at=timezone.make_aware(
                datetime.combine(slot.date, slot.start_time)
            ),
            duration_minutes=30,  # Default 30 minutes
            status=Booking.STATUS_CONFIRMED
        )
        
        # Mark slot as booked
        slot.is_booked = True
        slot.booked_by = request.user
        slot.booking = booking
        slot.save()
        
        return Response({
            'success': True,
            'booking_id': booking.id,
            'slot_id': slot.id,
            'message': 'Slot booked successfully'
        })
    except LiveSessionSlot.DoesNotExist:
        return Response({'error': 'Slot not available'}, status=status.HTTP_404_NOT_FOUND)


# ========== RUBY REGISTRATION API ENDPOINTS ==========
class RubyRegistrationCreateView(generics.CreateAPIView):
    """Create ruby registration"""
    serializer_class = RubyRegistrationSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        # Check if user already registered
        if RubyRegistration.objects.filter(user=self.request.user).exists():
            from rest_framework.exceptions import ValidationError
            raise ValidationError('You have already registered for the Ruby freebie')
        
        serializer.save(user=self.request.user, status='pending')


class RubyRegistrationDetailView(generics.RetrieveAPIView):
    """Get user's ruby registration status"""
    serializer_class = RubyRegistrationSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        return get_object_or_404(RubyRegistration, user=self.request.user)
