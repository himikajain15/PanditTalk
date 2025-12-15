from django.db import models
from django.conf import settings
from users.models import PanditProfile

# Booking for scheduled consultations
class Booking(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='bookings'
    )
    pandit = models.ForeignKey(
        PanditProfile,
        on_delete=models.CASCADE,
        related_name='bookings'
    )
    scheduled_at = models.DateTimeField()
    duration_minutes = models.IntegerField(default=15)
    created_at = models.DateTimeField(auto_now_add=True)

    STATUS_PENDING = 'PENDING'
    STATUS_CONFIRMED = 'CONFIRMED'
    STATUS_COMPLETED = 'COMPLETED'
    STATUS_CANCELLED = 'CANCELLED'

    STATUS_CHOICES = [
        (STATUS_PENDING, 'Pending'),
        (STATUS_CONFIRMED, 'Confirmed'),
        (STATUS_COMPLETED, 'Completed'),
        (STATUS_CANCELLED, 'Cancelled'),
    ]

    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default=STATUS_PENDING)
    notes = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"Booking {self.id} by {self.user.username} with {self.pandit.user.username}"


# Chat thread per booking or ad-hoc
class ChatThread(models.Model):
    booking = models.OneToOneField(
        Booking,
        on_delete=models.CASCADE,
        related_name='chat_thread',
        null=True,
        blank=True
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='core_threads'
    )
    pandit = models.ForeignKey(
        PanditProfile,
        on_delete=models.CASCADE,
        related_name='core_threads'
    )
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Thread {self.id} ({self.user.username} - {self.pandit.user.username})"


# Individual chat messages
class ChatMessage(models.Model):
    thread = models.ForeignKey(
        ChatThread,
        on_delete=models.CASCADE,
        related_name='messages'
    )
    sender_user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='sent_core_messages'
    )
    text = models.TextField(blank=True, null=True)
    is_system = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['created_at']

    def __str__(self):
        sender = self.sender_user.username if self.sender_user else "System"
        return f"Msg {self.id} by {sender}"
