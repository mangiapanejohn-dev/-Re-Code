# RE CODE Installer - Windows PowerShell
# Usage: iwr -useb https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.ps1 | iex
# Updated: 2026-04-04

# Configuration - use script scope to avoid read-only variable issues
$script:REPO_URL = "https://github.com/mangiapanejohn-dev/-Re-Code.git"
$script:INSTALL_ROOT = Join-Path $env:USERPROFILE ".recode"
$script:SOURCE_DIR = Join-Path $script:INSTALL_ROOT "source"
$script:BIN_DIR = Join-Path $env:LOCALAPPDATA "Programs\recode"

# Colors (Purple theme)
$script:ACCENT = [ConsoleColor]::Magenta
$script:INFO = [ConsoleColor]::Cyan
$script:SUCCESS = [ConsoleColor]::Green
$script:WARN = [ConsoleColor]::Yellow
$script:ERROR = [ConsoleColor]::Red
$script:MUTED = [ConsoleColor]::DarkGray
$script:WHITE = [ConsoleColor]::White

function Write-Banner {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor $script:ACCENT
    Write-Host "║                                                                            ║" -ForegroundColor $script:ACCENT
    Write-Host "║  ██████╗     ███████╗      ██████╗      ██████╗     ██████╗     ███████╗   ║" -ForegroundColor $script:ACCENT
    Write-Host "║  ██╔══██╗    ██╔════╝     ██╔════╝     ██╔═══██╗    ██╔══██╗    ██╔════╝   ║" -ForegroundColor $script:ACCENT
    Write-Host "║  ██████╔╝    █████╗       ██║          ██║   ██║    ██║  ██║    █████╗     ║" -ForegroundColor $script:ACCENT
    Write-Host "║  ██╔══██╗    ██╔══╝       ██║          ██║   ██║    ██║  ██║    ██╔══╝     ║" -ForegroundColor $script:ACCENT
    Write-Host "║  ██║  ██║    ███████╗     ╚██████╗     ╚██████╔╝    ██████╔╝    ███████╗   ║" -ForegroundColor $script:ACCENT
    Write-Host "║  ╚═╝  ╚═╝    ╚══════╝      ╚═════╝      ╚═════╝     ╚═════╝     ╚══════╝   ║" -ForegroundColor $script:ACCENT
    Write-Host "║                                                                            ║" -ForegroundColor $script:ACCENT
    Write-Host "║      [ R ]      [ E ]      [ C ]      [ O ]      [ D ]      [ E ]          ║" -ForegroundColor $script:ACCENT
    Write-Host "║                                                                            ║" -ForegroundColor $script:ACCENT
    Write-Host "║      Heyy ~ Bro ！👾   WANT VIBE CODING KNOW ???                               ║" -ForegroundColor $script:ACCENT
    Write-Host "║                                                                            ║" -ForegroundColor $script:ACCENT
    Write-Host "║  >_ RE_CODE PROTOCOL ENGAGED // NEURAL GRID ONLINE // v3.0.1                ║" -ForegroundColor $script:ACCENT
    Write-Host "╚════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor $script:ACCENT
    Write-Host ""
    Write-Host "  Source: $script:SOURCE_DIR" -ForegroundColor $script:MUTED
    Write-Host "  Binary: $script:BIN_DIR\recode.exe" -ForegroundColor $script:MUTED
    Write-Host ""
}

function Write-Info { param([string]$Message) Write-Host "[INFO] $Message" -ForegroundColor $script:INFO }
function Write-Success { param([string]$Message) Write-Host "[OK] $Message" -ForegroundColor $script:SUCCESS }
function Write-Warn { param([string]$Message) Write-Host "[WARN] $Message" -ForegroundColor $script:WARN }
function Write-ErrorExit { param([string]$Message) Write-Host "[ERROR] $Message" -ForegroundColor $script:ERROR; exit 1 }

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
    if (Test-Path (Join-Path $script:SOURCE_DIR ".git")) {
        Write-Info "Updating existing RE CODE checkout..."
        Push-Location $script:SOURCE_DIR
        try {
            git remote set-url origin $script:REPO_URL 2>$null
            if (git fetch --depth 1 origin main 2>$null) {
                git checkout -q main 2>$null
                git reset --hard origin/main 2>$null
                Write-Success "Source updated"
                return
            }
        } finally {
            Pop-Location
        }
    }

    if (Test-Path $script:SOURCE_DIR) {
        Write-Warn "Existing path at $script:SOURCE_DIR; removing and recloning."
        Remove-Item $script:SOURCE_DIR -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Info "Cloning RE CODE source..."
    git clone --depth 1 $script:REPO_URL $script:SOURCE_DIR 2>$null
    Write-Success "Source cloned"
}

function Install-Deps {
    Push-Location $script:SOURCE_DIR
    try {
        Write-Info "Installing dependencies..."
        npm install 2>$null
        Write-Success "Dependencies installed"
    } finally {
        Pop-Location
    }
}

function Run-Build {
    Push-Location $script:SOURCE_DIR
    try {
        # Check if pre-built CLI exists
        if (Test-Path (Join-Path $script:SOURCE_DIR "recode-temp\package\cli.js")) {
            Write-Info "Using pre-built RE CODE CLI..."
            Write-Success "CLI ready"
            return
        }

        Write-Info "Building RE CODE CLI..."
        npm run build 2>$null
        if ($LASTEXITCODE -eq 0) {
            Write-Success "Build completed"
            return
        }

        Write-Warn "Build failed, checking for pre-built CLI..."
    } finally {
        Pop-Location
    }
}

function Install-Launcher {
    New-Item -ItemType Directory -Force -Path $script:BIN_DIR | Out-Null

    $cliPath = Join-Path $script:SOURCE_DIR "recode-temp\package\cli.js"
    if (-not (Test-Path $cliPath)) {
        Write-ErrorExit "CLI entry not found at $cliPath"
    }

    @"
@echo off
node "$cliPath" %*
"@ | Set-Content (Join-Path $script:BIN_DIR "recode.bat") -Encoding ASCII

    # Add to PATH if needed - use current user scope
    try {
        $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($currentPath -notlike "*$($script:BIN_DIR)*") {
            [Environment]::SetEnvironmentVariable("Path", "$currentPath;$($script:BIN_DIR)", "User")
            Write-Warn "Added to PATH - please restart your terminal"
        }
    } catch {
        Write-Warn "Could not update PATH automatically"
    }

    Write-Success "Launcher installed at $script:BIN_DIR\recode.bat"
}

function Print-Success {
    Write-Host ""
    Write-Host "╔════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor $script:ACCENT
    Write-Host "║                                                                            ║" -ForegroundColor $script:ACCENT
    Write-Host "║                    RE CODE INSTALLED SUCCESSFULLY！👾                         ║" -ForegroundColor $script:ACCENT
    Write-Host "║                                                                            ║" -ForegroundColor $script:ACCENT
    Write-Host "║                      NEURAL GRID ONLINE // READY                              ║" -ForegroundColor $script:ACCENT
    Write-Host "╚════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor $script:ACCENT
    Write-Host ""
    Write-Host "  Next steps:" -ForegroundColor $script:WHITE
    Write-Host "    1) Verify: recode -v" -ForegroundColor $script:MUTED
    Write-Host "    2) First launch: recode" -ForegroundColor $script:MUTED
    Write-Host "    3) Get help: recode --help" -ForegroundColor $script:MUTED
    Write-Host ""
    Write-Host "  If 'recode' is not found, restart your terminal." -ForegroundColor $script:MUTED
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
