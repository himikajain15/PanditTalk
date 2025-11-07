from django.db import models
from django.conf import settings

class FCMDevice(models.Model):
    """Store each user's Firebase Cloud Messaging token."""
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    token = models.CharField(max_length=255, unique=True)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - FCM Device"
