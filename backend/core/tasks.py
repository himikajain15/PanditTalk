"""
Simple background task helpers.

This file contains lightweight helper functions that perform quick tasks.
For production you should replace these with a proper background worker (Celery, RQ, Dramatiq).
These helpers are synchronous and safe for small workloads during development.
"""

from django.utils import timezone
from .models import Booking, ChatThread, ChatMessage

def mark_booking_completed(booking_id):
    """
    Mark booking as completed if scheduled_at is in the past.
    (This is a simple, manually-invokable helper.)
    """
    try:
        booking = Booking.objects.get(id=booking_id)
    except Booking.DoesNotExist:
        return False
    if booking.scheduled_at <= timezone.now():
        booking.status = Booking.STATUS_COMPLETED
        booking.save()
        # optionally create a system message in chat thread
        if hasattr(booking, 'chat_thread'):
            ChatMessage.objects.create(thread=booking.chat_thread, is_system=True, text="Session marked as completed.")
        return True
    return False
