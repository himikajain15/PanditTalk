# 🚀 How to Start PanditTalk Application

## Quick Start (Recommended)

From `C:\Pandittalk` directory, run:

**Windows:**
```powershell
.\start_all.bat
```

Or if you prefer PowerShell:
```powershell
.\start_all.ps1
```

This will start both backend and frontend automatically in separate windows.

---

## Manual Start (Step by Step)

### Step 1: Start Backend Server (Django)

Open **PowerShell** and run:

```powershell
# Navigate to backend
cd backend

# Activate virtual environment
.\venv\Scripts\Activate.ps1

# Start Django server
python manage.py runserver
```

You should see:
```
Starting development server at http://127.0.0.1:8000/
```

**Keep this window open!**

---

### Step 2: Start Frontend (Flutter Web)

Open a **NEW PowerShell** window and run:

```powershell
# Navigate to mobile folder
cd C:\Pandittalk\mobile

# Run Flutter web app
flutter run -d chrome
```

The app will open automatically in Chrome browser.

**Keep this window open too!**

---

## Using Terminal Tabs (VS Code)

If you're using VS Code:

1. **Terminal 1** - Backend:
   ```powershell
   cd backend
   .\venv\Scripts\Activate.ps1
   python manage.py runserver
   ```

2. **Terminal 2** - Frontend:
   ```powershell
   cd mobile
   flutter run -d chrome
   ```

---

## Verify Everything is Running

1. **Backend**: Open http://localhost:8000/admin/ in browser
2. **Frontend**: Should open automatically at http://localhost:xxxxx (Flutter will assign port)

---

## Test Login

Use these credentials:
- **Username/Email**: `testuser` or `test@pandittalk.com`
- **Password**: `test123456`

Or register a new account!

---

## Troubleshooting

### Backend won't start?
- Make sure you're in the `backend` folder
- Check if virtual environment is activated (you should see `(venv)` in prompt)
- Check if port 8000 is already in use:
  ```powershell
  netstat -ano | findstr :8000
  ```

### Frontend won't start?
- Make sure Flutter is installed: `flutter doctor`
- Make sure you're in the `mobile` folder
- Check if Chrome is installed

### Can't login?
- Make sure backend server is running on port 8000
- Check browser console (F12) for errors
- Try refreshing the page

---

## Stopping the Servers

Press `Ctrl+C` in each terminal window, or:
- Close the terminal windows
- Close the browser tab

---

Happy coding! 🙏

