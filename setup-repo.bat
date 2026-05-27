@echo off
REM ===================================================================
REM GPS Daily Intelligence Brief — One-Shot Setup Script
REM
REM What this does:
REM   1. Verifies you're in the right folder
REM   2. Sets up Windows Credential Manager (so future pushes need no PAT)
REM   3. Initializes git
REM   4. Commits everything
REM   5. Pushes to GitHub (will prompt for PAT once)
REM
REM Prerequisites (you must do these FIRST):
REM   - Created repo "GPS-Daily-Intelligence-Brief" at github.com/Rockie-9
REM   - Have a PAT ready with 'repo' scope (github.com/settings/tokens)
REM ===================================================================

setlocal enabledelayedexpansion
color 0F
echo.
echo ============================================================
echo   GPS Daily Intelligence Brief - Repo Setup
echo ============================================================
echo.

REM Sanity check: are we in the right folder?
if not exist "README.md" (
    echo [ERROR] README.md not found in current folder.
    echo.
    echo Please cd into the GPS-Daily-Intelligence-Brief folder first.
    echo Example: cd C:\Users\rockie\repos\GPS-Daily-Intelligence-Brief
    echo.
    pause
    exit /b 1
)

if not exist "daily\2026-05-27.html" (
    echo [ERROR] daily\2026-05-27.html not found.
    echo This doesn't look like the GPS Brief starter folder.
    echo.
    pause
    exit /b 1
)

echo [1/6] Folder check passed.
echo.

REM Check git is installed
where git >nul 2>nul
if errorlevel 1 (
    echo [ERROR] git is not installed or not on PATH.
    echo Download from: https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

echo [2/6] Git found: 
git --version
echo.

REM Configure credential helper to use Windows Credential Manager
echo [3/6] Configuring Windows Credential Manager for git auth...
git config --global credential.helper manager
echo Done. Your PAT will be stored securely after the first push.
echo.

REM Set git user identity (idempotent)
echo [4/6] Setting git commit author identity...
git config user.name "GPS Brief Bot" 2>nul
git config user.email "gps-brief@noreply.local" 2>nul

REM Initialize repo if not already
if not exist ".git" (
    git init
    git branch -M main
    echo Initialized new git repo.
) else (
    echo Git repo already initialized.
)
echo.

REM Stage and commit
echo [5/6] Staging and committing files...
git add -A
git diff --cached --quiet
if errorlevel 1 (
    git commit -m "Initial setup - Issue #147"
    echo Commit created.
) else (
    echo Nothing new to commit.
)
echo.

REM Add remote if not exists
git remote get-url origin >nul 2>nul
if errorlevel 1 (
    git remote add origin https://github.com/Rockie-9/GPS-Daily-Intelligence-Brief.git
    echo Remote 'origin' added.
) else (
    echo Remote 'origin' already configured:
    git remote get-url origin
)
echo.

REM Push
echo [6/6] Pushing to GitHub...
echo.
echo IMPORTANT: A credential dialog will pop up.
echo   Username: Rockie-9
echo   Password: paste your PAT (not your GitHub password)
echo.
echo The PAT will be stored in Windows Credential Manager.
echo Future pushes won't ask again.
echo.
pause

git push -u origin main

if errorlevel 1 (
    echo.
    echo ============================================================
    echo   [FAILED] Push did not succeed.
    echo ============================================================
    echo Common causes:
    echo   - PAT wrong or expired
    echo   - PAT lacks 'repo' scope
    echo   - Repo not yet created on GitHub
    echo   - Repo name typo (must be: GPS-Daily-Intelligence-Brief)
    echo.
    echo Fix the issue and re-run this script.
    echo.
    pause
    exit /b 1
)

echo.
echo ============================================================
echo   SUCCESS - Repo deployed to GitHub
echo ============================================================
echo.
echo Next steps:
echo   1. Visit https://github.com/Rockie-9/GPS-Daily-Intelligence-Brief
echo      to verify files are uploaded.
echo.
echo   2. Enable GitHub Pages:
echo      Settings - Pages - Source: GitHub Actions - Save
echo.
echo   3. Wait 1-2 minutes, then visit:
echo      https://rockie-9.github.io/GPS-Daily-Intelligence-Brief/
echo.
echo   4. Tell Claude you're done so it can wire the Python script.
echo.
pause
endlocal
