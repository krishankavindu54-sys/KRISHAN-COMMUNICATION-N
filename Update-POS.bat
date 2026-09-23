@echo off
title Krishan POS - System Updater
color 0e
cd /d "%~dp0"

echo =======================================================================
echo    🔄 KRISHAN POS - 1-CLICK SYSTEM UPDATER
echo    Safely updates system files without deleting your sales or settings
echo =======================================================================
echo.

echo Choose update option:
echo [1] Quick Update: Refresh libraries and generate latest app icons
echo [2] Git Update: Pull latest code from GitHub (if using Git)
echo [3] Full Reset / Fresh Dependencies Setup
echo [4] Cancel
echo.

set /p OPTION="Select an option (1-4): "

if "%OPTION%"=="1" (
    echo.
    echo [*] Refreshing dependencies and icons...
    call npm.cmd install --production
    node create-icons.js
    echo.
    echo [✔] System updated successfully!
    pause
    exit /b
)

if "%OPTION%"=="2" (
    echo.
    echo [*] Pulling latest updates from GitHub...
    git pull
    call npm.cmd install --production
    node create-icons.js
    echo.
    echo [✔] Updated from GitHub repository!
    pause
    exit /b
)

if "%OPTION%"=="3" (
    echo.
    echo [*] Re-installing Node dependencies...
    rmdir /s /q node_modules 2>nul
    call npm.cmd install --production
    node create-icons.js
    echo.
    echo [✔] Clean install complete!
    pause
    exit /b
)

echo Cancelled.
exit /b
