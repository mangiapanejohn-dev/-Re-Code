# RE CODE Installer - Windows PowerShell
# Usage: iwr -useb https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.ps1 | iex
# Updated: 2026-04-04

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
║      Heyy ~ Bro ！👾   WANT VIBE CODING KNOW ???                               ║
║                                                                            ║
║  >_ RE_CODE PROTOCOL ENGAGED // NEURAL GRID ONLINE // v3.0.1                ║
╚════════════════════════════════════════════════════════════════════════════╝

"@
}

function Write-Info($Message) { Write-Host "[INFO] $Message" -ForegroundColor Cyan }
function Write-Success($Message) { Write-Host "[OK] $Message" -ForegroundColor Green }
function Write-Warn($Message) { Write-Host "[WARN] $Message" -ForegroundColor Yellow }
function Write-Err($Message) { Write-Host "[ERROR] $Message" -ForegroundColor Red; exit 1 }

# Configuration
$repoUrl = "https://github.com/mangiapanejohn-dev/-Re-Code.git"
$installRoot = Join-Path $env:USERPROFILE ".recode"
$sourceDir = Join-Path $installRoot "source"
$binDir = Join-Path $env:LOCALAPPDATA "Programs\recode"

# Colors
$accent = [ConsoleColor]::Magenta
$muted = [ConsoleColor]::DarkGray
$white = [ConsoleColor]::White

# Banner
Write-Host (Get-Banner) -ForegroundColor $accent
Write-Host "  Source: $sourceDir" -ForegroundColor $muted
Write-Host "  Binary: $binDir\recode.exe" -ForegroundColor $muted
Write-Host ""

# Check Requirements
try {
    $nodeCmd = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodeCmd) { throw "Node.js not found" }
    $nodeVersion = node --version
    $majorVersion = [int]($nodeVersion -replace '^v(\d+).*', '$1')
    if ($majorVersion -lt 22) { throw "Node.js 22+ required, current: $nodeVersion" }
    $gitCmd = Get-Command git -ErrorAction SilentlyContinue
    if (-not $gitCmd) { throw "Git not found" }
    $npmCmd = Get-Command npm -ErrorAction SilentlyContinue
    if (-not $npmCmd) { throw "npm not found" }
    Write-Success "Requirements checked (Node $nodeVersion)"
} catch {
    Write-Err $_.Exception.Message
}

# Install Source
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
                Write-Success "Source updated"
                return
            }
        } finally {
            Pop-Location
        }
    }

    if (Test-Path $sourceDir) {
        Write-Warn "Removing existing path..."
        Remove-Item $sourceDir -Recurse -Force -ErrorAction SilentlyContinue
    }

    Write-Info "Cloning RE CODE source..."
    mkdir (Split-Path $sourceDir) -Force -ErrorAction SilentlyContinue | Out-Null
    git clone --depth 1 $repoUrl $sourceDir 2>$null
    if ($LASTEXITCODE -ne 0) { throw "Git clone failed" }
    Write-Success "Source cloned"
} catch {
    Write-Err $_.Exception.Message
}

# Install Deps
try {
    Push-Location $sourceDir -ErrorAction Stop
    try {
        Write-Info "Installing dependencies..."
        npm install 2>$null
        if ($LASTEXITCODE -ne 0) { throw "npm install failed" }
        Write-Success "Dependencies installed"
    } finally {
        Pop-Location
    }
} catch {
    Write-Err $_.Exception.Message
}

# Check Build
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
                Write-Warn "Build failed"
            }
        }
    } finally {
        Pop-Location
    }
} catch {
    Write-Warn "Build check failed"
}

# Install Launcher
try {
    New-Item -ItemType Directory -Force -Path $binDir | Out-Null
    $cliPath = Join-Path $sourceDir "recode-temp\package\cli.js"
    if (-not (Test-Path $cliPath)) {
        Write-Err "CLI not found at $cliPath"
    }

    $batContent = "@echo off`nnode `"$cliPath`" %*"
    $batPath = Join-Path $binDir "recode.bat"
    Set-Content $batPath $batContent -Encoding ASCII

    try {
        $userPath = [Environment]::GetEnvironmentVariable("Path", "User")
        if ($userPath -notlike "*$binDir*") {
            [Environment]::SetEnvironmentVariable("Path", "$userPath;$binDir", "User")
            Write-Warn "Added to PATH - restart terminal"
        }
    } catch {
        Write-Warn "Could not update PATH"
    }

    Write-Success "Launcher installed"
} catch {
    Write-Err $_.Exception.Message
}

# Success
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor $accent
Write-Host "║                    RE CODE INSTALLED SUCCESSFULLY！👾                         ║" -ForegroundColor $accent
Write-Host "║                                                                            ║" -ForegroundColor $accent
Write-Host "║                      NEURAL GRID ONLINE // READY                              ║" -ForegroundColor $accent
Write-Host "╚════════════════════════════════════════════════════════════════════════════╝" -ForegroundColor $accent
Write-Host ""
Write-Host "  Next steps:" -ForegroundColor $white
Write-Host "    1) Verify: recode -v" -ForegroundColor $muted
Write-Host "    2) First launch: recode" -ForegroundColor $muted
Write-Host "  If 'recode' not found, restart terminal." -ForegroundColor $muted
Write-Host ""
