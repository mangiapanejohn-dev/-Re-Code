# ReCode Beautiful Installer - Windows PowerShell
# Purple/Pink Theme

Write-Host ""
Write-Host "     █████╗ ██╗      ██████╗  ██████╗ ██████╗ ██╗    ██╗ █████╗ ██████╗ ████████╗" -ForegroundColor Magenta
Write-Host "    ██╔══██╗██║     ██╔═══██╗██╔═══██╗██╔══██╗██║    ██║██╔══██╗██╔══██╗╚══██╔══╝" -ForegroundColor Magenta
Write-Host "    ███████║██║     ██║   ██║██║   ██║██████╔╝██║ █╗ ██║███████║██████╔╝   ██║   " -ForegroundColor Magenta
Write-Host "    ██╔══██║██║     ██║   ██║██║   ██║██╔══██╗██║███╗██║██╔══██║██╔══██╗   ██║   " -ForegroundColor Magenta
Write-Host "    ██║  ██║███████╗╚██████╔╝╚██████╔╝██║  ██║╚███╔███╔╝██║  ██║██║  ██║   ██║   " -ForegroundColor Magenta
Write-Host "    ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚══╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   " -ForegroundColor Magenta
Write-Host ""
Write-Host "         ───  Multi-Model AI Chat Interface  ───" -ForegroundColor Pink
Write-Host "                      v3.0.1" -ForegroundColor Gray
Write-Host ""

# ════════════════════════════════════════════════════════════════════════════
# Configuration
# ════════════════════════════════════════════════════════════════════════════

$REPO_URL = "https://github.com/mangiapanejohn-dev/-Re-Code.git"
$INSTALL_DIR = "$env:USERPROFILE\recode"

function Write-Step {
    param([string]$Message)
    Write-Host "▸ $Message" -ForegroundColor Magenta
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Info {
    param([string]$Message)
    Write-Host "  $Message" -ForegroundColor White
}

function Draw-Box {
    param([string]$Title)
    $width = 60
    $padding = [Math]::Floor(($width - $Title.Length) / 2)
    Write-Host ""
    Write-Host ("=" * $width) -ForegroundColor Magenta
    Write-Host (" " * $padding) -NoNewline
    Write-Host $Title -ForegroundColor Pink
    Write-Host ("=" * $width) -ForegroundColor Magenta
    Write-Host ""
}

# ════════════════════════════════════════════════════════════════════════════
# Check Requirements
# ════════════════════════════════════════════════════════════════════════════

Write-Step "Checking Node.js..."
$nodeCheck = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeCheck) {
    Write-Host "✗ Node.js not found" -ForegroundColor Red
    Write-Host "  Please install from: https://nodejs.org/" -ForegroundColor Gray
    exit 1
}
Write-Success "Node.js: $(node --version)"

Write-Step "Checking npm..."
$npmCheck = Get-Command npm -ErrorAction SilentlyContinue
if (-not $npmCheck) {
    Write-Host "✗ npm not found" -ForegroundColor Red
    exit 1
}
Write-Success "npm: $(npm --version)"

Write-Step "Preparing installation..."

# ════════════════════════════════════════════════════════════════════════════
# Clone or Update
# ════════════════════════════════════════════════════════════════════════════

if (Test-Path $INSTALL_DIR) {
    Draw-Box "UPDATE MODE"
    Write-Host "⚠ ReCode already installed at $INSTALL_DIR" -ForegroundColor Yellow
    $response = Read-Host "  Update to latest version? (Y/n)"
    if ($response -eq "n" -or $response -eq "N") {
        Write-Host "  Skipping update..." -ForegroundColor Gray
    } else {
        Write-Step "Updating ReCode..."
        Set-Location $INSTALL_DIR
        git pull 2>$null
    }
} else {
    Draw-Box "FRESH INSTALL"
    Write-Step "Cloning repository..."
    git clone $REPO_URL $INSTALL_DIR 2>$null
    Write-Success "Repository cloned"
}

Set-Location $INSTALL_DIR

# ════════════════════════════════════════════════════════════════════════════
# Install Dependencies
# ════════════════════════════════════════════════════════════════════════════

Write-Step "Installing dependencies..."
npm install --silent 2>$null
Write-Success "Dependencies installed"

# ════════════════════════════════════════════════════════════════════════════
# Create Global Command
# ════════════════════════════════════════════════════════════════════════════

Write-Step "Creating global command..."

# Create batch file in User PATH
$batchContent = "@echo off`nnode `"$INSTALL_DIR\recode-temp\package\cli.js`" %*"
$batchPath = "$env:USERPROFILE\recode.bat"
Set-Content -Path $batchPath -Value $batchContent -Encoding ASCII

# Add to PATH if needed
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$env:USERPROFILE*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$env:USERPROFILE", "User")
    Write-Host "⚠ Added to PATH - please restart your terminal" -ForegroundColor Yellow
}

Write-Success "Command 'recode' created"

# ════════════════════════════════════════════════════════════════════════════
# Complete
# ════════════════════════════════════════════════════════════════════════════

Draw-Box "INSTALLATION COMPLETE!"

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Pink
Write-Host ""
Write-Host "  Run ReCode:" -ForegroundColor White -Bold
Write-Host "    recode" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Direct run:" -ForegroundColor White
Write-Host "    node $INSTALL_DIR\cli.js" -ForegroundColor Gray
Write-Host ""
Write-Host "  Get help:" -ForegroundColor White
Write-Host "    recode --help" -ForegroundColor Gray
Write-Host ""
Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Pink
Write-Host ""
Write-Host "  Thank you for installing ReCode!" -ForegroundColor Gray
Write-Host ""