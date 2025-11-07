"""
Handlers for payment gateway webhooks.
Add webhook URL in your payment provider console pointing to an endpoint
that calls these handlers (see payments.views.webhook_receiver if you implement it).
"""

import hmac
import hashlib
from django.conf import settings

def handle_razorpay_event(event_json):
    """
    Very small dispatcher for Razorpay webhook events.
    event_json is the parsed JSON body sent by Razorpay.
    """
    event = event_json.get('event')
    payload = event_json.get('payload', {})

    if event == 'payment.captured':
        # Process payment capture event
        # You may find payment entity at payload.get('payment', {}).get('entity', {})
        return {'status': 'handled', 'event': event}
    # Add other events as needed
    return {'status': 'ignored', 'event': event}
