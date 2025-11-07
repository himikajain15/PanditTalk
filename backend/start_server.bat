@echo off
cd /d "%~dp0"
echo Starting Django Backend Server...
call venv\Scripts\activate.bat
python manage.py runserver 127.0.0.1:8000
pause

