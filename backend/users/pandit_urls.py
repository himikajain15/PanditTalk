"""
URL Configuration for Pandit APIs
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import pandit_views, pandit_registration_views

router = DefaultRouter()
router.register('profile', pandit_views.PanditProfileViewSet, basename='pandit-profile')
router.register('consultations', pandit_views.ConsultationRequestViewSet, basename='pandit-consultations')
router.register('payouts', pandit_views.PanditPayoutViewSet, basename='pandit-payouts')
router.register('reviews', pandit_views.PanditReviewViewSet, basename='pandit-reviews')

urlpatterns = [
    path('', include(router.urls)),
    path('dashboard/', pandit_views.pandit_dashboard, name='pandit-dashboard'),
    path('earnings/', pandit_views.pandit_earnings, name='pandit-earnings'),
    path('register/', pandit_registration_views.register_pandit, name='pandit-register'),
]

