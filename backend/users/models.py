from django.contrib.auth.models import AbstractUser
from django.db import models
import random
from datetime import timedelta
from django.utils import timezone

class CustomUser(AbstractUser):
    is_pandit = models.BooleanField(default=False)
    phone = models.CharField(max_length=15, blank=True, unique=True, null=True)
    profile_pic = models.CharField(max_length=500, blank=True, null=True)  # URL to profile pic instead of ImageField
    bio = models.TextField(blank=True, null=True)
    karma_points = models.IntegerField(default=0)

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
