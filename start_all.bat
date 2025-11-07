@echo off
title PanditTalk - Starting Application
color 0A

cd /d "%~dp0"

cls
echo.
echo ================================================
echo         Starting PanditTalk...
echo ================================================
echo.

:: Start Backend
echo [1/2] Starting Backend Server...
start "PanditTalk Backend" cmd /k "cd /d "%~dp0backend" && venv\Scripts\activate && pip install -q -r requirements_minimal.txt 2>nul && python manage.py makemigrations 2>nul && python manage.py migrate --run-syncdb 2>nul && python -c "from django.contrib.auth import get_user_model; U=get_user_model(); U.objects.filter(username='test').exists() or U.objects.create_user('test','test@test.com','test123')" 2>nul && if not exist pandittalk\static mkdir pandittalk\static && cls && echo. && echo ======================================== && echo    BACKEND RUNNING && echo ======================================== && echo. && echo    http://localhost:8000 && echo. && echo    LOGIN: test / test123 && echo. && python manage.py runserver 127.0.0.1:8000 --noreload"

timeout /t 10 /nobreak

:: Start Mobile App Web Server
echo [2/2] Starting Mobile App...
where flutter >nul 2>&1
if %ERRORLEVEL% EQU 0 (
    start "PanditTalk App" cmd /k "cd /d "%~dp0mobile\build\web" && cls && echo. && echo ======================================== && echo    MOBILE APP RUNNING && echo ======================================== && echo. && echo    http://localhost:8081 && echo. && echo    LOGIN: test / test123 && echo. && python -m http.server 8081"
) else (
    echo Flutter not installed - skipping mobile app
)

timeout /t 5 /nobreak

:: Open Chrome
start chrome "http://localhost:8081"

cls
echo.
echo ================================================
echo         ✅ PANDITTALK IS RUNNING!
echo ================================================
echo.
echo    Mobile App:  http://localhost:8081
echo    Backend:     http://localhost:8000
echo.
echo    LOGIN CREDENTIALS:
echo    Username: test
echo    Password: test123
echo.
echo    OR click Register to create account!
echo.
echo ================================================
echo.
echo    Keep the backend window OPEN!
echo    Chrome will open automatically...
echo.
echo ================================================
echo.
timeout /t 5
exit
