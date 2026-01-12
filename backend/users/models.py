from django.contrib.auth.models import AbstractUser
from django.db import models
import random
from datetime import timedelta
from django.utils import timezone
from decimal import Decimal

class CustomUser(AbstractUser):
    is_pandit = models.BooleanField(default=False)
    phone = models.CharField(max_length=15, blank=True, unique=True, null=True)
    profile_pic = models.CharField(max_length=500, blank=True, null=True)  # URL to profile pic instead of ImageField
    bio = models.TextField(blank=True, null=True)
    karma_points = models.IntegerField(default=0)
    wallet_balance = models.DecimalField(max_digits=10, decimal_places=2, default=Decimal('0.00'))

    def __str__(self):
        return self.username


class PhoneOTP(models.Model):
    """Temporary OTP storage for phone authentication"""
    phone = models.CharField(max_length=15, db_index=True)
    otp = models.CharField(max_length=6)
    created_at = models.DateTimeField(auto_now_add=True)
    verified = models.BooleanField(default=False)
    
    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['phone', 'verified']),
        ]
    
    @staticmethod
    def generate_otp():
        """Generate a 6-digit OTP"""
        return str(random.randint(100000, 999999))
    
    def is_expired(self, expiry_minutes=10):
        """Check if OTP has expired (default 10 minutes)"""
        return timezone.now() > self.created_at + timedelta(minutes=expiry_minutes)
    
    def __str__(self):
        return f"{self.phone} - {self.otp} ({'verified' if self.verified else 'pending'})"


class PanditProfile(models.Model):
    """Extended profile for Pandits"""
    AVAILABILITY_CHOICES = [
        ('available', 'Available'),
        ('busy', 'Busy'),
        ('offline', 'Offline'),
    ]
    
    user = models.OneToOneField(CustomUser, on_delete=models.CASCADE, related_name='pandit_profile')
    is_verified = models.BooleanField(default=False)
    specializations = models.JSONField(default=list)  # ["Vedic Astrology", "Kundali Matching", "Vastu"]
    languages = models.JSONField(default=list)  # ["Hindi", "English", "Sanskrit"]
    experience_years = models.IntegerField(default=0)
    
    # Pricing (per session/duration)
    chat_rate = models.DecimalField(max_digits=6, decimal_places=2, default=Decimal('100.00'))  # ₹100 per 15 min
    call_rate = models.DecimalField(max_digits=6, decimal_places=2, default=Decimal('200.00'))  # ₹200 per 15 min
    video_rate = models.DecimalField(max_digits=6, decimal_places=2, default=Decimal('500.00'))  # ₹500 per 30 min
    
    # Availability
    availability_status = models.CharField(max_length=20, choices=AVAILABILITY_CHOICES, default='offline')
    working_hours = models.JSONField(default=dict)  # {"monday": {"start": "09:00", "end": "21:00"}}
    
    # Bank Details for Payouts
    bank_account_number = models.CharField(max_length=50, blank=True)
    bank_ifsc = models.CharField(max_length=20, blank=True)
    bank_account_holder = models.CharField(max_length=100, blank=True)
    pan_number = models.CharField(max_length=10, blank=True)
    
    # Stats
    total_earnings = models.DecimalField(max_digits=10, decimal_places=2, default=Decimal('0.00'))
    total_consultations = models.IntegerField(default=0)
    average_rating = models.DecimalField(max_digits=3, decimal_places=2, default=Decimal('0.00'))
    total_reviews = models.IntegerField(default=0)
    
    # Metadata
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"Pandit Profile - {self.user.username}"
    
    class Meta:
        verbose_name = "Pandit Profile"
        verbose_name_plural = "Pandit Profiles"


