# RE CODE Installer - Windows PowerShell
# Usage: iwr -useb https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.ps1 | iex
# Updated: 2026-04-04

$ErrorActionPreference = "Stop"

# Configuration
$REPO_URL = "https://github.com/mangiapanejohn-dev/-Re-Code.git"
$INSTALL_ROOT = "$env:USERPROFILE\.recode"
$SOURCE_DIR = "$INSTALL_ROOT\source"
$BIN_DIR = "$env:USERPROFILE\AppData\Local\Programs\recode"

# Colors (Purple theme)
$ACCENT = [ConsoleColor]::Magenta
$INFO = [ConsoleColor]::Cyan
$SUCCESS = [ConsoleColor]::Green
$WARN = [ConsoleColor]::Yellow
$ERROR = [ConsoleColor]::Red
$MUTED = [ConsoleColor]::DarkGray
$WHITE = [ConsoleColor]::White

function Write-Banner {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor $ACCENT
    Write-Host "║                                                                            ║" -ForegroundColor $ACCENT
    Write-Host "║  ██████╗     ███████╗      ██████╗      ██████╗     ██████╗     ███████╗   ║" -ForegroundColor $ACCENT
    Write-Host "║  ██╔══██╗    ██╔════╝     ██╔════╝     ██╔═══██╗    ██╔══██╗    ██╔════╝   ║" -ForegroundColor $ACCENT
    Write-Host "║  ██████╔╝    █████╗       ██║          ██║   ██║    ██║  ██║    █████╗     ║" -ForegroundColor $ACCENT
    Write-Host "║  ██╔══██╗    ██╔══╝       ██║          ██║   ██║    ██║  ██║    ██╔══╝     ║" -ForegroundColor $ACCENT
    Write-Host "║  ██║  ██║    ███████╗     ╚██████╗     ╚██████╔╝    ██████╔╝    ███████╗   ║" -ForegroundColor $ACCENT
    Write-Host "║  ╚═╝  ╚═╝    ╚══════╝      ╚═════╝      ╚═════╝     ╚═════╝     ╚══════╝   ║" -ForegroundColor $ACCENT
    Write-Host "║                                                                            ║" -ForegroundColor $ACCENT
    Write-Host "║      [ R ]      [ E ]      [ C ]      [ O ]      [ D ]      [ E ]          ║" -ForegroundColor $ACCENT
    Write-Host "║                                                                            ║" -ForegroundColor $ACCENT
    Write-Host "║      Heyy ~ Bro ！👾   WANT VIBE CODING KNOW ???                               ║" -ForegroundColor $ACCENT
    Write-Host "║                                                                            ║" -ForegroundColor $ACCENT
    Write-Host "║  >_ RE_CODE PROTOCOL ENGAGED // NEURAL GRID ONLINE // v3.0.1                ║" -ForegroundColor $ACCENT
    Write-Host "╚════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor $ACCENT
    Write-Host ""
    Write-Host "  Source: $SOURCE_DIR" -ForegroundColor $MUTED
    Write-Host "  Binary: $BIN_DIR\recode.exe" -ForegroundColor $MUTED
    Write-Host ""
}

function Write-Info { param([string]$Message) Write-Host "[INFO] $Message" -ForegroundColor $INFO }
function Write-Success { param([string]$Message) Write-Host "[OK] $Message" -ForegroundColor $SUCCESS }
function Write-Warn { param([string]$Message) Write-Host "[WARN] $Message" -ForegroundColor $WARN }
function Write-ErrorExit { param([string]$Message) Write-Host "[ERROR] $Message" -ForegroundColor $ERROR; exit 1 }

function Check-Requirements {
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        Write-ErrorExit "Node.js not found. Install Node.js 22+ first: https://nodejs.org"
    }
    $nodeVersion = node --version
    $majorVersion = [int]($nodeVersion -replace '^v(\d+).*', '$1')
    if ($majorVersion -lt 22) {
        Write-ErrorExit "Node.js 22+ is required. Current: $nodeVersion"
    }
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-ErrorExit "Git is required. Install from https://git-scm.com"
    }
    if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
        Write-ErrorExit "npm is required. Reinstall Node.js with npm."
    }
    Write-Success "Requirements checked (Node $nodeVersion)"
}

function Install-Source {
    if (Test-Path "$SOURCE_DIR\.git") {
        Write-Info "Updating existing RE CODE checkout..."
        Set-Location $SOURCE_DIR
        git remote set-url origin $REPO_URL 2>$null
        if (git fetch --depth 1 origin main 2>$null) {
            git checkout -q main 2>$null
            git reset --hard origin/main 2>$null
            Write-Success "Source updated"
            return
        }
    }

    if (Test-Path $SOURCE_DIR) {
        Write-Warn "Existing path at ${SOURCE_DIR}; removing and recloning."
        Remove-Item $SOURCE_DIR -Recurse -Force
    }

    Write-Info "Cloning RE CODE source..."
    git clone --depth 1 $REPO_URL $SOURCE_DIR 2>$null
    Write-Success "Source cloned"
}

function Install-Deps {
    Set-Location $SOURCE_DIR
    Write-Info "Installing dependencies..."
    npm install 2>$null
    Write-Success "Dependencies installed"
}

function Run-Build {
    Set-Location $SOURCE_DIR

    # Check if pre-built CLI exists
    if (Test-Path "$SOURCE_DIR\recode-temp\package\cli.js") {
        Write-Info "Using pre-built RE CODE CLI..."
        Write-Success "CLI ready"
        return
    }

    Write-Info "Building RE CODE CLI..."
    $buildResult = npm run build 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Build completed"
        return
    }

    Write-Warn "Build failed, checking for pre-built CLI..."
}

function Install-Launcher {
    New-Item -ItemType Directory -Force -Path $BIN_DIR | Out-Null

    $cliPath = "$SOURCE_DIR\recode-temp\package\cli.js"
    if (-not (Test-Path $cliPath)) {
        Write-ErrorExit "CLI entry not found at $cliPath"
    }

    @"
@echo off
node "$cliPath" %*
"@ | Set-Content "$BIN_DIR\recode.bat" -Encoding ASCII

    # Add to PATH if needed
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$BIN_DIR*") {
        [Environment]::SetEnvironmentVariable("Path", "$currentPath;$BIN_DIR", "User")
        Write-Warn "Added to PATH - please restart your terminal"
    }

    Write-Success "Launcher installed at $BIN_DIR\recode.bat"
}

function Print-Success {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor $ACCENT
    Write-Host "║                                                                            ║" -ForegroundColor $ACCENT
    Write-Host "║                    RE CODE INSTALLED SUCCESSFULLY！👾                         ║" -ForegroundColor $ACCENT
    Write-Host "║                                                                            ║" -ForegroundColor $ACCENT
    Write-Host "║                      NEURAL GRID ONLINE // READY                              ║" -ForegroundColor $ACCENT
    Write-Host "╚════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor $ACCENT
    Write-Host ""
    Write-Host "  Next steps:" -ForegroundColor $WHITE
    Write-Host "    1) Verify: recode -v" -ForegroundColor $MUTED
    Write-Host "    2) First launch: recode" -ForegroundColor $MUTED
    Write-Host "    3) Get help: recode --help" -ForegroundColor $MUTED
    Write-Host ""
    Write-Host "  If 'recode' is not found, restart your terminal." -ForegroundColor $MUTED
    Write-Host ""
}

# Main
Write-Banner
Check-Requirements
Install-Source
Install-Deps
Run-Build
Install-Launcher
Print-Success