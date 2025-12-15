@echo off
cls
echo.
echo ================================================
echo   Installing Google Sheets Integration
echo ================================================
echo.

cd backend
call venv\Scripts\activate.bat

echo Installing required packages...
pip install gspread google-auth google-api-python-client

echo.
echo ================================================
echo   ✅ Installation Complete!
echo ================================================
echo.
echo NEXT STEPS:
echo.
echo 1. Follow the guide in: GOOGLE_SHEETS_QUICK_SETUP.txt
echo 2. Download JSON credentials file
echo 3. Save it as: C:\PanditTalk\backend\google-credentials.json
echo 4. Enable BOTH Google Sheets API and Google Drive API in Google Cloud
echo 5. Share your Google Sheet with the service account email
echo 6. Restart backend and test!
echo.
pause


