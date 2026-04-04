#!/bin/bash
# ReCode Termux 一键安装脚本

set -e

echo "========================================"
echo "  ReCode Termux 安装脚本"
echo "========================================"

# 检查是否为 Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo "⚠️  检测到可能不在 Termux 环境中"
    echo "是否继续? (y/N)"
    read -r -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

echo "📦 更新软件包..."
apt update && apt upgrade -y

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "📦 安装 Node.js..."
    apt install -y nodejs
fi

echo "✅ Node.js 版本: $(node --version)"

# 检查 git
if ! command -v git &> /dev/null; then
    echo "📦 安装 Git..."
    apt install -y git
fi

echo "✅ Git 版本: $(git --version)"

# 安装
REPO_URL="https://github.com/mangiapanejohn-dev/-Re-Code.git"
INSTALL_DIR="$HOME/recode"

echo ""
echo "📦 克隆 ReCode 仓库..."

if [ -d "$INSTALL_DIR" ]; then
    cd "$INSTALL_DIR"
    git pull
else
    git clone "$REPO_URL" "$INSTALL_DIR"
    cd "$INSTALL_DIR"
fi

echo "📦 安装依赖..."
npm install

# 创建启动脚本
echo "🔗 创建启动命令..."

# 创建 bin 目录（如果不存在）
mkdir -p "$HOME/.local/bin"

# 创建 recode 命令
cat > "$HOME/.local/bin/recode" << 'EOF'
#!/data/data/com.termux/files/home/recode/recode-temp/package/cli.js
EOF

# 使其可执行
chmod +x "$HOME/.local/bin/recode"

# 添加到 PATH（如果还没有）
BASHRC="$HOME/.bashrc"
if [ -f "$BASHRC" ]; then
    if ! grep -q ".local/bin" "$BASHrc"; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$BASHRC"
    fi
fi

echo ""
echo "========================================"
echo "  ✅ 安装完成！"
echo "========================================"
echo ""
echo "运行以下命令启动 ReCode:"
echo "  source ~/.bashrc  # 刷新环境"
echo "  recode"
echo ""
echo "或直接运行:"
echo "  node $INSTALL_DIR/cli.js"
echo ""