from django.db import models
from django.conf import settings

class Testimonial(models.Model):
    """User testimonials and reviews"""
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='testimonials'
    )
    pandit = models.ForeignKey(
        'users.PanditProfile',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='testimonials'
    )
    rating = models.IntegerField(default=5)  # 1-5 stars
    title = models.CharField(max_length=200)
    content = models.TextField()
    is_featured = models.BooleanField(default=False)
    is_approved = models.BooleanField(default=False)  # Admin approval
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    
    class Meta:
        ordering = ['-created_at', '-is_featured']
        indexes = [
            models.Index(fields=['is_approved', 'is_featured']),
        ]
    
    def __str__(self):
        return f"Testimonial by {self.user.username} - {self.rating}★"

