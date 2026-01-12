from django.urls import path
from .views import (
    PanditListView, PanditDetailView,
    BookingCreateView, BookingListView, BookingDetailView,
    ChatThreadListCreateView, ChatMessageListCreateView,
    sync_pandits_from_sheets,
    # Referral views
    ReferralCreateView, ReferralDetailView, use_referral_code,
    # Testimonial views
    TestimonialListCreateView, TestimonialDetailView,
    # Calendar views
    CalendarEventListCreateView, CalendarEventDetailView,
    # Scheduler views
    LiveSessionSlotListCreateView, book_live_session_slot,
    # Ruby registration views
    RubyRegistrationCreateView, RubyRegistrationDetailView,
)
from .views_palmistry import analyze_palmistry
from .views_tarot import interpret_tarot

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

    # Referral endpoints
    path('referrals/', ReferralCreateView.as_view(), name='referral-create'),
    path('referrals/me/', ReferralDetailView.as_view(), name='referral-detail'),
    path('referrals/use/', use_referral_code, name='use-referral-code'),

    # Testimonial endpoints
    path('testimonials/', TestimonialListCreateView.as_view(), name='testimonial-list-create'),
    path('testimonials/<int:pk>/', TestimonialDetailView.as_view(), name='testimonial-detail'),

    # Calendar endpoints
    path('calendar/events/', CalendarEventListCreateView.as_view(), name='calendar-event-list-create'),
    path('calendar/events/<int:pk>/', CalendarEventDetailView.as_view(), name='calendar-event-detail'),

    # Live session scheduler endpoints
    path('scheduler/slots/', LiveSessionSlotListCreateView.as_view(), name='scheduler-slot-list-create'),
    path('scheduler/slots/<int:slot_id>/book/', book_live_session_slot, name='book-slot'),

    # Ruby registration endpoints
    path('ruby/register/', RubyRegistrationCreateView.as_view(), name='ruby-register'),
    path('ruby/status/', RubyRegistrationDetailView.as_view(), name='ruby-status'),

    # Palmistry endpoints
    path('palmistry/analyze/', analyze_palmistry, name='palmistry-analyze'),
    
    # Tarot endpoints
    path('tarot/interpret/', interpret_tarot, name='tarot-interpret'),
]
