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
    path('block-user/<int:user_id>/', pandit_views.block_user, name='pandit-block-user'),
    path('vip-user/<int:user_id>/', pandit_views.vip_user, name='pandit-vip-user'),
    path('blocked-users/', pandit_views.get_blocked_users, name='pandit-blocked-users'),
    path('vip-users/', pandit_views.get_vip_users, name='pandit-vip-users'),
]

