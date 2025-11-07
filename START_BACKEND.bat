@echo off
title BACKEND SERVER - KEEP THIS OPEN!
color 0A

cd /d "%~dp0backend"

cls
echo.
echo ================================================
echo    Installing packages...
echo ================================================
"C:\Program Files\Python313\python.exe" -m pip install Django djangorestframework djangorestframework-simplejwt python-dotenv dj-database-url django-cors-headers requests --user -qmo

cls
echo.
echo ================================================
echo    Setting up database...
echo ================================================
"C:\Program Files\Python313\python.exe" manage.py makemigrations
"C:\Program Files\Python313\python.exe" manage.py migrate --run-syncdb

cls
echo.
echo ================================================
echo    Creating test user and dummy pandits...
echo ================================================
"C:\Program Files\Python313\python.exe" manage.py shell -c "from django.contrib.auth import get_user_model; U=get_user_model(); U.objects.filter(username='test').exists() or U.objects.create_user('test','test@test.com','test123')"
"C:\Program Files\Python313\python.exe" manage.py create_dummy_pandits

if not exist "pandittalk\static" mkdir pandittalk\static

cls
echo.
echo ================================================
echo    BACKEND IS RUNNING!
echo ================================================
echo.
echo    URL: http://localhost:8000
echo.
echo    LOGIN: test / test123
echo.
echo    KEEP THIS WINDOW OPEN!
echo ================================================
echo.

"C:\Program Files\Python313\python.exe" manage.py runserver 127.0.0.1:8000 --noreload

pause
