@echo off
:: ============================================================
:: 1_setup_once.bat
:: Run this ONCE on the manager's machine to:
::   1. Generate a password-free SSH key
::   2. Install it on the Azure VM
::
:: After this runs, run_demo.bat works without any password prompt.
:: ============================================================

setlocal
set VM_USER=azureuser
set VM_HOST=20.40.57.76
set KEY_FILE=%USERPROFILE%\.ssh\motor_demo_key

title Motor Demo — One-Time Setup

echo ============================================================
echo  Motor Claims Demo — One-Time Setup
echo ============================================================
echo.
echo This will:
echo   1. Generate an SSH key: %KEY_FILE%
echo   2. Install it on the Azure VM (you will be asked for the VM
echo      password ONCE — this is the last time you need it)
echo.
echo Press any key to continue, or Ctrl+C to cancel.
pause >nul

:: ── Step 1: Generate SSH key (skip if it already exists) ─────────────────────
if exist "%KEY_FILE%" (
    echo [1/2] SSH key already exists at %KEY_FILE% — skipping generation.
) else (
    echo [1/2] Generating SSH key...
    ssh-keygen -t ed25519 -f "%KEY_FILE%" -N "" -C "motor-demo-key"
    if errorlevel 1 (
        echo [ERROR] ssh-keygen failed. Make sure OpenSSH is installed.
        echo         On Windows 10/11: Settings ^> Apps ^> Optional Features ^> OpenSSH Client
        pause
        exit /b 1
    )
    echo        Key saved to %KEY_FILE%
)

:: ── Step 2: Copy public key to VM ─────────────────────────────────────────────
echo.
echo [2/2] Installing key on VM (enter VM password when prompted)...
type "%KEY_FILE%.pub" | ssh -o StrictHostKeyChecking=accept-new %VM_USER%@%VM_HOST% "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys"
if errorlevel 1 (
    echo [ERROR] Could not install key on VM.
    pause
    exit /b 1
)
echo        Key installed successfully.

echo.
echo ============================================================
echo  Setup complete!
echo  You can now run  run_demo.bat  with no password prompts.
echo ============================================================
echo.
pause
