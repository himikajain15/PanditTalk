@echo off
title PanditTalk - Starting Servers
color 0A

echo.
echo ========================================
echo    🚀 Starting PanditTalk Application
echo ========================================
echo.

:: Get the current directory (should be C:\Pandittalk)
cd /d "%~dp0"

:: Start Backend Server (Django) in a new window
echo [1/2] Starting Backend Server (Django)...
start "PanditTalk Backend Server" cmd /k "cd /d %~dp0backend && venv\Scripts\activate && echo Installing dependencies if needed... && pip install -q -r requirements.txt && echo Backend Server Starting... && python manage.py runserver 127.0.0.1:8000"

:: Wait a bit for backend to initialize
timeout /t 4 /nobreak >nul

:: Start Frontend (Flutter Web) in a new window
echo [2/2] Starting Frontend (Flutter Web)...
start "PanditTalk Frontend Server" cmd /k "cd /d %~dp0mobile && echo Frontend Starting... && flutter run -d chrome"

echo.
echo ========================================
echo    ✅ Both servers are starting!
echo ========================================
echo.
echo    📦 Backend:   http://localhost:8000
echo    📱 Frontend:  Will open in Chrome
echo.
echo    ℹ️  Two new windows opened:
echo       1. Backend Server (keep open)
echo       2. Frontend Server (keep open)
echo.
echo    🔴 To stop: Close the server windows
echo ========================================
echo.
pause

