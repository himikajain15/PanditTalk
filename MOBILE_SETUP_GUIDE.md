# 📱 PanditTalk Mobile App - Complete Setup Guide

## 🎯 Quick Start (3 Steps)

### Step 1: Connect Your Phone via USB
1. Enable **Developer Options** on your phone:
   - Go to Settings → About Phone
   - Tap "Build Number" 7 times
   - Developer Options will appear in Settings

2. Enable **USB Debugging**:
   - Settings → Developer Options → USB Debugging (ON)

3. Connect phone to computer via USB cable

4. Check connection:
```bash
adb devices
```
You should see your device listed.

---

### Step 2: Run the User App
```bash
# From project root
RUN_USER_APP.bat
```

**What this script does:**
1. Starts the backend server
2. Sets up USB port forwarding (bypasses WiFi issues)
3. Builds and launches the Flutter app on your phone

---

### Step 3: Run the Pandit App (Optional)
```bash
# From project root
RUN_PANDIT_APP.bat
```

---

## 🔐 Testing Login (TEST MODE)

The backend is currently in **TEST MODE** for easy development:

### User App Login:
1. Enter any 10-digit phone number (e.g., `9876543210`)
2. Tap "GET OTP"
3. **Enter ANY 6-digit OTP** (e.g., `123456`)
4. Tap "Verify & Continue"
5. ✅ You're logged in!

### Pandit App Login:
1. Enter any 10-digit phone number (e.g., `9876543211`)
2. Tap "Send OTP"
3. **Enter ANY 6-digit OTP** (e.g., `123456`)
4. Tap "Verify & Login"
5. ✅ You're logged in!

> **Note:** In TEST MODE, the backend accepts **any 6-digit OTP**. This makes testing faster without needing real SMS integration.

---

## 🐛 Troubleshooting

### Issue: "Cannot connect to backend"

**Solution:**
The scripts now use **USB port forwarding** which bypasses WiFi issues completely.
1. Ensure phone is connected via USB
2. Run `adb devices` - should show your device
3. Backend runs on `localhost`, app connects via USB forwarding

---

### Issue: "adb not recognized"

**Solution:**
1. Find your ADB path:
   - Usually: `C:\Users\<USER>\AppData\Local\Android\sdk\platform-tools\`

2. Add to PATH or use full path:
```bash
C:\Users\user\AppData\Local\Android\sdk\platform-tools\adb.exe devices
```

---

### Issue: Device not showing in `adb devices`

**Solutions:**
1. **Reconnect USB cable** and tap "Allow USB Debugging" on phone
2. **Restart ADB:**
```bash
adb kill-server
adb start-server
adb devices
```

3. **Try different USB port** or cable
4. **Revoke USB debugging** on phone and re-enable:
   - Settings → Developer Options → Revoke USB debugging authorizations
   - Reconnect and allow again

---

### Issue: OTP verification fails

**Solution:**
1. Check backend logs - you should see:
```
📱 OTP request for +919876543210 (TEST MODE: Enter any 6-digit code)
```

2. In TEST MODE, **literally any 6-digit number works** (000000, 123456, 999999, etc.)

3. If still failing, check:
   - Backend is responding: Visit `http://<PC_IP>:8000/api/auth/send-otp/` in browser
   - Phone can reach backend: Use phone browser to visit `http://<PC_IP>:8000/admin/`

---

### Issue: App builds but doesn't update

**Solution:**
```bash
# Clean and rebuild
cd mobile  # or pandit_app
flutter clean
flutter pub get
flutter run -d <device-id>
```

---

## 📊 Backend Verification

### Check if backend is accessible:

```bash
# From your phone or another computer on same network:
curl http://<YOUR_PC_IP>:8000/api/auth/send-otp/ \
  -X POST \
  -H "Content-Type: application/json" \
  -d "{\"phone\":\"+919876543210\"}"
```

Expected response:
```json
{
  "ok": true,
  "status": "sent",
  "message": "OTP sent to +919876543210 (TEST MODE: Use any 6-digit code)"
}
```

---

## 🔄 Quick Commands Reference

| Action | Command |
|--------|---------|
| List devices | `adb devices` |
| Wireless pair | `adb pair <IP>:<PORT>` |
| Wireless connect | `adb connect <IP>:5555` |
| Disconnect | `adb disconnect` |
| Restart ADB | `adb kill-server && adb start-server` |
| Run user app | `RUN_USER_APP.bat` |
| Run pandit app | `RUN_PANDIT_APP.bat` |
| Flutter clean | `cd mobile && flutter clean` |

---

## 🎨 App Architecture

```
User App (mobile/)           Pandit App (pandit_app/)
      ↓                              ↓
   API Calls                      API Calls
      ↓                              ↓
Django Backend (localhost:8000)
      ↓
PostgreSQL/SQLite Database
```

### Current Setup:
- **Backend:** Django REST + Channels (WebSocket)
- **Database:** SQLite (Development)
- **Auth:** JWT + OTP (Test Mode)
- **Real-time:** WebSocket for chat

---

## 🚀 Moving to Production

When ready for production:

1. **Enable real OTP:**
   - Uncomment OTP generation code in `backend/users/views.py`
   - Integrate SMS service (Twilio, AWS SNS, etc.)

2. **Update Settings:**
   - `backend/pandittalk/settings.py`:
     - Set `DEBUG = False`
     - Configure proper `ALLOWED_HOSTS`
     - Use PostgreSQL instead of SQLite

3. **Deploy:**
   - Backend: AWS/Heroku/DigitalOcean
   - Mobile: Google Play Store / Apple App Store

---

## 📝 Notes

- **Test Phone Numbers:** Use any 10-digit number
- **Test OTP:** Any 6-digit number works in TEST MODE
- **Default Port:** Backend runs on port 8000
- **WiFi Required:** Phone and PC must be on same network for testing
- **Hot Reload:** Flutter supports hot reload - press `r` in terminal after code changes

---

## 🆘 Still Stuck?

1. Check terminal output for detailed error messages
2. Look for error logs in:
   - Backend terminal
   - Flutter terminal
   - `adb logcat` for Android logs

3. Common patterns:
   - **Connection errors** → Backend/network issue
   - **Build errors** → Flutter dependency issue (run `flutter clean`)
   - **OTP errors** → Check backend logs for the phone number

---

## ✅ Success Checklist

- [ ] Backend running on 0.0.0.0:8000
- [ ] Phone connected (`adb devices` shows device)
- [ ] Phone and PC on same WiFi
- [ ] App installed and running on phone
- [ ] Can enter phone number
- [ ] Can receive "OTP sent" message
- [ ] Can verify with any 6-digit code
- [ ] Successfully logged in and see home screen

**Once all checked, you're ready to develop! 🎉**

