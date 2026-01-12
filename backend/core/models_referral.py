from django.db import models
from django.conf import settings
from decimal import Decimal

class Referral(models.Model):
    """Referral system - tracks referrals and credits"""
    referrer = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='referrals_made'
    )
    referred_user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='referred_by',
        null=True,
        blank=True
    )
    referral_code = models.CharField(max_length=20, unique=True, db_index=True)
    referred_phone = models.CharField(max_length=15, blank=True)  # Phone number of referred user
    credits_earned = models.DecimalField(max_digits=10, decimal_places=2, default=Decimal('0.00'))
    credits_given = models.DecimalField(max_digits=10, decimal_places=2, default=Decimal('0.00'))
    is_active = models.BooleanField(default=True)
    first_booking_completed = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    credits_credited_at = models.DateTimeField(null=True, blank=True)
    
    class Meta:
        ordering = ['-created_at']
        indexes = [
            models.Index(fields=['referral_code']),
            models.Index(fields=['referrer', 'is_active']),
        ]
    
    def __str__(self):
        return f"Referral {self.referral_code} by {self.referrer.username}"