class ConsultationRequest(models.Model):
    """Consultation requests from users to pandits"""
    SERVICE_TYPES = [
        ('chat', 'Chat'),
        ('call', 'Audio Call'),
        ('video', 'Video Call'),
    ]
    
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('accepted', 'Accepted'),
        ('rejected', 'Rejected'),
        ('in_progress', 'In Progress'),
        ('completed', 'Completed'),
        ('cancelled', 'Cancelled'),
    ]
    
    # Parties involved
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='user_consultations')
    pandit = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='pandit_consultations')
    
    # Service details
    service_type = models.CharField(max_length=20, choices=SERVICE_TYPES)
    duration = models.IntegerField(default=15)  # in minutes
    user_query = models.TextField(blank=True)
    birth_details = models.JSONField(blank=True, null=True)  # DOB, time, place
    
    # Payment details
    amount = models.DecimalField(max_digits=8, decimal_places=2)
    commission_percentage = models.DecimalField(max_digits=5, decimal_places=2, default=Decimal('25.00'))  # 25%
    commission_amount = models.DecimalField(max_digits=8, decimal_places=2, default=Decimal('0.00'))
    pandit_earnings = models.DecimalField(max_digits=8, decimal_places=2, default=Decimal('0.00'))
    payment_status = models.CharField(max_length=20, default='paid')
    
    # Status tracking
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    
    # Timestamps
    created_at = models.DateTimeField(auto_now_add=True)
    accepted_at = models.DateTimeField(null=True, blank=True)
    started_at = models.DateTimeField(null=True, blank=True)
    ended_at = models.DateTimeField(null=True, blank=True)
    
    # Feedback
    user_rating = models.IntegerField(null=True, blank=True)  # 1-5
    user_review = models.TextField(blank=True)

    # Pandit-side notes & remedies
    pandit_notes = models.TextField(blank=True)
    recommended_remedies = models.TextField(blank=True)
    
    def save(self, *args, **kwargs):
        # Calculate commission and pandit earnings
        if self.amount:
            self.commission_amount = (self.amount * self.commission_percentage) / Decimal('100')
            self.pandit_earnings = self.amount - self.commission_amount
        super().save(*args, **kwargs)
    
    def __str__(self):
        return f"{self.service_type.title()} - {self.user.username} → {self.pandit.username}"
    
    class Meta:
        verbose_name = "Consultation Request"
        verbose_name_plural = "Consultation Requests"
        ordering = ['-created_at']


class PanditPayout(models.Model):
    """Payout requests from pandits"""
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('processing', 'Processing'),
        ('completed', 'Completed'),
        ('failed', 'Failed'),
    ]
    
    pandit = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='payouts')
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    
    # Bank details (snapshot at the time of request)
    bank_account_number = models.CharField(max_length=50)
    bank_ifsc = models.CharField(max_length=20)
    bank_account_holder = models.CharField(max_length=100)
    
    # Status
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default='pending')
    transaction_id = models.CharField(max_length=100, blank=True)
    admin_notes = models.TextField(blank=True)
    
    # Timestamps
    requested_at = models.DateTimeField(auto_now_add=True)
    processed_at = models.DateTimeField(null=True, blank=True)
    
    def __str__(self):
        return f"Payout - {self.pandit.username} - ₹{self.amount}"
    
    class Meta:
        verbose_name = "Pandit Payout"
        verbose_name_plural = "Pandit Payouts"
        ordering = ['-requested_at']


class PanditReview(models.Model):
    """Reviews and ratings for pandits"""
    consultation = models.OneToOneField(ConsultationRequest, on_delete=models.CASCADE, related_name='review')
    pandit = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='reviews_received')
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='reviews_given')
    
    rating = models.IntegerField()  # 1-5
    review_text = models.TextField(blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.rating}★ - {self.pandit.username} by {self.user.username}"
    
    class Meta:
        verbose_name = "Pandit Review"
        verbose_name_plural = "Pandit Reviews"
        ordering = ['-created_at']


class BlockedUser(models.Model):
    """Users blocked by a pandit"""
    pandit = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='blocked_users')
    blocked_user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='blocked_by_pandits')
    reason = models.TextField(blank=True)  # Optional reason for blocking
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        unique_together = ['pandit', 'blocked_user']
        verbose_name = "Blocked User"
        verbose_name_plural = "Blocked Users"
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.pandit.username} blocked {self.blocked_user.username}"


class VIPUser(models.Model):
    """Users marked as VIP by a pandit (priority clients)"""
    pandit = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='vip_users')
    vip_user = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='vip_for_pandits')
    notes = models.TextField(blank=True)  # Optional notes about why they're VIP
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        unique_together = ['pandit', 'vip_user']
        verbose_name = "VIP User"
        verbose_name_plural = "VIP Users"
        ordering = ['-created_at']
    
    def __str__(self):
        return f"{self.vip_user.username} is VIP for {self.pandit.username}"
