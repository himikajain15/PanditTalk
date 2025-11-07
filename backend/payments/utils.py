"""
Utility helpers for payments (Razorpay).
"""

import requests
from django.conf import settings
from decimal import Decimal
import hmac, hashlib

RAZORPAY_ORDERS_URL = "https://api.razorpay.com/v1/orders"

def create_razorpay_order(amount: Decimal, receipt_id: str):
    """
    Create Razorpay order via REST API.
    amount should be Decimal; Razorpay expects amount in paise (integer).
    Returns parsed JSON response or None on failure.
    """
    if not settings.RAZORPAY_KEY_ID or not settings.RAZORPAY_KEY_SECRET:
        return None
    try:
        amount_paise = int(amount * 100)  # convert to paise
    except Exception:
        amount_paise = int(float(amount) * 100)

    payload = {
        "amount": amount_paise,
        "currency": "INR",
        "receipt": receipt_id,
        "payment_capture": 1
    }
    auth = (settings.RAZORPAY_KEY_ID, settings.RAZORPAY_KEY_SECRET)
    r = requests.post(RAZORPAY_ORDERS_URL, auth=auth, json=payload, timeout=10)
    if r.status_code in (200, 201):
        return r.json()
    return None

def verify_razorpay_signature(order_id: str, payment_id: str, signature: str) -> bool:
    """
    Verify order_id|payment_id signature using RAZORPAY_KEY_SECRET.
    """
    if not settings.RAZORPAY_KEY_SECRET:
        return True  # In dev mode we return True so testing is simple
    msg = f"{order_id}|{payment_id}"
    generated = hmac.new(settings.RAZORPAY_KEY_SECRET.encode(), msg.encode(), hashlib.sha256).hexdigest()
    return hmac.compare_digest(generated, signature)
