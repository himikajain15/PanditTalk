import requests
from django.conf import settings

def send_push_to_token(token: str, title: str, body: str, data: dict = None):
    """Send a push notification via Firebase Cloud Messaging."""
    server_key = settings.FCM_SERVER_KEY
    headers = {
        "Authorization": f"key={server_key}",
        "Content-Type": "application/json"
    }
    payload = {
        "to": token,
        "notification": {
            "title": title,
            "body": body,
            "icon": "https://pandittalk.app/static/logo.png",
            "color": "#FFC107"  # saffron-yellow accent
        },
        "data": data or {}
    }
    response = requests.post("https://fcm.googleapis.com/fcm/send", json=payload, headers=headers)
    return response.status_code, response.text
