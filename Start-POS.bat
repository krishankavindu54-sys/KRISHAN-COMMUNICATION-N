@echo off
title Krishan POS - Realtime Multi-Device Server
color 0b
cd /d "%~dp0"

echo =======================================================================
echo    🏪 Starting Krishan Communication ^& Studio POS Software...
echo =======================================================================
echo.

where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [!] Node.js was not detected on this system.
    echo     Please install Node.js from https://nodejs.org
    echo.
    pause
    exit /b
)

:: Launch browser window with 1.5s delay to ensure port 3000 is listening
start "" powershell -Command "Start-Sleep -Milliseconds 1500; if (Test-Path 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe') { Start-Process 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe' '--app=http://localhost:3000 --window-size=1280,850' } elseif (Test-Path 'C:\Program Files\Microsoft\Edge\Application\msedge.exe') { Start-Process 'C:\Program Files\Microsoft\Edge\Application\msedge.exe' '--app=http://localhost:3000 --window-size=1280,850' } elseif (Test-Path 'C:\Program Files\Google\Chrome\Application\chrome.exe') { Start-Process 'C:\Program Files\Google\Chrome\Application\chrome.exe' '--app=http://localhost:3000 --window-size=1280,850' } else { Start-Process 'http://localhost:3000' }"

echo [*] Starting Local Backend Server with Realtime WebSocket Sync...
echo     (Press Ctrl + C anytime to stop the server)
echo.

node server.js
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo Server has stopped.
    pause
)
