@echo off
title Krishan POS - Automated 1-Click Windows Setup
color 0b
cd /d "%~dp0"

echo =======================================================================
echo    KRISHAN COMMUNICATION ^& STUDIO - POS SYSTEM INSTALLER
echo    Windows Automated Setup ^& Desktop Shortcut Configuration
echo =======================================================================
echo.

:: 1. Check Node.js Runtime
echo [1/5] Checking Node.js Environment...
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [!] Node.js runtime was not found on this computer.
    echo     Krishan POS requires Node.js LTS version to run.
    echo.
    echo     Opening the official Node.js download page...
    start https://nodejs.org/en/download
    echo.
    echo Please install Node.js and run this "Install-Krishan-POS.bat" again.
    echo.
    pause
    exit /b
)
echo [OK] Node.js is installed and ready.
echo.

:: 2. Generate App Icons and Assets
echo [2/5] Initializing App Icons and Local Assets...
if exist create-icons.js (
    node create-icons.js >nul 2>&1
)
echo [OK] Icons initialized.
echo.

:: 3. Install/Verify Node Dependencies
echo [3/5] Verifying System Libraries and Packages...
if not exist node_modules (
    echo [*] Installing dependencies for first-time setup...
    call npm.cmd install --production
) else (
    echo [OK] Libraries are already verified.
)
echo.

:: 4. Create Desktop Shortcut with POS Icon
echo [4/5] Creating Windows Desktop Shortcut...
set "SCRIPT_DIR=%~dp0"
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "VBS_MAKER=%TEMP%\create_pos_shortcut.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBS_MAKER%"
echo sLinkFile = oWS.SpecialFolders("Desktop") ^& "\Krishan POS.lnk" >> "%VBS_MAKER%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS_MAKER%"
echo oLink.TargetPath = "%SCRIPT_DIR%\Run-Krishan-POS.vbs" >> "%VBS_MAKER%"
echo oLink.WorkingDirectory = "%SCRIPT_DIR%" >> "%VBS_MAKER%"
echo oLink.Description = "Krishan Communication and Studio Point of Sale System" >> "%VBS_MAKER%"
if exist "%SCRIPT_DIR%\assets\icons\app-icon.ico" (
    echo oLink.IconLocation = "%SCRIPT_DIR%\assets\icons\app-icon.ico, 0" >> "%VBS_MAKER%"
)
echo oLink.Save >> "%VBS_MAKER%"

cscript /nologo "%VBS_MAKER%"
del "%VBS_MAKER%" >nul 2>&1
echo [OK] Desktop Shortcut "Krishan POS" created successfully!
echo.

:: 5. Create Start Menu Shortcut
echo [5/5] Creating Start Menu Shortcut...
set "VBS_START_MAKER=%TEMP%\create_start_shortcut.vbs"
echo Set oWS = WScript.CreateObject("WScript.Shell") > "%VBS_START_MAKER%"
echo sPrograms = oWS.SpecialFolders("Programs") >> "%VBS_START_MAKER%"
echo sLinkFile = sPrograms ^& "\Krishan POS.lnk" >> "%VBS_START_MAKER%"
echo Set oLink = oWS.CreateShortcut(sLinkFile) >> "%VBS_START_MAKER%"
echo oLink.TargetPath = "%SCRIPT_DIR%\Run-Krishan-POS.vbs" >> "%VBS_START_MAKER%"
echo oLink.WorkingDirectory = "%SCRIPT_DIR%" >> "%VBS_START_MAKER%"
echo oLink.Description = "Krishan Communication and Studio Point of Sale System" >> "%VBS_START_MAKER%"
if exist "%SCRIPT_DIR%\assets\icons\app-icon.ico" (
    echo oLink.IconLocation = "%SCRIPT_DIR%\assets\icons\app-icon.ico, 0" >> "%VBS_START_MAKER%"
)
echo oLink.Save >> "%VBS_START_MAKER%"

cscript /nologo "%VBS_START_MAKER%"
del "%VBS_START_MAKER%" >nul 2>&1
echo [OK] Start Menu Shortcut created successfully!
echo.

echo =======================================================================
echo    INSTALLATION COMPLETE!
echo.
echo    You can now launch Krishan POS anytime using the Desktop Icon:
echo       "Krishan POS"
echo.
echo    Multi-Device / Phone Sync:
echo       Open the system and click the "Mobile / QR" button to connect
echo       any phone or tablet on your shop Wi-Fi or Internet.
echo =======================================================================
echo.

set /p LAUNCH="Would you like to launch Krishan POS now? (Y/N): "
if /i "%LAUNCH%"=="Y" (
    start "" "%SCRIPT_DIR%\Run-Krishan-POS.vbs"
)

exit /b
