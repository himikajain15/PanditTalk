from rest_framework import generics, permissions, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from .models import PanditProfile, Booking, ChatThread, ChatMessage
from .serializers import (
    PanditProfileSerializer, BookingSerializer,
    ChatThreadSerializer, ChatMessageSerializer
)
from django.shortcuts import get_object_or_404
from users.models import CustomUser
from .google_sheets_service import GoogleSheetsService
import logging

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
