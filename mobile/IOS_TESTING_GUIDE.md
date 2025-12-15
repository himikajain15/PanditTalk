# iOS Testing Guide for PanditTalk App

## Prerequisites
1. **Mac Computer** (required - iOS development only works on macOS)
2. **Xcode** (download from Mac App Store - free)
3. **Apple ID** (free account works for testing on your own device)
4. **iPhone/iPad** (iOS 12.0 or later)

## Step-by-Step Setup

### 1. Install Xcode
- Open Mac App Store
- Search for "Xcode"
- Click "Get" or "Install" (it's free, but large ~15GB)
- Wait for installation to complete

### 2. Install Xcode Command Line Tools
Open Terminal and run:
```bash
xcode-select --install
```

### 3. Accept Xcode License
```bash
sudo xcodebuild -license accept
```

### 4. Open iOS Project in Xcode
```bash
cd /path/to/PanditTalk/mobile
open ios/Runner.xcworkspace
```
**Important:** Open `.xcworkspace` NOT `.xcodeproj`

### 5. Configure Signing & Capabilities
1. In Xcode, select **Runner** in the left sidebar
2. Select **Runner** target (under TARGETS)
3. Go to **Signing & Capabilities** tab
4. Check **"Automatically manage signing"**
5. Select your **Team** (your Apple ID)
   - If you don't see your team, click "Add Account" and sign in with your Apple ID
6. Xcode will automatically create a provisioning profile

### 6. Connect Your iPhone/iPad
1. Connect your iOS device to Mac via USB cable
2. Unlock your device
3. Trust the computer if prompted (tap "Trust" on device)
4. In Xcode, you should see your device in the device selector at the top

### 7. Register Your Device (First Time Only)
1. In Xcode, go to **Window → Devices and Simulators**
2. Select your connected device
3. If you see "This device is not registered", click **"Use for Development"**
4. You may need to enter your Apple ID password

### 8. Build and Run from Flutter
From Terminal (in the mobile directory):
```bash
flutter devices                    # Check if device is detected
flutter run -d <device-id>         # Run on your iOS device
```

Or build from Xcode:
1. Select your device from the device dropdown (top of Xcode)
2. Click the **Play** button (▶️) or press `Cmd + R`
3. Wait for build to complete
4. App will install and launch on your device

### 9. Trust Developer Certificate on Device (First Time)
When you first run the app on your device:
1. Go to **Settings → General → VPN & Device Management** (or **Profiles & Device Management**)
2. Tap on your developer certificate (your name/email)
3. Tap **"Trust [Your Name]"**
4. Tap **"Trust"** in the confirmation dialog
5. Go back and launch the app

### 10. Enable Developer Mode (iOS 16+)
If you're on iOS 16 or later:
1. Go to **Settings → Privacy & Security**
2. Scroll down to **Developer Mode**
3. Toggle it **ON**
4. Restart your device when prompted
5. Confirm you want to enable Developer Mode

## Troubleshooting

### Device Not Detected
- Make sure device is unlocked
- Try a different USB cable
- Trust the computer on your device
- Restart Xcode

### Code Signing Errors
- Make sure "Automatically manage signing" is checked
- Select the correct Team
- Clean build folder: `Product → Clean Build Folder` (Shift + Cmd + K)

### "Untrusted Developer" Error
- Go to Settings → General → VPN & Device Management
- Trust your developer certificate

### Build Errors
```bash
cd ios
pod install          # Install CocoaPods dependencies
cd ..
flutter clean
flutter pub get
flutter run
```

## Quick Commands

```bash
# Check connected devices
flutter devices

# Run on iOS device
flutter run -d <device-id>

# Build iOS app
flutter build ios

# Open iOS project in Xcode
open ios/Runner.xcworkspace
```

## Notes
- **Free Apple ID** works for testing on your own device (no paid developer account needed)
- Apps installed this way expire after 7 days (for free accounts)
- You'll need to rebuild and reinstall after 7 days
- For App Store distribution, you need a paid Apple Developer account ($99/year)

