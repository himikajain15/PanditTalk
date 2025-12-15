# Testing iOS on Windows using Codemagic

## Codemagic Setup (Free Tier Available)

### Step 1: Create Codemagic Account
1. Go to https://codemagic.io
2. Sign up with GitHub/GitLab/Bitbucket (free)
3. Connect your repository

### Step 2: Configure iOS Build
1. In Codemagic dashboard, click "Add application"
2. Select your repository
3. Choose "Flutter" as the app type
4. Configure build settings:
   - Platform: iOS
   - Build type: Debug/Release
   - Code signing: Automatic (or upload certificates)

### Step 3: Build and Download
1. Click "Start new build"
2. Codemagic will build your iOS app on their Mac servers
3. Download the `.ipa` file when build completes
4. Install on your iPhone using:
   - **AltStore** (free, no developer account needed)
   - **3uTools** (Windows tool)
   - **iTunes** (if you have it)

## Alternative: GitHub Actions (Free for Public Repos)

### Create `.github/workflows/ios-build.yml`:

```yaml
name: Build iOS

on:
  workflow_dispatch:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      - run: flutter pub get
      - run: flutter build ios --release --no-codesign
      - uses: actions/upload-artifact@v3
        with:
          name: ios-build
          path: build/ios/iphoneos/Runner.app
```

Then:
1. Push to GitHub
2. Go to Actions tab
3. Download the built app
4. Install on your device

