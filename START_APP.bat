@echo off
title MOBILE APP SERVER
color 0B

cd /d "%~dp0mobile\build\web"

cls
echo.
echo ================================================
echo    MOBILE APP IS RUNNING!
echo ================================================
echo.
echo    URL: http://localhost:8081
echo.
echo    LOGIN: test / test123
echo.
echo    Opening in Chrome...
echo ================================================
echo.

start chrome "http://localhost:8081"

"C:\Program Files\Python313\python.exe" -m http.server 8081

pause
