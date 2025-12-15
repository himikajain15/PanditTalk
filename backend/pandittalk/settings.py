"""
Django settings for pandittalk project.

- Uses python-dotenv to read a .env file in development.
- Defaults to SQLite for quick local development if DATABASE_URL is not set.
- Configure SECRET_KEY, DEBUG, DATABASE_URL in .env or environment.
"""

import os
from pathlib import Path
from dotenv import load_dotenv
from datetime import timedelta

# Try to import dj_database_url, but it's optional for SQLite
try:
    import dj_database_url
except ImportError:
    dj_database_url = None

# Load .env file if present
BASE_DIR = Path(__file__).resolve().parent.parent
ENV_PATH = BASE_DIR / '.env'
if ENV_PATH.exists():
    load_dotenv(ENV_PATH)

# Basic
SECRET_KEY = os.getenv('SECRET_KEY', 'dev-secret-key')
DEBUG = os.getenv('DEBUG', 'True').lower() in ('1', 'true', 'yes')
# Allow all hosts in development for mobile device access
ALLOWED_HOSTS = [h.strip() for h in os.getenv('ALLOWED_HOSTS', '127.0.0.1,localhost,0.0.0.0,172.29.240.1,10.0.2.2').split(',') if h.strip()]
if DEBUG:
    ALLOWED_HOSTS = ['*']  # Allow all in development

# Application definition
INSTALLED_APPS = [
    # Django default apps
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # Third-party
    'rest_framework',
    'corsheaders',
    'channels',  # for WebSocket support

    # Local apps
    'users',
    'core',
    'chat',
    'horoscope',
    'payments',
    'notifications',
    'badges',
]

MIDDLEWARE = [
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
]

ROOT_URLCONF = 'pandittalk.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'pandittalk' / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                "django.template.context_processors.debug",
                "django.template.context_processors.request",
                "django.contrib.auth.context_processors.auth",
                "django.contrib.messages.context_processors.messages",
            ],
        },
    },
]

# ASGI/WSGI
WSGI_APPLICATION = 'pandittalk.wsgi.application'
ASGI_APPLICATION = 'pandittalk.asgi.application'  # used by Channels

# Database: use DATABASE_URL if provided, otherwise SQLite
DATABASE_URL = os.getenv('DATABASE_URL', f"sqlite:///{BASE_DIR / 'db.sqlite3'}")
if DATABASE_URL.startswith('sqlite') or dj_database_url is None:
    DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.sqlite3',
            'NAME': BASE_DIR / 'db.sqlite3',
        }
    }
else:
    DATABASES = {'default': dj_database_url.parse(DATABASE_URL, conn_max_age=600)}

# Auth: custom user model
AUTH_USER_MODEL = 'users.CustomUser'

AUTH_PASSWORD_VALIDATORS = []  # simplify dev

# Internationalization
LANGUAGE_CODE = 'en-us'
TIME_ZONE = 'UTC'
USE_I18N = True
USE_TZ = True

# Static & media
STATIC_URL = '/static/'
STATICFILES_DIRS = [BASE_DIR / 'pandittalk' / 'static']
STATIC_ROOT = BASE_DIR / 'staticfiles'
MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# CORS
CORS_ALLOW_ALL_ORIGINS = True
CORS_ALLOW_CREDENTIALS = True
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://localhost:36089",
    "http://127.0.0.1:3000",
    "http://127.0.0.1:36089",
    "http://localhost:5000",
    "http://127.0.0.1:5000",
]
# Allow all localhost ports and local network IPs for development
CORS_ALLOWED_ORIGIN_REGEXES = [
    r"^http://localhost:\d+$",
    r"^http://127\.0\.0\.1:\d+$",
    r"^http://172\.\d+\.\d+\.\d+:\d+$",  # Allow 172.x.x.x network
    r"^http://10\.\d+\.\d+\.\d+:\d+$",   # Allow 10.x.x.x network
    r"^http://192\.168\.\d+\.\d+:\d+$",  # Allow 192.168.x.x network
]

# REST Framework
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticatedOrReadOnly',
    ),
}

# JWT
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(days=7),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=30),
    'AUTH_HEADER_TYPES': ('Bearer',),
}

# Razorpay + Firebase
RAZORPAY_KEY_ID = os.getenv('RAZORPAY_KEY_ID', '')
RAZORPAY_KEY_SECRET = os.getenv('RAZORPAY_KEY_SECRET', '')
FIREBASE_CREDENTIALS_JSON = os.getenv('FIREBASE_CREDENTIALS_JSON', '')

# Channels Layer (Redis or InMemory)
REDIS_URL = os.getenv('REDIS_URL', '')
if REDIS_URL:
    CHANNEL_LAYERS = {
        'default': {
            'BACKEND': 'channels_redis.core.RedisChannelLayer',
            'CONFIG': {
                "hosts": [REDIS_URL],
            },
        }
    }
else:
    CHANNEL_LAYERS = {
        "default": {
            "BACKEND": "channels.layers.InMemoryChannelLayer"
        }
    }

# Logging
LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'handlers': {'console': {'class': 'logging.StreamHandler'}},
    'root': {'handlers': ['console'], 'level': 'INFO'},
}

# Branding
APP_BRAND_NAME = "Pandittalk"
APP_PRIMARY_COLOR = "#FFA500"  # Saffron yellow
APP_ACCENT_COLOR = "#FFB300"
APP_LOGO_URL = "/static/logo.png"

# Google Sheets Integration (optional)
# Your Google Sheet: https://docs.google.com/spreadsheets/d/1N40ViPr2xcHLjmZOQiUeUB-VINVd-MgkwtgkEkC9W8s/edit
GOOGLE_SHEET_ID = os.getenv('GOOGLE_SHEET_ID', '1N40ViPr2xcHLjmZOQiUeUB-VINVd-MgkwtgkEkC9W8s')
GOOGLE_WORKSHEET_NAME = os.getenv('GOOGLE_WORKSHEET_NAME', 'Pandit Registrations')
# Path to your service account JSON file (download from Google Cloud Console)
GOOGLE_CREDENTIALS_JSON = os.getenv('GOOGLE_CREDENTIALS_JSON', str(BASE_DIR / 'google-credentials.json'))
GOOGLE_DRIVE_FOLDER_ID = os.getenv('GOOGLE_DRIVE_FOLDER_ID', '1AIPnBl5WrWO1L-T30PQv-AEuj2xu17gs')

# Email Configuration
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'  # For development
DEFAULT_FROM_EMAIL = 'noreply@pandittalk.com'
ADMIN_EMAIL = 'admin@pandittalk.com'

# For production, use:
# EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
# EMAIL_HOST = 'smtp.gmail.com'
# EMAIL_PORT = 587
# EMAIL_USE_TLS = True
# EMAIL_HOST_USER = os.getenv('EMAIL_HOST_USER', '')
# EMAIL_HOST_PASSWORD = os.getenv('EMAIL_HOST_PASSWORD', '')