# PowerShell script to start Django backend server
Set-Location $PSScriptRoot
Write-Host "Starting Django Backend Server..." -ForegroundColor Green
& .\venv\Scripts\python.exe manage.py runserver 127.0.0.1:8000

