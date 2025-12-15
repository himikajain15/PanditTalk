from django.contrib import admin
from .models import Booking, ChatThread, ChatMessage

@admin.register(Booking)
class BookingAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'pandit', 'scheduled_at', 'duration_minutes', 'status')
    list_filter = ('status',)
    search_fields = ('user__username', 'pandit__user__username')

@admin.register(ChatThread)
class ChatThreadAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'pandit', 'created_at')
    search_fields = ('user__username', 'pandit__user__username')

@admin.register(ChatMessage)
class ChatMessageAdmin(admin.ModelAdmin):
    list_display = ('id', 'thread', 'sender_user', 'is_system', 'created_at')
    search_fields = ('sender_user__username', 'text')
