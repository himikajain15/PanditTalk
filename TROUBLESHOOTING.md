# Troubleshooting Login Issues

## Issue: "Failed to fetch" or "Cannot connect to backend"

### Step 1: Check if Backend Server is Running

1. Open a terminal in the `backend` directory
2. Activate virtual environment:
   ```bash
   # Windows PowerShell
   .\venv\Scripts\Activate.ps1
   
   # Or Windows CMD
   venv\Scripts\activate
   ```

3. Start the Django server:
   ```bash
   python manage.py runserver
   ```

   You should see:
   ```
   Starting development server at http://127.0.0.1:8000/
   ```

### Step 2: Verify Backend is Accessible

Open your browser and go to:
- http://localhost:8000/admin/ (Django admin)
- http://localhost:8000/api/auth/login/ (Should return an error about POST method, not connection error)

### Step 3: Check Flutter Web Server Port

Your Flutter app is running on `localhost:36089`. The backend should be on `localhost:8000`.

### Step 4: Test API Connection

Try this in your browser console or use curl:

```bash
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"username":"test","password":"test"}'
```

### Common Issues:

1. **Port Conflict**: If port 8000 is in use, Django will try 8001, 8002, etc. Update the Flutter API service baseUrl accordingly.

2. **Firewall**: Windows Firewall might be blocking the connection. Temporarily disable it for testing.

3. **CORS Issues**: Make sure `CORS_ALLOW_ALL_ORIGINS = True` is set in `backend/pandittalk/settings.py`

4. **Virtual Environment**: Make sure you're using the correct Python environment with all dependencies installed:
   ```bash
   pip install -r requirements.txt
   ```

### Quick Fix:

If the server won't start, check:
```bash
# Check if port 8000 is in use
netstat -ano | findstr :8000

# Kill process if needed (replace PID with actual process ID)
taskkill /PID <PID> /F
```

Then restart the server.

