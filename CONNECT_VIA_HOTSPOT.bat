@echo off
setlocal enabledelayedexpansion
cls
echo.
echo ╔══════════════════════════════════════════════════════════════╗
echo ║          PanditTalk - Mobile Hotspot Connection             ║
echo ╚══════════════════════════════════════════════════════════════╝
echo.

echo [1/3] Detecting connection to phone's hotspot...
echo.

REM Find the default gateway (phone's IP)
for /f "tokens=2 delims=:" %%a in ('ipconfig ^| findstr /c:"Default Gateway"') do (
    set GW=%%a
    set GW=!GW:~1!
    if not "!GW!"=="" (
        if not "!GW!"=="0.0.0.0" (
            echo Found gateway: !GW!
            goto :found_gateway
        )
    )
)

:found_gateway
echo Your phone's IP (gateway): !GW!
echo.

echo [2/3] Updating app to use phone's hotspot IP...
cd mobile\lib\utils

REM Update constants.dart to use the gateway IP
powershell -Command "(Get-Content constants.dart) -replace 'http://.*:8000', 'http://!GW!:8000' | Set-Content constants.dart"

cd ..\..\..

echo ✓ App configured to use: http://!GW!:8000
echo.

echo [3/3] Instructions:
echo.
echo ✓ Your phone is at: !GW!
echo ✓ Backend should be running on your PC
echo ✓ Phone can now reach backend directly!
echo.
echo NEXT STEPS:
echo 1. Make sure backend is running (check terminal)
echo 2. Hot restart your Flutter app (press 'R' in terminal)
echo 3. Try logging in!
echo.
echo ════════════════════════════════════════════════════════════════
echo.
pause

