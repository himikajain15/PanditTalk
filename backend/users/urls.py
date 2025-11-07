from django.urls import path
from .views import RegisterView, LoginView, send_otp, verify_otp, get_current_user

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', LoginView.as_view(), name='login'),
    path('send-otp/', send_otp, name='send-otp'),
    path('verify-otp/', verify_otp, name='verify-otp'),
    path('me/', get_current_user, name='me'),
]
