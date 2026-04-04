#!/bin/bash
# ReCode 一键安装脚本
# 支持 macOS / Linux

set -e

echo "========================================"
echo "  ReCode 一键安装脚本"
echo "========================================"

# 检查 Node.js
if ! command -v node &> /dev/null; then
    echo "❌ 未找到 Node.js，请先安装: https://nodejs.org/"
    exit 1
fi

echo "✅ Node.js 版本: $(node --version)"

# 检查 npm
if ! command -v npm &> /dev/null; then
    echo "❌ 未找到 npm"
    exit 1
fi

echo "✅ npm 版本: $(npm --version)"

# 获取脚本所在目录
REPO_URL="https://github.com/mangiapanejohn-dev/-Re-Code.git"
INSTALL_DIR="$HOME/recode"

echo ""
echo "📦 正在克隆 ReCode 仓库..."

# 如果目录已存在，询问是否更新
if [ -d "$INSTALL_DIR" ]; then
    echo "⚠️  ReCode 已安装在 $INSTALL_DIR"
    read -p "是否更新? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd "$INSTALL_DIR"
        git pull
    fi
else
    git clone "$REPO_URL" "$INSTALL_DIR"
fi

cd "$INSTALL_DIR"

echo "📦 安装依赖..."
npm install

# 创建全局命令链接
echo "🔗 创建全局命令..."
if [ -L "/usr/local/bin/recode" ]; then
    rm /usr/local/bin/recode
fi
ln -s "$INSTALL_DIR/recode-temp/package/cli.js" /usr/local/bin/recode

echo ""
echo "========================================"
echo "  ✅ 安装完成！"
echo "========================================"
echo ""
echo "运行以下命令启动 ReCode:"
echo "  recode"
echo ""
echo "或直接运行:"
echo "  node $INSTALL_DIR/cli.js"
echo ""