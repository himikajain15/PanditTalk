"""pandittalk URL Configuration

Main router that includes app-specific URLs. Add other app includes as you add apps.
"""
from django.contrib import admin
from django.urls import path, include
from django.views.generic import TemplateView

urlpatterns = [
    path('', TemplateView.as_view(template_name='landing_page.html'), name='landing_page'),
    path('admin/', admin.site.urls),
    # API namespaces (these will be provided by the apps you add next)
    path('api/auth/', include('users.urls')),           # users app (register/login/me)
    path('api/pandit/', include('users.pandit_urls')),  # pandit-specific APIs
    path('api/user/', include('users.user_consultation_urls')),  # user consultation APIs
    path('api/core/', include('core.urls')),            # core features (pandits, bookings, chat endpoints)
    path('api/horoscope/', include('horoscope.urls')),  # horoscope endpoints
    path('api/payments/', include('payments.urls')),    # payments (initiate, verify)
    path('api/notifications/', include('notifications.urls')),  # fcm register etc.
    path('api/badges/', include('badges.urls')),        # badges endpoints
    # Note: if an included app is not yet created, Django will raise ImportError when starting;
    # you can comment out includes temporarily until app folders are present.
]
