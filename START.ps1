# PanditTalk Startup Script
Write-Host "🕉️ Starting PanditTalk..." -ForegroundColor Cyan

Set-Location backend

# Create venv if needed
if (-not (Test-Path "venv")) {
    Write-Host "Creating virtual environment..." -ForegroundColor Yellow
    python -m venv venv
}

# Activate and install
& "venv\Scripts\Activate.ps1"
pip install -q -r requirements.txt

# Setup database
python manage.py makemigrations --noinput
python manage.py migrate --noinput

# Start backend
Write-Host "Starting Backend..." -ForegroundColor Green
Start-Process cmd -ArgumentList "/k python manage.py runserver 127.0.0.1:8000 --noreload"
Start-Sleep -Seconds 8

# Start Pandit App
Write-Host "Starting Pandit App..." -ForegroundColor Green
Set-Location ..\pandit_app
Start-Process cmd -ArgumentList "/k flutter run -d chrome --web-port=8081"
Start-Sleep -Seconds 10

# Start User App
Write-Host "Starting User App..." -ForegroundColor Green
Set-Location ..\mobile
Start-Process cmd -ArgumentList "/k flutter run -d chrome --web-port=8082"
Start-Sleep -Seconds 5

# Open admin
Start-Process "http://localhost:8000/admin"

Write-Host ""
Write-Host "✅ PanditTalk Started!" -ForegroundColor Green
Write-Host "Backend: http://localhost:8000" -ForegroundColor Cyan
Write-Host "Pandit App: http://localhost:8081" -ForegroundColor Cyan
Write-Host "User App: http://localhost:8082" -ForegroundColor Cyan
Write-Host ""

