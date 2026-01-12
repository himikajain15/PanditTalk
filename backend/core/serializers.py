from rest_framework import serializers
from django.db import models
from .models import PanditProfile, Booking, ChatThread, ChatMessage
from .models_referral import Referral
from .models_testimonials import Testimonial
from .models_calendar import CalendarEvent
from .models_scheduler import LiveSessionSlot
from .models_ruby import RubyRegistration
from users.serializers import UserSerializer
from users.models import CustomUser

class PanditProfileSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)

    class Meta:
        model = PanditProfile
        fields = ['id', 'user', 'languages', 'expertise', 'experience_years', 'fee_per_minute', 'rating', 'is_online', 'created_at']

class BookingSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    pandit = PanditProfileSerializer(read_only=True)
    pandit_id = serializers.PrimaryKeyRelatedField(write_only=True, queryset=PanditProfile.objects.all(), source='pandit')

    class Meta:
        model = Booking
        fields = ['id', 'user', 'pandit', 'pandit_id', 'scheduled_at', 'duration_minutes', 'status', 'notes', 'created_at']
        read_only_fields = ['status', 'created_at']

    def create(self, validated_data):
        request = self.context.get('request')
        user = request.user if request else None
        validated_data['user'] = user
        booking = super().create(validated_data)
        return booking

class ChatMessageSerializer(serializers.ModelSerializer):
    sender = serializers.SerializerMethodField()

    class Meta:
        model = ChatMessage
        fields = ['id', 'thread', 'sender_user', 'sender', 'text', 'is_system', 'created_at']
        read_only_fields = ['sender_user', 'is_system', 'created_at']

    def get_sender(self, obj):
        return obj.sender_user.username if obj.sender_user else None

class ChatThreadSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    pandit = PanditProfileSerializer(read_only=True)
    messages = ChatMessageSerializer(many=True, read_only=True)

    class Meta:
        model = ChatThread
        fields = ['id', 'booking', 'user', 'pandit', 'messages', 'created_at']
        read_only_fields = ['created_at']

    def create(self, validated_data):
        request = self.context.get('request')
        user = request.user if request else None
        validated_data['user'] = user
        thread = super().create(validated_data)
        return thread


# Referral Serializers
class ReferralSerializer(serializers.ModelSerializer):
    referrer = UserSerializer(read_only=True)
    referred_user = UserSerializer(read_only=True)
    total_referrals = serializers.SerializerMethodField()
    total_credits_earned = serializers.SerializerMethodField()

    class Meta:
        model = Referral
        fields = ['id', 'referrer', 'referred_user', 'referral_code', 'referred_phone',
                  'credits_earned', 'credits_given', 'is_active', 'first_booking_completed',
                  'created_at', 'credits_credited_at', 'total_referrals', 'total_credits_earned']
        read_only_fields = ['referrer', 'created_at', 'credits_credited_at']

    def get_total_referrals(self, obj):
        return Referral.objects.filter(referrer=obj.referrer, is_active=True).count()

    def get_total_credits_earned(self, obj):
        return Referral.objects.filter(referrer=obj.referrer).aggregate(
            total=models.Sum('credits_earned')
        )['total'] or 0


# Testimonial Serializers
class TestimonialSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)
    pandit_name = serializers.SerializerMethodField()

    class Meta:
        model = Testimonial
        fields = ['id', 'user', 'pandit', 'pandit_name', 'rating', 'title', 'content',
                  'is_featured', 'is_approved', 'created_at', 'updated_at']
        read_only_fields = ['user', 'created_at', 'updated_at']

    def get_pandit_name(self, obj):
        return obj.pandit.user.username if obj.pandit else None


# Calendar Event Serializers
class CalendarEventSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)

    class Meta:
        model = CalendarEvent
        fields = ['id', 'user', 'event_type', 'title', 'description', 'date', 'time',
                  'is_recurring', 'recurring_pattern', 'is_public', 'created_at']
        read_only_fields = ['user', 'created_at']


# Live Session Slot Serializers
class LiveSessionSlotSerializer(serializers.ModelSerializer):
    pandit = PanditProfileSerializer(read_only=True)
    pandit_id = serializers.PrimaryKeyRelatedField(
        write_only=True, queryset=PanditProfile.objects.all(), source='pandit', required=False
    )
    booked_by_user = UserSerializer(read_only=True, source='booked_by')

    class Meta:
        model = LiveSessionSlot
        fields = ['id', 'pandit', 'pandit_id', 'date', 'start_time', 'end_time',
                  'is_booked', 'booked_by', 'booked_by_user', 'booking', 'created_at']
        read_only_fields = ['is_booked', 'booked_by', 'booking', 'created_at']


# Ruby Registration Serializers
class RubyRegistrationSerializer(serializers.ModelSerializer):
    user = UserSerializer(read_only=True)

    class Meta:
        model = RubyRegistration
        fields = ['id', 'user', 'full_name', 'phone', 'full_address', 'city', 'state',
                  'pincode', 'landmark', 'status', 'admin_notes', 'created_at', 'updated_at']
        read_only_fields = ['user', 'status', 'admin_notes', 'created_at', 'updated_at']
