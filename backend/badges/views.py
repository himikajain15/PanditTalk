from rest_framework import generics, permissions
from .models import Badge, UserBadge
from .serializers import BadgeSerializer, UserBadgeSerializer

class BadgeListView(generics.ListAPIView):
    queryset = Badge.objects.all()
    serializer_class = BadgeSerializer

class UserBadgeListView(generics.ListAPIView):
    permission_classes = [permissions.IsAuthenticated]
    serializer_class = UserBadgeSerializer

    def get_queryset(self):
        return UserBadge.objects.filter(user=self.request.user)
