from rest_framework import viewsets
from .models import Horoscope
from .serializers import HoroscopeSerializer

class HoroscopeViewSet(viewsets.ModelViewSet):
    queryset = Horoscope.objects.all().order_by('-date')
    serializer_class = HoroscopeSerializer
