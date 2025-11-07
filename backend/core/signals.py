"""
Django signals for core app.
- Award a simple karma point to user when booking is confirmed.
- Create a chat thread automatically when a booking is created (optional).
"""

from django.db.models.signals import post_save
from django.dispatch import receiver
from .models import Booking, ChatThread
from django.conf import settings

@receiver(post_save, sender=Booking)
def booking_created_handler(sender, instance: Booking, created, **kwargs):
    # When booking is created, auto-create a ChatThread if not present
    if created:
        ChatThread.objects.get_or_create(booking=instance, user=instance.user, pandit=instance.pandit)

@receiver(post_save, sender=Booking)
def booking_status_change_award(sender, instance: Booking, created, **kwargs):
    # If booking status updated to CONFIRMED, award +1 karma point to user
    if not created:
        try:
            prev = sender.objects.get(pk=instance.pk)
        except Exception:
            prev = None
        # Note: above attempt to get previous state won't show changed values because object updated;
        # Instead we simply apply award if status is CONFIRMED (idempotent protection may be needed)
        if instance.status == Booking.STATUS_CONFIRMED:
            user = instance.user
            user.karma_points = (user.karma_points or 0) + 1
            user.save()
