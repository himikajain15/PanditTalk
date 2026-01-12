from django.contrib import admin
from .models import Booking, ChatThread, ChatMessage
from .models_referral import Referral
from .models_testimonials import Testimonial
from .models_calendar import CalendarEvent
from .models_scheduler import LiveSessionSlot
from .models_ruby import RubyRegistration

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

@admin.register(Referral)
class ReferralAdmin(admin.ModelAdmin):
    list_display = ('id', 'referrer', 'referred_user', 'referral_code', 'credits_earned', 'is_active', 'created_at')
    list_filter = ('is_active', 'first_booking_completed')
    search_fields = ('referrer__username', 'referral_code', 'referred_phone')

@admin.register(Testimonial)
class TestimonialAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'pandit', 'rating', 'title', 'is_featured', 'is_approved', 'created_at')
    list_filter = ('is_approved', 'is_featured', 'rating')
    search_fields = ('user__username', 'title', 'content')
    list_editable = ('is_approved', 'is_featured')

@admin.register(CalendarEvent)
class CalendarEventAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'event_type', 'title', 'date', 'time', 'is_public', 'created_at')
    list_filter = ('event_type', 'is_public', 'is_recurring')
    search_fields = ('title', 'description')

@admin.register(LiveSessionSlot)
class LiveSessionSlotAdmin(admin.ModelAdmin):
    list_display = ('id', 'pandit', 'date', 'start_time', 'end_time', 'is_booked', 'booked_by', 'created_at')
    list_filter = ('is_booked', 'date')
    search_fields = ('pandit__user__username', 'booked_by__username')

@admin.register(RubyRegistration)
class RubyRegistrationAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'full_name', 'phone', 'city', 'state', 'status', 'created_at')
    list_filter = ('status', 'state', 'city')
    search_fields = ('user__username', 'full_name', 'phone', 'pincode')
    list_editable = ('status',)
    readonly_fields = ('created_at', 'updated_at')
