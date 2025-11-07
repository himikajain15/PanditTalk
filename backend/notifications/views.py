from rest_framework import status, permissions, generics
from rest_framework.response import Response
from .models import FCMDevice

class RegisterFCMTokenView(generics.CreateAPIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        token = request.data.get("token")
        if not token:
            return Response({"error": "Token missing"}, status=status.HTTP_400_BAD_REQUEST)
        FCMDevice.objects.update_or_create(user=request.user, defaults={"token": token})
        return Response({"message": "Token registered successfully"}, status=status.HTTP_201_CREATED)
