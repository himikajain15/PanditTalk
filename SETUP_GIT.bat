@echo off
title PanditTalk - Git Setup
color 0E

echo.
echo ========================================
echo    🚀 PanditTalk Git Setup
echo ========================================
echo.

cd /d "%~dp0"

echo [Step 1] Checking if git is installed...
where git >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ Git is not installed!
    echo.
    echo Please install Git from: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)
echo ✓ Git is installed!
echo.

echo [Step 2] Initializing git repository...
git init
echo.

echo [Step 3] Current git status:
echo.
git status
echo.

echo ========================================
echo    📋 Next Steps:
echo ========================================
echo.
echo 1. Add your remote repository:
echo    git remote add origin https://github.com/yourusername/pandittalk.git
echo.
echo 2. Add all files:
echo    git add .
echo.
echo 3. Commit:
echo    git commit -m "Initial commit: PanditTalk with UI updates"
echo.
echo 4. Push:
echo    git push -u origin main
echo.
echo OR just follow the guide in GIT_PUSH_GUIDE.md
echo.
echo ========================================
echo.

pause

