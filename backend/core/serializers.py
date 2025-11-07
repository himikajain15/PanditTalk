from rest_framework import serializers
from .models import PanditProfile, Booking, ChatThread, ChatMessage
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
