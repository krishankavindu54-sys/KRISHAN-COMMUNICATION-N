@echo off
chcp 65001 >nul
title Krishan POS - GitHub Helper
color 0b

echo ================================================================
echo        🚀 KRISHAN POS - GITHUB UPLOAD & DEPLOY HELPER
echo ================================================================
echo.
echo [!] GitHub Web Upload Error එක ඇතිවන්නේ ඇයි?
echo     ඔබ සම්පූර්ණ f:\pos ෆෝල්ඩරයම Drag කර දැමූ විට, එහි ඇති "node_modules"
echo     ෆෝල්ඩරයේ files 5,000කට වඩා ඇති බැවින් GitHub Web මඟින් එය ප්‍රතික්ෂේප කරයි.
echo     (GitHub Web Upload Limit = Max 100 Files)
echo.
echo ----------------------------------------------------------------
echo   ක්‍රම 2 කින් ඉතා පහසුවෙන් GitHub වෙත දමාගත හැක:
echo ----------------------------------------------------------------
echo.
echo   [1] පහසුම ක්‍රමය (Drag & Drop):
echo       අප විසින් node_modules නොමැතිව clean files 25 පමණක්
echo       "f:\pos\github-upload" ෆෝල්ඩරයට වෙන් කර සකසා ඇත!
echo       ඔබේ GitHub Repository පිටුවේ ඇති "Upload files" බටන් එක ඔබා
echo       "github-upload" ෆෝල්ඩරයේ ඇති ගොනු සියල්ල Drag & Drop කරන්න.
echo.
echo   [2] ස්වයංක්‍රීය Git Push ක්‍රමය (Recommended):
echo       Command Line හරහා එක ක්ලික් එකෙන් සම්පූර්ණ code එක GitHub වෙත push කිරීම.
echo.
echo ================================================================
set /p opt="ඔබට අවශ්‍ය ක්‍රමය තෝරන්න (1 හෝ 2): "

if "%opt%"=="1" (
    echo.
    echo 📂 "github-upload" ෆෝල්ඩරය විවෘත වේ...
    start "" "f:\pos\github-upload"
    echo.
    echo ✔ දැන් විවෘත වූ ෆෝල්ඩරයේ ඇති සියලුම files (Ctrl+A ඔබා) Select කර
    echo   GitHub Repository එක වෙත Drag & Drop කරන්න!
    pause
    exit /b
)

echo.
echo 🔍 Checking for Git installation...
where git >nul 2>nul
if %errorlevel% neq 0 (
    echo ⚠️ Git පරිගණකයේ ස්ථාපනය කර නොමැත.
    echo ⏳ Winget මඟින් Git install කරමින් පවතී (මඳ වේලාවක් රැඳෙන්න)...
    winget install --id Git.Git -e --source winget --silent --accept-package-agreements --accept-source-agreements
    echo.
    echo ✔ Git ස්ථාපනය සාර්ථකයි! කරුණාකර මෙම batch file එක නැවත විවෘත කරන්න.
    pause
    exit /b
)

echo ✔ Git හඳුනා ගන්නා ලදී.
echo.
set /p repo="ඔබගේ GitHub Repository URL එක ඇතුළත් කරන්න (උදා: https://github.com/username/repo.git): "
if "%repo%"=="" (
    echo ❌ Repository URL එක ලබා දී නොමැත.
    pause
    exit /b
)

echo.
echo 📦 Preparing Git repository...
cd /d "f:\pos"
if not exist ".git" (
    git init
)

git config user.name "Krishan POS" >nul 2>nul
git config user.email "pos@krishan.local" >nul 2>nul

echo 🔄 Adding files (node_modules automatically excluded)...
git add .
git commit -m "Update Krishan POS for Vercel Deployment" >nul 2>nul

git remote remove origin >nul 2>nul
git remote add origin %repo%
git branch -M main

echo 🚀 Pushing code to GitHub main branch...
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ================================================================
    echo ✔ සාර්ථකව GitHub වෙත Code එක Push කරන ලදී!
    echo   දැන් ඔබට Vercel වෙතින් මෙම Repository එක Import කර
    echo   Deploy කළ හැක!
    echo ================================================================
) else (
    echo.
    echo ⚠️ Push කිරීමේදී දෝෂයක් ඇතිවිය. කරුණාකර ඔබගේ GitHub Username/Password
    echo    හෝ Personal Access Token එක නිවැරදි දැයි පරීක්ෂා කරන්න.
)

pause
