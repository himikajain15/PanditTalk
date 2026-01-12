from django.db import models
from django.conf import settings

class CalendarEvent(models.Model):
    """Calendar events - festivals, auspicious dates, user events"""
    EVENT_TYPES = [
        ('festival', 'Festival'),
        ('auspicious', 'Auspicious Date'),
        ('consultation', 'Consultation'),
        ('user_event', 'User Event'),
    ]
    
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='calendar_events',
        null=True,
        blank=True
    )
    event_type = models.CharField(max_length=20, choices=EVENT_TYPES)
    title = models.CharField(max_length=200)
    description = models.TextField(blank=True)
    date = models.DateField()
    time = models.TimeField(null=True, blank=True)  # For auspicious times
    is_recurring = models.BooleanField(default=False)
    recurring_pattern = models.CharField(max_length=50, blank=True)  # e.g., "yearly", "monthly"
    is_public = models.BooleanField(default=False)  # Public festivals vs user events
    created_at = models.DateTimeField(auto_now_add=True)
    
    class Meta:
        ordering = ['date', 'time']
        indexes = [
            models.Index(fields=['date', 'event_type']),
            models.Index(fields=['user', 'date']),
        ]
    
    def __str__(self):
        return f"{self.title} - {self.date}"

