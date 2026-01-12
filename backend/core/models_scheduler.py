from django.db import models
from django.conf import settings
from users.models import PanditProfile

class LiveSessionSlot(models.Model):
    """Available time slots for live sessions"""
    pandit = models.ForeignKey(
        PanditProfile,
        on_delete=models.CASCADE,
        related_name='available_slots'
    )
    date = models.DateField()
    start_time = models.TimeField()
    end_time = models.TimeField()
    is_booked = models.BooleanField(default=False)
    booked_by = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='booked_slots'
    )
    booking = models.ForeignKey(
        'core.Booking',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='session_slot'
    )
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['date', 'start_time']
        indexes = [
            models.Index(fields=['pandit', 'date', 'is_booked']),
            models.Index(fields=['date', 'is_booked']),
        ]
        unique_together = [['pandit', 'date', 'start_time']]
    
    def __str__(self):
        return f"{self.pandit.user.username} - {self.date} {self.start_time}"

