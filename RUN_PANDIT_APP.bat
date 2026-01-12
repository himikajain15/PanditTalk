@echo off
cls
echo.
echo ================================================
echo       PanditTalk Pandit App - Wireless Run
echo ================================================
echo.

REM Get computer's IP address
echo [1/4] Detecting your computer's IP address...
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"IPv4 Address"') do (
    set IP=%%a
    goto :found_ip
)

:found_ip
set IP=%IP:~1%
echo Your computer's IP: %IP%
echo.

REM Update constants.dart with correct IP
echo [2/4] Updating app to use IP: %IP%...

cd pandit_app\lib\config

REM Backup original if it doesn't exist
if not exist constants.dart.backup (
    copy constants.dart constants.dart.backup >nul
)

REM Use localhost which will be forwarded via USB reverse
powershell -Command "(Get-Content constants.dart) -replace 'http://10\.0\.2\.2:8000/api', 'http://localhost:8000/api' | Set-Content constants.dart"
powershell -Command "(Get-Content constants.dart) -replace 'http://172\.\d+\.\d+\.\d+:8000/api', 'http://localhost:8000/api' | Set-Content constants.dart"

cd ..\..\..

echo ✓ App configured to use: http://%IP%:8000
echo.

REM Start Backend in new window
echo [3/4] Starting Backend Server...
start "PanditTalk Backend" cmd /k "cd /d %CD%\backend && venv\Scripts\activate && python manage.py runserver 0.0.0.0:8000"

REM Wait for backend to start
timeout /t 5 /nobreak >nul

echo ✓ Backend server running at: http://%IP%:8000
echo.

echo [4/5] Setting up USB port forwarding...
set ADB_PATH=C:\Users\user\AppData\Local\Android\sdk\platform-tools\adb.exe
"%ADB_PATH%" devices | findstr "device$" >nul
if errorlevel 1 (
    echo.
    echo ⚠️  WARNING: No device connected!
    echo.
    echo Please:
    echo   1. Connect phone via USB, OR
    echo   2. Run RECONNECT_DEVICE.bat to connect wirelessly
    echo.
    echo Checking again in 3 seconds...
    timeout /t 3 /nobreak >nul
    "%ADB_PATH%" devices | findstr "device$" >nul
    if errorlevel 1 (
        echo.
        echo ❌ Still no device found. Exiting...
        echo Please connect your device and try again.
        pause
        exit /b 1
    )
)
echo ✓ Device connected!

echo Setting up USB port forwarding (bypasses WiFi issues)...
"%ADB_PATH%" reverse tcp:8000 tcp:8000
echo ✓ Port forwarding active
echo.

echo [5/5] Launching Pandit App on Phone with HOT RELOAD...
echo.
echo ⚠️  IMPORTANT:
echo    - Keep this window OPEN while you are developing.
echo    - After you change any Dart code, just SAVE the file.
echo    - Flutter will HOT RELOAD your running app automatically.
echo      (Press "r" here for hot reload, "R" for hot restart if needed.)
echo.
echo Phone and computer should be on SAME WiFi.
echo Backend URL: http://%IP%:8000
echo.
echo First launch may take a few minutes. Later code changes are fast.
echo.

cd pandit_app

echo Building and launching app on your phone...
echo.
call flutter run --debug

cd ..

echo.
echo ================================================
echo Pandit App session ended
echo ================================================
echo.
echo Press any key to exit...
pause >nul
