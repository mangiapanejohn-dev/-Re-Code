# ReCode Windows 一键安装脚本
# 使用 PowerShell 运行

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  ReCode Windows 一键安装脚本" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查 Node.js
$nodeCheck = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeCheck) {
    Write-Host "❌ 未找到 Node.js，请先安装: https://nodejs.org/" -ForegroundColor Red
    Read-Host "按 Enter 退出"
    exit 1
}

Write-Host "✅ Node.js 版本: $(node --version)" -ForegroundColor Green

# 检查 npm
$npmCheck = Get-Command npm -ErrorAction SilentlyContinue
if (-not $npmCheck) {
    Write-Host "❌ 未找到 npm" -ForegroundColor Red
    Read-Host "按 Enter 退出"
    exit 1
}

Write-Host "✅ npm 版本: $(npm --version)" -ForegroundColor Green

$repoUrl = "https://github.com/mangiapanejohn-dev/-Re-Code.git"
$installDir = "$HOME\recode"

Write-Host ""
Write-Host "📦 正在克隆 ReCode 仓库..." -ForegroundColor Yellow

# 检查是否已安装
if (Test-Path $installDir) {
    Write-Host "⚠️  ReCode 已安装在 $installDir" -ForegroundColor Yellow
    $response = Read-Host "是否更新? (y/N)"
    if ($response -eq "y" -or $response -eq "Y") {
        Set-Location $installDir
        git pull
    }
} else {
    git clone $repoUrl $installDir
}

Set-Location $installDir

Write-Host "📦 安装依赖..." -ForegroundColor Yellow
npm install

# 创建全局命令
Write-Host "🔗 创建全局命令..." -ForegroundColor Yellow

# 添加到 PATH 的脚本
$scriptContent = @"
@echo off
node "$installDir\recode-temp\package\cli.js" %*
"@

$scriptPath = "$env:USERPROFILE\recode.bat"
Set-Content -Path $scriptPath -Value $scriptContent -Encoding ASCII

# 添加到 PATH（如果需要）
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$env:USERPROFILE*") {
    [Environment]::SetEnvironmentVariable("Path", "$currentPath;$env:USERPROFILE", "User")
    Write-Host "⚠️  已添加到 PATH，请重新打开终端" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  ✅ 安装完成！" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "运行以下命令启动 ReCode:" -ForegroundColor White
Write-Host "  recode" -ForegroundColor Cyan
Write-Host "  或" -ForegroundColor White
Write-Host "  node $installDir\cli.js" -ForegroundColor Cyan
Write-Host ""

Read-Host "按 Enter 退出"