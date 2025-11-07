from django.urls import path
from .views import BadgeListView, UserBadgeListView

urlpatterns = [
    path('', BadgeListView.as_view(), name='badges'),
    path('my/', UserBadgeListView.as_view(), name='user-badges'),
]
