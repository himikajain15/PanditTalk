@echo off
echo Installing Backend Dependencies...
cd /d "%~dp0"
call venv\Scripts\activate.bat
pip install -r requirements.txt
echo.
echo Dependencies installed!
pause

