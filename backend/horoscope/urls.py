from rest_framework.routers import DefaultRouter
from .views import HoroscopeViewSet

router = DefaultRouter()
router.register(r'horoscopes', HoroscopeViewSet)
urlpatterns = router.urls
