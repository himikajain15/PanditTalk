"""
URL Configuration for User Consultation APIs
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import user_consultation_views

router = DefaultRouter()
router.register('pandits', user_consultation_views.AvailablePanditsViewSet, basename='available-pandits')
router.register('consultations', user_consultation_views.UserConsultationViewSet, basename='user-consultations')

urlpatterns = [
    path('', include(router.urls)),
    path('pandits/<int:pandit_id>/', user_consultation_views.pandit_detail, name='pandit-detail'),
]

