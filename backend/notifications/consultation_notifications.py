"""
Notification handlers for consultation events
"""
from .fcm_service import send_push_notification


def notify_pandit_new_request(pandit_user, consultation):
    """Send notification to pandit about new consultation request"""
    title = "New Consultation Request!"
    body = f"{consultation.user.username} wants a {consultation.service_type} consultation"
    data = {
        'type': 'new_request',
        'consultation_id': str(consultation.id),
        'service_type': consultation.service_type,
        'amount': str(consultation.amount),
    }
    
    send_push_notification(
        user=pandit_user,
        title=title,
        body=body,
        data=data
    )


def notify_user_request_accepted(user, consultation):
    """Send notification to user that pandit accepted request"""
    title = "Request Accepted!"
    body = f"{consultation.pandit.username} accepted your consultation request"
    data = {
        'type': 'request_accepted',
        'consultation_id': str(consultation.id),
        'pandit_name': consultation.pandit.username,
    }
    
    send_push_notification(
        user=user,
        title=title,
        body=body,
        data=data
    )


def notify_user_request_rejected(user, consultation):
    """Send notification to user that pandit rejected request"""
    title = "Request Declined"
    body = f"{consultation.pandit.username} is unable to accept your request. Amount has been refunded."
    data = {
        'type': 'request_rejected',
        'consultation_id': str(consultation.id),
    }
    
    send_push_notification(
        user=user,
        title=title,
        body=body,
        data=data
    )


def notify_consultation_started(user, pandit, consultation):
    """Send notification when consultation starts"""
    title = "Consultation Started"
    body = "Your consultation has begun"
    data = {
        'type': 'consultation_started',
        'consultation_id': str(consultation.id),
    }
    
    # Notify both user and pandit
    send_push_notification(user=user, title=title, body=body, data=data)
    send_push_notification(user=pandit, title=title, body=body, data=data)


def notify_consultation_completed(user, consultation):
    """Send notification when consultation is completed"""
    title = "Consultation Completed"
    body = f"Please rate your experience with {consultation.pandit.username}"
    data = {
        'type': 'consultation_completed',
        'consultation_id': str(consultation.id),
    }
    
    send_push_notification(
        user=user,
        title=title,
        body=body,
        data=data
    )


def notify_payout_processed(pandit_user, payout):
    """Send notification when payout is processed"""
    title = "Payout Processed!"
    body = f"₹{payout.amount} has been transferred to your bank account"
    data = {
        'type': 'payout_processed',
        'payout_id': str(payout.id),
        'amount': str(payout.amount),
    }
    
    send_push_notification(
        user=pandit_user,
        title=title,
        body=body,
        data=data
    )

