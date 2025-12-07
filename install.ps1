# GPT-OSS 20B HERETIC Auto-Installer for Windows
# One-command install script with verification

$ErrorActionPreference = "Stop"
$ProgressPreference = 'SilentlyContinue'

# Configuration
$INSTALL_DIR = "$env:USERPROFILE\GPT-OSS-20B"
$MODEL_NAME = "OpenAI-20B-NEO-CODEPlus-Uncensored-Q5_1-IMAT-00001-of-00003.gguf"
$MODEL_URL = "https://huggingface.co/DavidAU/OpenAi-GPT-oss-20b-HERETIC-uncensored-NEO-Imatrix-gguf/resolve/main/$MODEL_NAME"
$LLAMA_REPO = "https://github.com/ggerganov/llama.cpp"

Write-Host "\n========================================" -ForegroundColor Cyan
Write-Host "GPT-OSS 20B HERETIC Auto-Installer" -ForegroundColor Cyan
Write-Host "========================================\n" -ForegroundColor Cyan

# Check for required tools
Write-Host "[1/6] Checking prerequisites..." -ForegroundColor Yellow

if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: Git not found. Installing Git..." -ForegroundColor Red
    winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

if (!(Get-Command cmake -ErrorAction SilentlyContinue)) {
    Write-Host "ERROR: CMake not found. Installing CMake..." -ForegroundColor Red
    winget install --id Kitware.CMake -e --source winget --accept-package-agreements --accept-source-agreements
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
}

Write-Host "Prerequisites OK!" -ForegroundColor Green

# Create installation directory
Write-Host "\n[2/6] Creating installation directory..." -ForegroundColor Yellow
if (!(Test-Path $INSTALL_DIR)) {
    New-Item -ItemType Directory -Path $INSTALL_DIR | Out-Null
}
Set-Location $INSTALL_DIR
Write-Host "Directory created: $INSTALL_DIR" -ForegroundColor Green

# Clone and build llama.cpp
Write-Host "\n[3/6] Cloning and building llama.cpp..." -ForegroundColor Yellow
if (!(Test-Path "$INSTALL_DIR\llama.cpp")) {
    git clone $LLAMA_REPO 2>&1 | Out-Null
    Set-Location "$INSTALL_DIR\llama.cpp"
    cmake -B build -DCMAKE_BUILD_TYPE=Release 2>&1 | Out-Null
    cmake --build build --config Release 2>&1 | Out-Null
    Write-Host "llama.cpp built successfully!" -ForegroundColor Green
} else {
    Write-Host "llama.cpp already exists, skipping build." -ForegroundColor Green
}

# Download model
Write-Host "\n[4/6] Downloading AI model (this may take a while)..." -ForegroundColor Yellow
Set-Location $INSTALL_DIR
if (!(Test-Path "$INSTALL_DIR\models\$MODEL_NAME")) {
    New-Item -ItemType Directory -Path "$INSTALL_DIR\models" -Force | Out-Null
    $webClient = New-Object System.Net.WebClient
    try {
        $webClient.DownloadFile($MODEL_URL, "$INSTALL_DIR\models\$MODEL_NAME")
        Write-Host "Model downloaded successfully!" -ForegroundColor Green
    } catch {
        Write-Host "ERROR: Failed to download model. Check your internet connection." -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Model already downloaded." -ForegroundColor Green
}

# Verify files
Write-Host "\n[5/6] Verifying installation..." -ForegroundColor Yellow
$llamaServer = "$INSTALL_DIR\llama.cpp\build\bin\Release\llama-server.exe"
$modelPath = "$INSTALL_DIR\models\$MODEL_NAME"

if (!(Test-Path $llamaServer)) {
    Write-Host "ERROR: llama-server.exe not found!" -ForegroundColor Red
    exit 1
}

if (!(Test-Path $modelPath)) {
    Write-Host "ERROR: Model file not found!" -ForegroundColor Red
    exit 1
}

Write-Host "All files verified!" -ForegroundColor Green

# Create launcher script
Write-Host "\n[6/6] Creating launcher..." -ForegroundColor Yellow
$launcherScript = @"
@echo off
echo Starting GPT-OSS 20B HERETIC...
cd /d "$INSTALL_DIR\llama.cpp\build\bin\Release"
start llama-server.exe -m "$modelPath" --n-ctx 8192 --temp 0.8 --repeat-penalty 1.1 --top-k 40 --top-p 0.95 --min-p 0.05 --port 8080

# Create CLI launcher script
$cliLauncherScript = @"
@echo off
echo Starting GPT-OSS 20B HERETIC (Command Line Interactive)...
cd /d "$INSTALL_DIR\llama.cpp\build\bin\Release"
llama-cli.exe -m "$modelPath" --n-ctx 8192 --temp 0.8 --repeat-penalty 1.1 --top-k 40 --top-p 0.95 --min-p 0.05 -i --interactive-first --color --reverse-prompt "User:"
pause
"@

$cliLauncherScript | Out-File -FilePath "$INSTALL_DIR\run-cli.bat" -Encoding ASCII
Write-Host "CLI launcher created: $INSTALL_DIR\run-cli.bat" -ForegroundColor Green
echo.
echo Server starting on http://localhost:8080
echo Press Ctrl+C in the server window to stop.
pause
"@

$launcherScript | Out-File -FilePath "$INSTALL_DIR\run.bat" -Encoding ASCII
Write-Host "Launcher created: $INSTALL_DIR\run.bat" -ForegroundColor Green

# Success message
Write-Host "\n========================================" -ForegroundColor Green
Write-Host "Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "\nTo start the AI model, run:" -ForegroundColor Cyan
Write-Host "  $INSTALL_DIR\run.bat" -ForegroundColor White
Write-Host "\nThe server will be available at:" -ForegroundColor Cyan
Write-Host "  http://localhost:8080" -ForegroundColor White
Write-Host "\nInstallation directory:" -ForegroundColor Cyan
Write-Host "  $INSTALL_DIR" -ForegroundColor White
Write-Host "

# Auto-start option
Write-Host "\nWould you like to start the AI model now? (Y/N): " -NoNewline -ForegroundColor Cyan
$response = Read-Host

if ($response -eq 'Y' -or $response -eq 'y') {
    Write-Host "\nStarting AI model..." -ForegroundColor Green
    Write-Host "Opening interactive chat in command line...\n" -ForegroundColor Cyan
    
    Set-Location "$INSTALL_DIR\llama.cpp\build\bin\Release"
    & .\llama-cli.exe -m "$modelPath" --n-ctx 8192 --temp 0.8 --repeat-penalty 1.1 --top-k 40 --top-p 0.95 --min-p 0.05 -i --interactive-first --color --reverse-prompt "User:"
} else {
    Write-Host "\nTo start the AI model later, run:" -ForegroundColor Cyan
    Write-Host "  $INSTALL_DIR\run.bat" -ForegroundColor White
    Write-Host "\nOr for CLI mode, run:" -ForegroundColor Cyan
    Write-Host "  $INSTALL_DIR\run-cli.bat" -ForegroundColor White
}
