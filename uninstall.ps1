# GPT-OSS 20B HERETIC Uninstaller for Windows
# One-command uninstall script

$ErrorActionPreference = "Stop"

$INSTALL_DIR = "$env:USERPROFILE\GPT-OSS-20B"

Write-Host "\n========================================" -ForegroundColor Red
Write-Host "GPT-OSS 20B HERETIC Uninstaller" -ForegroundColor Red
Write-Host "========================================\n" -ForegroundColor Red

# Check if installation exists
if (!(Test-Path $INSTALL_DIR)) {
    Write-Host "ERROR: Installation directory not found at $INSTALL_DIR" -ForegroundColor Yellow
    Write-Host "Nothing to uninstall." -ForegroundColor Yellow
    exit 0
}

Write-Host "Installation found at: $INSTALL_DIR" -ForegroundColor Yellow
Write-Host "\nThis will permanently delete:" -ForegroundColor Yellow
Write-Host "  - All downloaded models" -ForegroundColor White
Write-Host "  - llama.cpp installation" -ForegroundColor White
Write-Host "  - All configuration files" -ForegroundColor White
Write-Host "  - Launcher scripts" -ForegroundColor White
Write-Host "\n" -ForegroundColor White

$confirmation = Read-Host "Are you sure you want to uninstall? Type 'YES' to confirm"

if ($confirmation -ne 'YES') {
    Write-Host "\nUninstall cancelled." -ForegroundColor Green
    exit 0
}

Write-Host "\n[1/3] Stopping any running processes..." -ForegroundColor Yellow
try {
    Get-Process llama-server -ErrorAction SilentlyContinue | Stop-Process -Force
    Write-Host "Stopped llama-server process" -ForegroundColor Green
} catch {
    Write-Host "No running processes found" -ForegroundColor Green
}

Write-Host "\n[2/3] Removing installation directory..." -ForegroundColor Yellow
try {
    Remove-Item -Path $INSTALL_DIR -Recurse -Force
    Write-Host "Deleted: $INSTALL_DIR" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Failed to delete installation directory" -ForegroundColor Red
    Write-Host "You may need to manually delete: $INSTALL_DIR" -ForegroundColor Red
    exit 1
}

Write-Host "\n[3/3] Verifying removal..." -ForegroundColor Yellow
if (Test-Path $INSTALL_DIR) {
    Write-Host "WARNING: Directory still exists. Manual deletion may be required." -ForegroundColor Yellow
} else {
    Write-Host "All files removed successfully!" -ForegroundColor Green
}

Write-Host "\n========================================" -ForegroundColor Green
Write-Host "Uninstall Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "\nGPT-OSS 20B HERETIC has been removed from your system." -ForegroundColor White
Write-Host ""
