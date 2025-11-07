# Simple Dockerfile for running Django in a container (development / testing)
FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Install system deps required by some Python packages
RUN apt-get update && apt-get install -y build-essential libpq-dev gcc --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Expose Django default port
EXPOSE 8000

# Default command for container (runs migrations then starts development server)
CMD ["bash", "-lc", "python manage.py migrate --noinput && python manage.py runserver 0.0.0.0:8000"]
