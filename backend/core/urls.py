from django.urls import path
from .views import (
    PanditListView, PanditDetailView,
    BookingCreateView, BookingListView, BookingDetailView,
    ChatThreadListCreateView, ChatMessageListCreateView,
    sync_pandits_from_sheets
)

urlpatterns = [
    # Pandit directory
    path('pandits/', PanditListView.as_view(), name='pandit-list'),
    path('pandits/<int:pk>/', PanditDetailView.as_view(), name='pandit-detail'),
    path('pandits/sync-sheets/', sync_pandits_from_sheets, name='sync-pandits-sheets'),

    # Bookings
    path('bookings/', BookingCreateView.as_view(), name='booking-create'),
    path('bookings/list/', BookingListView.as_view(), name='booking-list'),
    path('bookings/<int:pk>/', BookingDetailView.as_view(), name='booking-detail'),

    # Chat (thread creation + messages)
    path('threads/', ChatThreadListCreateView.as_view(), name='threads'),
    path('threads/<int:thread_id>/messages/', ChatMessageListCreateView.as_view(), name='thread-messages'),
]
