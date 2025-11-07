from django.urls import path
from .views import initiate_payment, verify_payment

urlpatterns = [
    path('initiate/', initiate_payment, name='payments-initiate'),
    path('verify/', verify_payment, name='payments-verify'),
]
