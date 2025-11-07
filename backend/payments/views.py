from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from django.conf import settings
from core.models import Booking
from .models import Payment  # if you created a payments.models earlier; if not, Payment model may live elsewhere
from .utils import create_razorpay_order, verify_razorpay_signature
from decimal import Decimal
import uuid

# NOTE: To avoid circular imports we assume Payment model is either defined in payments.models
# or in a shared app. If Payment model is in payments.models, ensure that file exists. If not,
# you can import from the earlier provided payments app code.

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def initiate_payment(request):
    """
    Create payment record and (optionally) create Razorpay order.
    Returns order_id and payload for client to open Checkout.
    """
    booking_id = request.data.get('booking_id')
    if not booking_id:
        return Response({'error': 'booking_id required'}, status=400)
    try:
        booking = Booking.objects.get(id=booking_id)
    except Booking.DoesNotExist:
        return Response({'error': 'Invalid booking id'}, status=400)

    # Calculate amount (Decimal)
    amount = Decimal(str(booking.duration_minutes)) * Decimal(str(booking.pandit.fee_per_minute))
    # Create internal payment record
    payment = Payment.objects.create(
        booking=booking,
        user=request.user,
        amount=amount,
        currency='INR',
        gateway='razorpay',
        status='PENDING'
    )

    # If Razorpay keys present, create an order
    if settings.RAZORPAY_KEY_ID and settings.RAZORPAY_KEY_SECRET:
        order = create_razorpay_order(amount=amount, receipt_id=f"receipt_{payment.id}")
        if order:
            payment.gateway_order_id = order.get('id')
            payment.save()
            return Response({
                'order_id': order.get('id'),
                'amount': order.get('amount'),
                'currency': order.get('currency'),
                'key': settings.RAZORPAY_KEY_ID,
                'payment_id_internal': payment.id
            })
        else:
            return Response({'error': 'unable to create razorpay order'}, status=500)

    # Fallback: return fake order id for client dev
    fake_order = f"TEST_ORDER_{uuid.uuid4().hex[:12]}"
    payment.gateway_order_id = fake_order
    payment.save()
    return Response({
        'order_id': fake_order,
        'amount': int(amount * 100),  # paise
        'currency': 'INR',
        'key': 'TEST_KEY',
        'payment_id_internal': payment.id
    })

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def verify_payment(request):
    """
    Verify payment signature from client (for Razorpay) and mark payment/booking status.
    Expected payload: { payment_id_internal, order_id, payment_id, signature }
    """
    payment_id_internal = request.data.get('payment_id_internal')
    order_id = request.data.get('order_id')
    payment_id = request.data.get('payment_id')
    signature = request.data.get('signature')

    if not payment_id_internal:
        return Response({'error': 'payment_id_internal required'}, status=400)
    try:
        payment = Payment.objects.get(id=payment_id_internal)
    except Payment.DoesNotExist:
        return Response({'error': 'Payment not found'}, status=400)

    # If real keys available, verify signature
    if settings.RAZORPAY_KEY_ID and settings.RAZORPAY_KEY_SECRET:
        if not verify_razorpay_signature(order_id=order_id, payment_id=payment_id, signature=signature):
            payment.status = 'FAILED'
            payment.save()
            return Response({'status': 'failed', 'reason': 'signature mismatch'}, status=400)
        # success: mark captured
        payment.gateway_payment_id = payment_id
        payment.status = 'SUCCESS'
        payment.save()
        # update booking status
        if payment.booking:
            booking = payment.booking
            booking.status = Booking.STATUS_CONFIRMED
            booking.save()
        return Response({'status': 'success'})

    # fallback: accept any and mark success
    payment.gateway_payment_id = payment_id or f"TESTPAY_{uuid.uuid4().hex[:8]}"
    payment.status = 'SUCCESS'
    payment.save()
    if payment.booking:
        booking = payment.booking
        booking.status = Booking.STATUS_CONFIRMED
        booking.save()
    return Response({'status': 'success'})
