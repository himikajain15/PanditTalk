from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from django.contrib.auth import authenticate
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError
from rest_framework_simplejwt.tokens import RefreshToken
from .models import CustomUser, PhoneOTP, PanditProfile
from .serializers import UserSerializer
import logging

logger = logging.getLogger(__name__)


class RegisterView(generics.GenericAPIView):
    """Register new user with email/password"""
    permission_classes = [AllowAny]
    serializer_class = UserSerializer

    def post(self, request):
        username = request.data.get('username', '').strip()
        email = request.data.get('email', '').strip()
        password = request.data.get('password', '').strip()
        password2 = request.data.get('password2', '').strip()

        # Validation
        if not username or not email or not password:
            return Response({"error": "Username, email, and password are required"}, status=status.HTTP_400_BAD_REQUEST)
        
        if password != password2:
            return Response({"error": "Passwords do not match"}, status=status.HTTP_400_BAD_REQUEST)

        # Check if user exists
        if CustomUser.objects.filter(username=username).exists():
            return Response({"error": "Username already exists"}, status=status.HTTP_400_BAD_REQUEST)
        
        if CustomUser.objects.filter(email=email).exists():
            return Response({"error": "Email already exists"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            validate_password(password)
        except ValidationError as e:
            return Response({"error": list(e.messages)}, status=status.HTTP_400_BAD_REQUEST)

        # Create user
        try:
            user = CustomUser.objects.create_user(
                username=username,
                email=email,
                password=password
            )
            # Generate tokens
            refresh = RefreshToken.for_user(user)
            return Response({
                "id": user.id,
                "username": user.username,
                "email": user.email,
                "access": str(refresh.access_token),
                "refresh": str(refresh),
                "user": UserSerializer(user).data
            }, status=status.HTTP_201_CREATED)
        except Exception as e:
            logger.error(f"Registration error: {e}")
            return Response({"error": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class LoginView(generics.GenericAPIView):
    """Login with username/email and password"""
    permission_classes = [AllowAny]
    serializer_class = UserSerializer

    def post(self, request):
        username = request.data.get('username', '').strip()
        password = request.data.get('password', '').strip()

        if not username or not password:
            return Response({"error": "Username and password are required"}, status=status.HTTP_400_BAD_REQUEST)

        # Try to authenticate with username or email
        user = authenticate(username=username, password=password)
        
        # If username doesn't work, try email
        if not user:
            try:
                user_obj = CustomUser.objects.get(email=username)
                user = authenticate(username=user_obj.username, password=password)
            except CustomUser.DoesNotExist:
                pass

        if not user:
            return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

        # Generate tokens
        refresh = RefreshToken.for_user(user)
        return Response({
            "refresh": str(refresh),
            "access": str(refresh.access_token),
            "user": UserSerializer(user).data
        }, status=status.HTTP_200_OK)


@api_view(['POST'])
@permission_classes([AllowAny])
def send_otp(request):
    """Send OTP to phone number"""
    phone = request.data.get('phone', '').strip()
    
    if not phone:
        return Response({"error": "Phone number is required"}, status=status.HTTP_400_BAD_REQUEST)

    # FOR TESTING: Skip OTP generation, accept any OTP during verification
    # In production, uncomment the code below:
    
    # Generate OTP
    # otp_code = PhoneOTP.generate_otp()
    # Mark old OTPs for this phone as expired/verified (cleanup)
    # PhoneOTP.objects.filter(phone=phone, verified=False).update(verified=True)
    # Create new OTP
    # otp_obj = PhoneOTP.objects.create(phone=phone, otp=otp_code)
    # TODO: In production, integrate with SMS service (Twilio, AWS SNS, etc.)
    # logger.info(f"OTP for {phone}: {otp_code}")
    # print(f"🔐 OTP for {phone}: {otp_code}")
    
    logger.info(f"OTP requested for {phone} (TEST MODE: any OTP accepted)")
    print(f"📱 OTP request for {phone} (TEST MODE: Enter any 6-digit code)")
    
    return Response({
        "ok": True,
        "status": "sent",
        "message": f"OTP sent to {phone} (TEST MODE: Use any 6-digit code)",
    }, status=status.HTTP_200_OK)


@api_view(['POST'])
@permission_classes([AllowAny])
def verify_otp(request):
    """Verify OTP and login/register user"""
    phone = request.data.get('phone', '').strip()
    otp = request.data.get('otp', '').strip()
    
    if not phone or not otp:
        return Response({"error": "Phone and OTP are required"}, status=status.HTTP_400_BAD_REQUEST)

    # Find unverified, non-expired OTP
    try:
        # FOR TESTING: Accept any OTP (bypass verification)
        # In production, uncomment the validation below
        
        # otp_obj = PhoneOTP.objects.filter(phone=phone, verified=False).first()
        # if not otp_obj:
        #     return Response({"error": "No OTP found. Please request a new OTP"}, status=status.HTTP_400_BAD_REQUEST)
        # if otp_obj.is_expired():
        #     return Response({"error": "OTP has expired. Please request a new one"}, status=status.HTTP_400_BAD_REQUEST)
        # if otp_obj.otp != otp:
        #     return Response({"error": "Invalid OTP"}, status=status.HTTP_400_BAD_REQUEST)
        # otp_obj.verified = True
        # otp_obj.save()
        
        # FOR TESTING: Just log the OTP attempt
        logger.info(f"Login attempt for {phone} with OTP: {otp}")
        
        # Get or create user by phone
        user, created = CustomUser.objects.get_or_create(
            phone=phone,
            defaults={
                'username': f'user_{phone.replace("+", "").replace(" ", "")}',
                'email': f'{phone.replace("+", "").replace(" ", "")}@pandittalk.com',
            }
        )
        
        if created:
            user.set_unusable_password()  # No password for OTP-only users
        
        # Note: We allow unverified pandits to login so they can complete onboarding
        # Verification status is checked in the app/dashboard to show appropriate UI
        
        # Generate tokens
        refresh = RefreshToken.for_user(user)
        return Response({
            "refresh": str(refresh),
            "access": str(refresh.access_token),
            "user": UserSerializer(user).data,
            "created": created
        }, status=status.HTTP_200_OK)
        
    except Exception as e:
        logger.error(f"OTP verification error: {e}")
        return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_current_user(request):
    """Get current authenticated user"""
    return Response(UserSerializer(request.user).data, status=status.HTTP_200_OK)
