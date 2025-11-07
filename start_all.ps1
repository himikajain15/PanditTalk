# PowerShell script to start both Backend and Frontend together
# Run from C:\Pandittalk directory

Write-Host "🚀 Starting PanditTalk Application..." -ForegroundColor Green
Write-Host ""

# Start Backend Server (Django)
Write-Host "📦 Starting Backend Server (Django)..." -ForegroundColor Yellow
$backendJob = Start-Job -ScriptBlock {
    Set-Location $using:PWD
    Set-Location backend
    & .\venv\Scripts\python.exe manage.py runserver 127.0.0.1:8000
}

# Wait a moment for backend to start
Start-Sleep -Seconds 3

# Start Frontend (Flutter Web)
Write-Host "📱 Starting Frontend (Flutter Web)..." -ForegroundColor Yellow
$frontendJob = Start-Job -ScriptBlock {
    Set-Location $using:PWD
    Set-Location mobile
    flutter run -d chrome
}

Write-Host ""
Write-Host "✅ Both servers are starting in the background!" -ForegroundColor Green
Write-Host ""
Write-Host "Backend will be available at: http://localhost:8000" -ForegroundColor Cyan
Write-Host "Frontend will open in Chrome browser automatically" -ForegroundColor Cyan
Write-Host ""
Write-Host "To stop servers, press Ctrl+C or close this window" -ForegroundColor Yellow
Write-Host ""
Write-Host "Waiting for servers to start..."
Write-Host ""

# Wait for jobs and show output
try {
    while ($true) {
        Start-Sleep -Seconds 2
        
        # Show backend output
        $backendOutput = Receive-Job -Job $backendJob -ErrorAction SilentlyContinue
        if ($backendOutput) {
            Write-Host "[Backend] $backendOutput" -ForegroundColor Magenta
        }
        
        # Show frontend output
        $frontendOutput = Receive-Job -Job $frontendJob -ErrorAction SilentlyContinue
        if ($frontendOutput) {
            Write-Host "[Frontend] $frontendOutput" -ForegroundColor Blue
        }
    }
}
finally {
    Write-Host ""
    Write-Host "🛑 Stopping servers..." -ForegroundColor Red
    Stop-Job -Job $backendJob,$frontendJob -ErrorAction SilentlyContinue
    Remove-Job -Job $backendJob,$frontendJob -ErrorAction SilentlyContinue
    Write-Host "✅ Servers stopped." -ForegroundColor Green
}

