# RE CODE Installer - Windows PowerShell
# Usage: iwr -useb https://cdn.jsdelivr.net/gh/mangiapanejohn-dev/-Re-Code/install.ps1 | iex
# Or:    iwr -useb https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.ps1 | iex
# Updated: 2026-04-07

# Use try/catch instead of ErrorActionPreference to avoid read-only variable issues

function Get-Banner {
    return @"

╔════════════════════════════════════════════════════════════════════════════╗
║                                                                            ║
║  ██████╗     ███████╗      ██████╗      ██████╗     ██████╗     ███████╗   ║
║  ██╔══██╗    ██╔════╝     ██╔════╝     ██╔═══██╗    ██╔══██╗    ██╔════╝   ║
║  ██████╔╝    █████╗       ██║          ██║   ██║    ██║  ██║    █████╗     ║
║  ██╔══██╗    ██╔══╝       ██║          ██║   ██║    ██║  ██║    ██╔══╝     ║
║  ██║  ██║    ███████╗     ╚██████╗     ╚██████╔╝    ██████╔╝    ███████╗   ║
║  ╚═╝  ╚═╝    ╚══════╝      ╚═════╝      ╚═════╝     ╚═════╝     ╚══════╝   ║
║                                                                            ║
║      [ R ]      [ E ]      [ C ]      [ O ]      [ D ]      [ E ]          ║
║                                                                            ║
║      Heyy ~ Bro  WANT VIBE CODING KNOW ???                                ║
║                                                                            ║
║  >_ RE_CODE PROTOCOL ENGAGED  NEURAL GRID ONLINE // v3.0.2                ║
╚════════════════════════════════════════════════════════════════════════════╝

"@
}

function Write-Step($Number, $Title) {
    Write-Host ""
    Write-Host ("━━━ " + $Title + " ━━━") -ForegroundColor Magenta
}

function Write-Info($Message) { Write-Host "  -> $Message" -ForegroundColor Cyan }
function Write-Success($Message) { Write-Host "  [OK] $Message" -ForegroundColor Green }
function Write-Warn($Message) { Write-Host "  [WARN] $Message" -ForegroundColor Yellow }
function Write-Err($Message) {
    Write-Host ""
    Write-Host "╭───────────────────────────────────────╮" -ForegroundColor Red
    Write-Host "│ [ERROR] $Message" -ForegroundColor Red
    Write-Host "╰───────────────────────────────────────╯" -ForegroundColor Red
    exit 1
}

function Show-Progress($Current, $Total) {
    $width = 30
    $percent = [math]::Floor(($Current / $Total) * 100)
    $filled = [math]::Floor(($Current / $Total) * $width)
    $empty = $width - $filled
    $bar = ("█" * $filled) + ("░" * $empty)
    Write-Host "`r  [$bar] $percent%" -NoNewline -ForegroundColor Cyan
}

# Configuration
$repoUrl = "https://github.com/mangiapanejohn-dev/-Re-Code.git"
$installRoot = Join-Path $env:USERPROFILE ".recode"
$sourceDir = Join-Path $installRoot "source"
$binDir = Join-Path $env:LOCALAPPDATA "Programs\recode"

# Colors
$accent = [ConsoleColor]::Magenta
$cyan = [ConsoleColor]::Cyan
$green = [ConsoleColor]::Green
$yellow = [ConsoleColor]::Yellow
$white = [ConsoleColor]::White
$muted = [ConsoleColor]::DarkGray

# Banner
Write-Host ""
Write-Host (Get-Banner) -ForegroundColor $accent

Write-Host ""
Write-Host "Installation steps:" -ForegroundColor DarkGray
Write-Host "  1) Check requirements"
Write-Host "  2) Clone/Update source"
Write-Host "  3) Install dependencies"
Write-Host "  4) Build CLI"
Write-Host "  5) Install launcher"
Write-Host ""

# Step 1: Check Requirements
Write-Step 1 "Checking Requirements"

try {
    Write-Host "  [Checking Node.js...]" -ForegroundColor DarkGray -NoNewline
    $nodeCmd = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodeCmd) { throw "Node.js not found. Install from https://nodejs.org" }
    $nodeVersion = node --version
    $majorVersion = [int]($nodeVersion -replace '^v(\d+).*', '$1')
    if ($majorVersion -lt 22) { throw "Node.js 22+ required, current: $nodeVersion" }
    Write-Host " [OK]" -ForegroundColor Green

    Write-Host "  [Checking Git...]" -ForegroundColor DarkGray -NoNewline
    $gitCmd = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitCmd) { throw "Git not found. Install from https://git-scm.com" }
    $gitVersion = git --version
    Write-Host " [OK]" -ForegroundColor Green

    Write-Host "  [Checking npm...]" -ForegroundColor DarkGray -NoNewline
    $npmCmd = Get-Command npm -ErrorAction SilentlyContinue
    if (-not $npmCmd) { throw "npm not found" }
    $npmVersion = npm -v
    Write-Host " [OK]" -ForegroundColor Green

    Write-Success "All requirements met!"
} catch {
    Write-Err $_.Exception.Message
}

