@echo off
cd /d "%~dp0"
echo Starting Django Backend Server...
call venv\Scripts\activate.bat
python manage.py runserver 0.0.0.0:8000
pause

