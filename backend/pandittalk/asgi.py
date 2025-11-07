"""
ASGI config for pandittalk project.

This exposes the ASGI callable as a module-level variable named "application".
If you enable Django Channels later, replace the `get_asgi_application` chain
with Channels' ProtocolTypeRouter configuration.
"""

import os
from django.core.asgi import get_asgi_application

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'pandittalk.settings')

# Basic ASGI application (sync). If Channels is enabled, this file will be extended.
application = get_asgi_application()
