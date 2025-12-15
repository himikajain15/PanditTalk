from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import CustomUser, PhoneOTP, PanditProfile, ConsultationRequest, PanditPayout, PanditReview


@admin.register(CustomUser)
class CustomUserAdmin(UserAdmin):
    """Admin interface for CustomUser"""
    list_display = ('username', 'phone', 'is_pandit', 'wallet_balance', 'is_staff', 'date_joined')
    list_filter = ('is_pandit', 'is_staff', 'is_active')
    search_fields = ('username', 'phone', 'email')
    
    fieldsets = UserAdmin.fieldsets + (
        ('Custom Fields', {
            'fields': ('is_pandit', 'phone', 'profile_pic', 'bio', 'karma_points', 'wallet_balance')
        }),
    )


@admin.register(PhoneOTP)
class PhoneOTPAdmin(admin.ModelAdmin):
    """Admin interface for PhoneOTP"""
    list_display = ('phone', 'otp', 'verified', 'created_at')
    list_filter = ('verified', 'created_at')
    search_fields = ('phone',)
    readonly_fields = ('created_at',)


@admin.register(PanditProfile)
class PanditProfileAdmin(admin.ModelAdmin):
    """Admin interface for PanditProfile"""
    list_display = ('user', 'is_verified', 'availability_status', 'experience_years', 'average_rating', 'total_consultations', 'total_earnings')
    list_filter = ('is_verified', 'availability_status', 'created_at')
    search_fields = ('user__username', 'user__phone')
    readonly_fields = ('total_earnings', 'total_consultations', 'average_rating', 'created_at', 'updated_at')
    
    fieldsets = (
        ('Basic Info', {
            'fields': ('user', 'is_verified', 'specializations', 'languages', 'experience_years')
        }),
        ('Pricing', {
            'fields': ('chat_rate', 'call_rate', 'video_rate')
        }),
        ('Availability', {
            'fields': ('availability_status', 'working_hours')
        }),
        ('Bank Details', {
            'fields': ('bank_account_number', 'bank_ifsc', 'bank_account_holder', 'pan_number')
        }),
        ('Statistics', {
            'fields': ('total_earnings', 'total_consultations', 'average_rating', 'total_reviews')
        }),
        ('Metadata', {
            'fields': ('created_at', 'updated_at')
        }),
    )


@admin.register(ConsultationRequest)
class ConsultationRequestAdmin(admin.ModelAdmin):
    """Admin interface for ConsultationRequest"""
    list_display = ('id', 'user', 'pandit', 'service_type', 'status', 'amount', 'pandit_earnings', 'created_at')
    list_filter = ('service_type', 'status', 'created_at')
    search_fields = ('user__username', 'pandit__username', 'user_query')
    readonly_fields = ('commission_amount', 'pandit_earnings', 'created_at', 'accepted_at', 'started_at', 'ended_at')
    
    fieldsets = (
        ('Parties', {
            'fields': ('user', 'pandit')
        }),
        ('Service Details', {
            'fields': ('service_type', 'duration', 'user_query', 'birth_details')
        }),
        ('Payment', {
            'fields': ('amount', 'commission_percentage', 'commission_amount', 'pandit_earnings', 'payment_status')
        }),
        ('Status', {
            'fields': ('status', 'created_at', 'accepted_at', 'started_at', 'ended_at')
        }),
        ('Feedback', {
            'fields': ('user_rating', 'user_review')
        }),
    )


@admin.register(PanditPayout)
class PanditPayoutAdmin(admin.ModelAdmin):
    """Admin interface for PanditPayout"""
    list_display = ('id', 'pandit', 'amount', 'status', 'requested_at', 'processed_at')
    list_filter = ('status', 'requested_at')
    search_fields = ('pandit__username', 'transaction_id')
    readonly_fields = ('requested_at',)
    
    fieldsets = (
        ('Payout Details', {
            'fields': ('pandit', 'amount', 'status')
        }),
        ('Bank Details', {
            'fields': ('bank_account_number', 'bank_ifsc', 'bank_account_holder')
        }),
        ('Transaction', {
            'fields': ('transaction_id', 'admin_notes')
        }),
        ('Timestamps', {
            'fields': ('requested_at', 'processed_at')
        }),
    )


@admin.register(PanditReview)
class PanditReviewAdmin(admin.ModelAdmin):
    """Admin interface for PanditReview"""
    list_display = ('id', 'pandit', 'user', 'rating', 'created_at')
    list_filter = ('rating', 'created_at')
    search_fields = ('pandit__username', 'user__username', 'review_text')
    readonly_fields = ('created_at',)

