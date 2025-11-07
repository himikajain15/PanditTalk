from django.urls import path
from .views import RegisterFCMTokenView

urlpatterns = [
    path('register-token/', RegisterFCMTokenView.as_view(), name='register-fcm-token'),
]
