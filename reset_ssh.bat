@echo off
:: ============================================================
:: reset_ssh.bat — Remove SSH key from VM's authorized_keys
::
:: Run this to remove the current machine's SSH key from the VM.
:: After this, run 1_setup_once.bat again to re-install the key.
:: ============================================================

setlocal
set VM_USER=azureuser
set VM_HOST=20.40.57.76
set KEY_FILE=%USERPROFILE%\.ssh\motor_demo_key

title Motor Demo — Reset SSH Key

echo ============================================================
echo  Motor Claims Demo — SSH Key Reset
echo ============================================================
echo.
echo This will remove the SSH key from the Azure VM.
echo You will need the VM password once during this process.
echo.
echo Press any key to continue, or Ctrl+C to cancel.
pause >nul

:: ── Step 1: Remove key from VM ────────────────────────────────────────────────
echo.
echo [1/2] Removing SSH key from VM (enter VM password when prompted)...
ssh -o StrictHostKeyChecking=accept-new %VM_USER%@%VM_HOST% "echo '' > ~/.ssh/authorized_keys"
if errorlevel 1 (
    echo [ERROR] Could not connect to VM.
    pause
    exit /b 1
)
echo        Key removed from VM.

:: ── Step 2: Delete key from this machine ─────────────────────────────────────
echo.
echo [2/2] Removing SSH key from this machine...
if exist "%KEY_FILE%" (
    del "%KEY_FILE%"
    echo        Deleted: %KEY_FILE%
) else (
    echo        No key found — skipping.
)
if exist "%KEY_FILE%.pub" (
    del "%KEY_FILE%.pub"
    echo        Deleted: %KEY_FILE%.pub
)

echo.
echo ============================================================
echo  Reset complete.
echo  Run 1_setup_once.bat to set up a fresh key.
echo ============================================================
echo.
pause
