"""
Serializers for Pandit-specific models
"""
from rest_framework import serializers
from .models import CustomUser, PanditProfile, ConsultationRequest, PanditPayout, PanditReview
from decimal import Decimal


class PanditProfileSerializer(serializers.ModelSerializer):
    """Serializer for PanditProfile model"""
    username = serializers.CharField(source='user.username', read_only=True)
    phone = serializers.CharField(source='user.phone', read_only=True)
    profile_pic = serializers.CharField(source='user.profile_pic', read_only=True)
    
    class Meta:
        model = PanditProfile
        fields = [
            'id', 'username', 'phone', 'profile_pic',
            'is_verified', 'specializations', 'languages', 'experience_years',
            'chat_rate', 'call_rate', 'video_rate',
            'availability_status', 'working_hours',
            'bank_account_number', 'bank_ifsc', 'bank_account_holder', 'pan_number',
            'total_earnings', 'total_consultations', 'average_rating', 'total_reviews',
            'created_at', 'updated_at'
        ]
        read_only_fields = ['total_earnings', 'total_consultations', 'average_rating', 'total_reviews', 'created_at', 'updated_at']


class ConsultationRequestSerializer(serializers.ModelSerializer):
    """Serializer for ConsultationRequest model"""
    user_name = serializers.CharField(source='user.username', read_only=True)
    user_phone = serializers.CharField(source='user.phone', read_only=True)
    user_profile_pic = serializers.CharField(source='user.profile_pic', read_only=True)
    
    pandit_name = serializers.CharField(source='pandit.username', read_only=True)
    pandit_phone = serializers.CharField(source='pandit.phone', read_only=True)
    pandit_profile_pic = serializers.CharField(source='pandit.profile_pic', read_only=True)
    
    class Meta:
        model = ConsultationRequest
        fields = [
            'id', 'user', 'pandit', 'user_name', 'user_phone', 'user_profile_pic',
            'pandit_name', 'pandit_phone', 'pandit_profile_pic',
            'service_type', 'duration', 'user_query', 'birth_details',
            'amount', 'commission_percentage', 'commission_amount', 'pandit_earnings', 'payment_status',
            'status', 'created_at', 'accepted_at', 'started_at', 'ended_at',
            'user_rating', 'user_review'
        ]
        read_only_fields = ['commission_amount', 'pandit_earnings', 'created_at', 'accepted_at', 'started_at', 'ended_at']


class ConsultationRequestCreateSerializer(serializers.ModelSerializer):
    """Serializer for creating consultation requests"""
    
    class Meta:
        model = ConsultationRequest
        fields = [
            'pandit', 'service_type', 'duration', 'user_query', 
            'birth_details', 'amount'
        ]
    
    def validate(self, data):
        """Validate consultation request data"""
        user = self.context['request'].user
        pandit = data.get('pandit')
        
        # Check if pandit exists and is actually a pandit
        if not pandit.is_pandit:
            raise serializers.ValidationError("Selected user is not a pandit")
        
        # Check if pandit is available
        try:
            pandit_profile = pandit.pandit_profile
            if pandit_profile.availability_status == 'offline':
                raise serializers.ValidationError("Pandit is currently offline")
        except PanditProfile.DoesNotExist:
            raise serializers.ValidationError("Pandit profile not found")
        
        # Check if user has sufficient balance
        if user.wallet_balance < data.get('amount', 0):
            raise serializers.ValidationError("Insufficient wallet balance")
        
        return data
    
    def create(self, validated_data):
        """Create consultation request and deduct from user wallet"""
        user = self.context['request'].user
        amount = validated_data['amount']
        
        # Deduct from user wallet
        user.wallet_balance -= amount
        user.save()
        
        # Create consultation request
        consultation = ConsultationRequest.objects.create(
            user=user,
            **validated_data
        )
        
        return consultation


class PanditPayoutSerializer(serializers.ModelSerializer):
    """Serializer for PanditPayout model"""
    pandit_name = serializers.CharField(source='pandit.username', read_only=True)
    pandit_phone = serializers.CharField(source='pandit.phone', read_only=True)
    
    class Meta:
        model = PanditPayout
        fields = [
            'id', 'pandit', 'pandit_name', 'pandit_phone',
            'amount', 'bank_account_number', 'bank_ifsc', 'bank_account_holder',
            'status', 'transaction_id', 'admin_notes',
            'requested_at', 'processed_at'
        ]
        read_only_fields = ['pandit', 'status', 'transaction_id', 'admin_notes', 'requested_at', 'processed_at']


class PanditReviewSerializer(serializers.ModelSerializer):
    """Serializer for PanditReview model"""
    user_name = serializers.CharField(source='user.username', read_only=True)
    user_profile_pic = serializers.CharField(source='user.profile_pic', read_only=True)
    consultation_service = serializers.CharField(source='consultation.service_type', read_only=True)
    
    class Meta:
        model = PanditReview
        fields = [
            'id', 'consultation', 'pandit', 'user', 
            'user_name', 'user_profile_pic', 'consultation_service',
            'rating', 'review_text', 'created_at'
        ]
        read_only_fields = ['created_at']


class PanditListSerializer(serializers.ModelSerializer):
    """Simplified serializer for listing pandits (for User App)"""
    profile = PanditProfileSerializer(source='pandit_profile', read_only=True)
    
    class Meta:
        model = CustomUser
        fields = ['id', 'username', 'phone', 'profile_pic', 'bio', 'profile']


class PanditDashboardSerializer(serializers.Serializer):
    """Serializer for pandit dashboard statistics"""
    today_earnings = serializers.DecimalField(max_digits=10, decimal_places=2)
    today_consultations = serializers.IntegerField()
    pending_requests = serializers.IntegerField()
    total_earnings = serializers.DecimalField(max_digits=10, decimal_places=2)
    total_consultations = serializers.IntegerField()
    average_rating = serializers.DecimalField(max_digits=3, decimal_places=2)
    wallet_balance = serializers.DecimalField(max_digits=10, decimal_places=2)
    availability_status = serializers.CharField()


class EarningsSerializer(serializers.Serializer):
    """Serializer for earnings data"""
    period = serializers.CharField()  # 'today', 'week', 'month'
    total_amount = serializers.DecimalField(max_digits=10, decimal_places=2)
    consultations_count = serializers.IntegerField()
    chat_earnings = serializers.DecimalField(max_digits=10, decimal_places=2)
    call_earnings = serializers.DecimalField(max_digits=10, decimal_places=2)
    video_earnings = serializers.DecimalField(max_digits=10, decimal_places=2)