# Step 2: Install/Update Source
Write-Step 2 "Cloning/Updating Source"

try {
    $gitDir = Join-Path $sourceDir ".git"
    if (Test-Path $gitDir) {
        Write-Info "Updating existing RE CODE checkout..."
        Push-Location $sourceDir -ErrorAction Stop
        try {
            git remote set-url origin $repoUrl 2>$null
            $fetch = git fetch --depth 1 origin main 2>$null
            if ($?) {
                git checkout -q main 2>$null
                git reset --hard origin/main 2>$null
                Write-Success "Source updated to latest"
                return
            }
        } finally {
            Pop-Location
        }
    }

    if (Test-Path $sourceDir) {
        Write-Warn "Removing existing path for fresh install..."
        Remove-Item $sourceDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Info "Cloning RE CODE from GitHub..."
    mkdir (Split-Path $sourceDir) -Force -ErrorAction SilentlyContinue | Out-Null
    git clone --depth 1 $repoUrl $sourceDir 2>$null
    if ($LASTEXITCODE -ne 0) { throw "Git clone failed" }
    Write-Success "Source cloned successfully"
} catch {
    Write-Err $_.Exception.Message
}

# Step 3: Install Dependencies
Write-Step 3 "Installing Dependencies"

try {
    Push-Location $sourceDir -ErrorAction Stop
    try {
        Write-Info "Running npm install..."
        npm install 2>$null
        if ($LASTEXITCODE -ne 0) { throw "npm install failed" }
        Write-Success "Dependencies installed"
    } finally {
        Pop-Location
    }
} catch {
    Write-Err $_.Exception.Message
}

# Step 4: Build/Check CLI
Write-Step 4 "Building CLI"

try {
    Push-Location $sourceDir -ErrorAction Stop
    try {
        $cliPath = Join-Path $sourceDir "recode-temp\package\cli.js"
        if (Test-Path $cliPath) {
            Write-Info "Using pre-built RE CODE CLI..."
            Write-Success "CLI ready"
        } else {
            Write-Info "Building RE CODE CLI..."
            npm run build 2>$null
            if ($LASTEXITCODE -eq 0) {
                Write-Success "Build completed"
            } else {
                Write-Warn "Build failed, checking for pre-built..."
            }
        }
    } finally {
        Pop-Location
    }
} catch {
    Write-Warn "Build check skipped"
}

# Step 5: Install Launcher
Write-Step 5 "Installing Launcher"

try {
    New-Item -ItemType Directory -Force -Path $binDir | Out-Null

    $cliPath = Join-Path $sourceDir "recode-temp\package\cli.js"
    if (-not (Test-Path $cliPath)) {
        Write-Err "CLI not found at $cliPath"
    }

    Write-Info "Creating launcher script..."
    $batContent = "@echo off`nnode `"$cliPath`" %*"
    $batPath = Join-Path $binDir "re-code.bat"
    Set-Content $batPath $batContent -Encoding ASCII

    Write-Info "Updating PATH..."
    try {
        $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($userPath -notlike "*$binDir*") {
            [Environment]::SetEnvironmentVariable("Path", "$userPath;$binDir", "User")
            Write-Warn "PATH updated - restart terminal to use re-code"
        }
    } catch {
        Write-Warn "Could not auto-update PATH"
    }

    Write-Success "Launcher installed at $binDir\re-code.bat"
} catch {
    Write-Err $_.Exception.Message
}

# Success
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor $accent
Write-Host "║                                                                            ║" -ForegroundColor $accent
Write-Host "║      RE CODE INSTALLED SUCCESSFULLY                                        ║" -ForegroundColor Green
Write-Host "║                                                                            ║" -ForegroundColor $accent
Write-Host "║       NEURAL GRID ONLINE // READY                                        ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor $accent
Write-Host ""
Write-Host "Next steps:" -ForegroundColor White
Write-Host "  -> Verify:   re-code -v" -ForegroundColor $muted
Write-Host "  -> Launch:   re-code" -ForegroundColor $muted
Write-Host "  -> Help:     re-code --help" -ForegroundColor $muted
Write-Host ""
Write-Host "If 're-code' not found, restart your terminal." -ForegroundColor $muted
Write-Host ""