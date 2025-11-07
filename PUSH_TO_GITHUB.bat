@echo off
title Push to GitHub - PanditTalk
color 0A

echo.
echo ========================================
echo    🚀 Pushing to GitHub
echo ========================================
echo.

cd /d "%~dp0"

echo [Step 1] Initializing git repository...
git init
echo.

echo [Step 2] Adding remote repository...
git remote add origin https://github.com/himikajain15/PanditTalk.git
echo.

echo [Step 3] Checking current status...
git status
echo.

echo [Step 4] Adding all files...
git add .
echo.

echo [Step 5] Committing changes...
git commit -m "Major UI Redesign: AstroTalk-Inspired Professional Theme

✨ New Features:
- Redesigned login with phone/OTP and social login options
- Added clickable quick actions (Horoscope, Kundli, Blog)
- Implemented photo upload in Edit Profile
- Created Rate Us and Help & Support screens
- Added Daily Horoscope, Kundli Matching, Blog screens
- Linked recharge button to payment gateway

🎨 UI Updates:
- Updated sidebar to match AstroTalk design
- Changed bottom nav: Remedies → Profile
- Applied professional yellow/white/black theme
- Enhanced all screens with consistent styling

📦 Dependencies:
- Added image_picker for profile photo uploads
- Updated pubspec.yaml

🔧 Backend:
- Created dummy pandits management command
- Updated models for celebrity status
- Comprehensive .gitignore for Flutter/Django"
echo.

echo [Step 6] Setting branch to main...
git branch -M main
echo.

echo [Step 7] Pushing to GitHub...
git push -u origin main
echo.

echo ========================================
echo    ✅ Push Complete!
echo ========================================
echo.
echo Your code is now on GitHub:
echo https://github.com/himikajain15/PanditTalk
echo.

pause

