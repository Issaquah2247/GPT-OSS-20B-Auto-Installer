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
Write-Host "

# Optional: Remove installed prerequisites
Write-Host "\n" -ForegroundColor White
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Optional: Remove Prerequisites" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host "\nDo you also want to remove the development tools that were installed?" -ForegroundColor Cyan
Write-Host "(Git, CMake, Python, Visual Studio Build Tools)" -ForegroundColor Cyan
Write-Host "\nWARNING: Only remove these if you don't use them for other projects!" -ForegroundColor Red
Write-Host "\n" -ForegroundColor White
$removeTools = Read-Host "Remove development tools? Type 'YES' to confirm"

if ($removeTools -eq 'YES') {
    Write-Host "\n[1/4] Checking and removing Git..." -ForegroundColor Yellow
    if (Get-Command git -ErrorAction SilentlyContinue) {
        winget uninstall --id Git.Git -e --silent
        Write-Host "Git uninstalled" -ForegroundColor Green
    } else {
        Write-Host "Git not found" -ForegroundColor Gray
    }
    
    Write-Host "\n[2/4] Checking and removing CMake..." -ForegroundColor Yellow
    if (Get-Command cmake -ErrorAction SilentlyContinue) {
        winget uninstall --id Kitware.CMake -e --silent
        Write-Host "CMake uninstalled" -ForegroundColor Green
    } else {
        Write-Host "CMake not found" -ForegroundColor Gray
    }
    
    Write-Host "\n[3/4] Checking and removing Python..." -ForegroundColor Yellow
    if (Get-Command python -ErrorAction SilentlyContinue) {
        winget uninstall --id Python.Python.3.11 -e --silent
        Write-Host "Python uninstalled" -ForegroundColor Green
    } else {
        Write-Host "Python not found" -ForegroundColor Gray
    }
    
    Write-Host "\n[4/4] Checking and removing Visual Studio Build Tools..." -ForegroundColor Yellow
    $vsPath = & "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vswhere.exe" -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath 2>$null
    if ($vsPath) {
        Write-Host "Uninstalling Visual Studio Build Tools (this may take a few minutes)..." -ForegroundColor Yellow
        $vsInstaller = "C:\Program Files (x86)\Microsoft Visual Studio\Installer\vs_installer.exe"
        if (Test-Path $vsInstaller) {
            Start-Process -FilePath $vsInstaller -ArgumentList 'uninstall', '--installPath', "$vsPath", '--quiet', '--norestart' -Wait
            Write-Host "Visual Studio Build Tools uninstalled" -ForegroundColor Green
        }
    } else {
        Write-Host "Visual Studio Build Tools not found" -ForegroundColor Gray
    }
    
    Write-Host "\nAll development tools removed!" -ForegroundColor Green
} else {
    Write-Host "\nDevelopment tools kept." -ForegroundColor Green
}

Write-Host "\n========================================" -ForegroundColor Green
Write-Host "Complete Uninstall Finished!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
