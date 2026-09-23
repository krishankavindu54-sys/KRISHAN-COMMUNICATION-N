@echo off
title Krishan POS - Wi-Fi & Firewall Setup
color 0a
cd /d "%~dp0"

:: Check for Administrator permissions and auto-elevate
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [i] Requesting Administrator permissions to configure Windows Firewall...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo =======================================================================
echo    KRISHAN POS - WI-FI ^& FIREWALL ACCESS CONFIGURATION
echo    Allows other phones, tablets, and computers on Wi-Fi to connect
echo =======================================================================
echo.

:: 1. Open Windows Firewall Port 3000
echo [*] Adding Inbound Firewall Rule for Port 3000...
netsh advfirewall firewall delete rule name="Krishan POS System" >nul 2>&1
netsh advfirewall firewall add rule name="Krishan POS System" dir=in action=allow protocol=TCP localport=3000 >nul 2>&1

if %errorlevel% equ 0 (
    echo [OK] Windows Firewall rule successfully added for Port 3000!
) else (
    echo [!] Could not configure firewall automatically.
)

:: 2. Find Local IP address
for /f "tokens=4" %%a in ('route print ^| findstr 0.0.0.0.*0.0.0.0') do (
    set LOCAL_IP=%%a
)

echo.
echo =======================================================================
echo    🎉 WI-FI CONFIGURATION COMPLETE!
echo.
echo    💻 Main Computer URL:
echo       http://localhost:3000
echo.
echo    📱 Phone / Tablet Wi-Fi URL:
echo       http://%LOCAL_IP%:3000
echo.
echo    ⚡ Quick Cashier Auto-Login URL:
echo       http://%LOCAL_IP%:3000/login?quick=cashier
echo.
echo    Any phone on your shop Wi-Fi can now scan the QR code and connect!
echo =======================================================================
echo.
pause
