"""
API Views for User Consultation Features
Handles consultation booking and pandit browsing
"""
from rest_framework import viewsets, status
from rest_framework.decorators import action, api_view, permission_classes
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from django.db.models import Q

from .models import CustomUser, PanditProfile, ConsultationRequest, PanditReview
from .pandit_serializers import (
    PanditListSerializer, ConsultationRequestSerializer,
    ConsultationRequestCreateSerializer, PanditReviewSerializer
)


class AvailablePanditsViewSet(viewsets.ReadOnlyModelViewSet):
    """
    ViewSet for browsing available pandits (User App)
    """
    serializer_class = PanditListSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        """Get verified pandits with profiles"""
        queryset = CustomUser.objects.filter(
            is_pandit=True,
            pandit_profile__is_verified=True
        ).select_related('pandit_profile')
        
        # Filter by availability
        availability = self.request.query_params.get('availability')
        if availability:
            queryset = queryset.filter(pandit_profile__availability_status=availability)
        
        # Filter by specialization
        specialization = self.request.query_params.get('specialization')
        if specialization:
            queryset = queryset.filter(
                pandit_profile__specializations__contains=[specialization]
            )
        
        # Filter by language
        language = self.request.query_params.get('language')
        if language:
            queryset = queryset.filter(
                pandit_profile__languages__contains=[language]
            )
        
        # Search by name
        search = self.request.query_params.get('search')
        if search:
            queryset = queryset.filter(
                Q(username__icontains=search) | Q(bio__icontains=search)
            )
        
        return queryset.order_by('-pandit_profile__average_rating')


class UserConsultationViewSet(viewsets.ModelViewSet):
    """
    ViewSet for user's consultations
    """
    serializer_class = ConsultationRequestSerializer
    permission_classes = [IsAuthenticated]
    
    def get_queryset(self):
        """Get consultations for current user"""
        return ConsultationRequest.objects.filter(
            user=self.request.user
        ).select_related('user', 'pandit').order_by('-created_at')
    
    def get_serializer_class(self):
        """Use different serializer for creation"""
        if self.action == 'create':
            return ConsultationRequestCreateSerializer
        return ConsultationRequestSerializer
    
    @action(detail=False, methods=['get'])
    def active(self, request):
        """Get active consultations"""
        consultations = self.get_queryset().filter(
            status__in=['pending', 'accepted', 'in_progress']
        )
        serializer = self.get_serializer(consultations, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def history(self, request):
        """Get completed consultations"""
        consultations = self.get_queryset().filter(status='completed')
        serializer = self.get_serializer(consultations, many=True)
        return Response(serializer.data)
    
    @action(detail=True, methods=['post'])
    def rate(self, request, pk=None):
        """Rate a consultation"""
        consultation = self.get_object()
        
        if consultation.status != 'completed':
            return Response(
                {'error': 'Can only rate completed consultations'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        if consultation.user_rating:
            return Response(
                {'error': 'Consultation already rated'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        rating = request.data.get('rating')
        review_text = request.data.get('review', '')
        
        if not rating or not (1 <= int(rating) <= 5):
            return Response(
                {'error': 'Rating must be between 1 and 5'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        # Save rating on consultation
        consultation.user_rating = rating
        consultation.user_review = review_text
        consultation.save()
        
        # Create review
        review = PanditReview.objects.create(
            consultation=consultation,
            pandit=consultation.pandit,
            user=consultation.user,
            rating=rating,
            review_text=review_text
        )
        
        # Update pandit's average rating
        pandit_profile = consultation.pandit.pandit_profile
        pandit_profile.total_reviews += 1
        
        # Recalculate average rating
        all_reviews = PanditReview.objects.filter(pandit=consultation.pandit)
        total_rating = sum(r.rating for r in all_reviews)
        pandit_profile.average_rating = total_rating / all_reviews.count()
        pandit_profile.save()
        
        serializer = self.get_serializer(consultation)
        return Response({
            'message': 'Rating submitted successfully',
            'consultation': serializer.data
        })
    
    @action(detail=True, methods=['post'])
    def cancel(self, request, pk=None):
        """Cancel a consultation"""
        consultation = self.get_object()
        
        if consultation.status not in ['pending', 'accepted']:
            return Response(
                {'error': 'Can only cancel pending or accepted consultations'},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        consultation.status = 'cancelled'
        consultation.save()
        
        # Refund to user wallet
        user = consultation.user
        user.wallet_balance += consultation.amount
        user.save()
        
        # TODO: Send notification to pandit
        
        return Response({
            'message': 'Consultation cancelled and amount refunded'
        })


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def pandit_detail(request, pandit_id):
    """
    Get detailed information about a specific pandit
    """
    try:
        pandit = CustomUser.objects.get(id=pandit_id, is_pandit=True)
        serializer = PanditListSerializer(pandit)
        
        # Get recent reviews
        recent_reviews = PanditReview.objects.filter(
            pandit=pandit
        ).select_related('user').order_by('-created_at')[:10]
        
        review_serializer = PanditReviewSerializer(recent_reviews, many=True)
        
        return Response({
            'pandit': serializer.data,
            'recent_reviews': review_serializer.data
        })
    except CustomUser.DoesNotExist:
        return Response(
            {'error': 'Pandit not found'},
            status=status.HTTP_404_NOT_FOUND
        )

