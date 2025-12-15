@echo off
title PanditTalk - Starting...

echo.
echo ========================================
echo      STARTING PANDITTALK SYSTEM
echo ========================================
echo.

REM Navigate to backend
cd /d "%~dp0backend"

REM Create virtual environment if it doesn't exist
if not exist venv (
    echo [1/7] Creating virtual environment...
    python -m venv venv
) else (
    echo [1/7] Virtual environment exists
)

REM Activate virtual environment
echo [2/7] Activating virtual environment...
call venv\Scripts\activate.bat

REM Install dependencies
echo [3/7] Installing dependencies...
pip install -q -r requirements.txt

REM Run migrations
echo [4/7] Running database migrations...
python manage.py makemigrations --noinput
python manage.py migrate --noinput

REM Start Django backend
echo [5/7] Starting Django backend...
start "PanditTalk Backend" cmd /k "cd /d %~dp0backend && call venv\Scripts\activate.bat && python manage.py runserver 127.0.0.1:8000 --noreload"

REM Wait for backend to start
timeout /t 8 /nobreak >nul

REM Start Pandit App
echo [6/7] Starting Pandit App...
start "PanditTalk Pandit App" cmd /k "cd /d %~dp0pandit_app && flutter run -d chrome --web-port=8081"

REM Wait for Pandit app to initialize
timeout /t 10 /nobreak >nul

REM Start User App
echo [7/7] Starting User App...
start "PanditTalk User App" cmd /k "cd /d %~dp0mobile && flutter run -d chrome --web-port=8082"

REM Wait for User app to initialize
timeout /t 5 /nobreak >nul

REM Open admin panel
start http://localhost:8000/admin

echo.
echo ========================================
echo       PANDITTALK STARTED SUCCESSFULLY!
echo ========================================
echo.
echo Backend:    http://localhost:8000
echo Admin:      http://localhost:8000/admin
echo Pandit App: http://localhost:8081
echo User App:   http://localhost:8082
echo.
echo Press any key to exit this window...
pause >nul
exit
