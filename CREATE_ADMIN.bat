@echo off
title Creating Django Admin Account...

echo.
echo ========================================
echo    CREATING DJANGO ADMIN ACCOUNT
echo ========================================
echo.

cd /d "%~dp0backend"

REM Check if venv exists
if exist venv\Scripts\activate.bat (
    call venv\Scripts\activate.bat
)

REM Create admin account with predefined credentials
python manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); User.objects.filter(username='admin').exists() or User.objects.create_superuser('admin', 'admin@pandittalk.com', 'admin123')"

echo.
echo ========================================
echo         ADMIN ACCOUNT CREATED!
echo ========================================
echo.
echo Django Admin Login Credentials:
echo.
echo   URL:      http://localhost:8000/admin
echo   Username: admin
echo   Password: admin123
echo.
echo ========================================
echo.
pause

