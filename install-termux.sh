#!/bin/bash
# ReCode Beautiful Installer - Termux (Purple/Pink Theme)

set -e

# ════════════════════════════════════════════════════════════════════════════
# COLOR CONFIGURATION
# ════════════════════════════════════════════════════════════════════════════

PURPLE='\033[38;2;147;112;219m'
PINK='\033[38;2;255;105;180m'
MAGENTA='\033[38;2;255;0;255m'
CYAN='\033[38;2;0;255;255m'
WHITE='\033[97m'
GRAY='\033[90m'
GREEN='\033[92m'
RED='\033[91m'
YELLOW='\033[93m'
BOLD='\033[1m'
RESET='\033[0m'

# ════════════════════════════════════════════════════════════════════════════
# ASCII ART BANNER
# ════════════════════════════════════════════════════════════════════════════

echo -e "${PURPLE}"
cat << 'EOF'
     █████╗ ██╗      ██████╗  ██████╗ ██████╗ ██╗    ██╗ █████╗ ██████╗ ████████╗
    ██╔══██╗██║     ██╔═══██╗██╔═══██╗██╔══██╗██║    ██║██╔══██╗██╔══██╗╚══██╔══╝
    ███████║██║     ██║   ██║██║   ██║██████╔╝██║ █╗ ██║███████║██████╔╝   ██║
    ██╔══██║██║     ██║   ██║██║   ██║██╔══██╗██║███╗██║██╔══██║██╔══██╗   ██║
    ██║  ██║███████╗╚██████╔╝╚██████╔╝██║  ██║╚███╔███╔╝██║  ██║██║  ██║   ██║
    ╚═╝  ╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝  ╚═╝ ╚══╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝
EOF
echo -e "${RESET}"
echo -e "${PINK}         ───  Multi-Model AI Chat Interface  ───${RESET}"
echo -e "${GRAY}                      v3.0.1${RESET}"
echo ""

# ════════════════════════════════════════════════════════════════════════════
# Configuration
# ════════════════════════════════════════════════════════════════════════════

REPO_URL="https://github.com/mangiapanejohn-dev/-Re-Code.git"
INSTALL_DIR="$HOME/recode"

echo -e "${PURPLE}▸ Checking environment...${RESET}"

# Check if running in Termux
if [ ! -d "/data/data/com.termux" ]; then
    echo -e "${YELLOW}⚠ Not running in Termux - continuing anyway${RESET}"
fi

# Update packages
echo -e "${PURPLE}▸ Updating packages...${RESET}"
apt update -qq && apt upgrade -y -qq 2>/dev/null
echo -e "${GREEN}✓ Packages updated${RESET}"

# Install Node.js if needed
if ! command -v node &> /dev/null; then
    echo -e "${PURPLE}▸ Installing Node.js...${RESET}"
    apt install -y nodejs 2>/dev/null
fi
echo -e "${GREEN}✓ Node.js: $(node --version)${RESET}"

# Install Git if needed
if ! command -v git &> /dev/null; then
    echo -e "${PURPLE}▸ Installing Git...${RESET}"
    apt install -y git 2>/dev/null
fi
echo -e "${GREEN}✓ Git: $(git --version)${RESET}"

echo ""
echo -e "${PURPLE}▸ Preparing installation...${RESET}"

# Clone or Update
if [ -d "$INSTALL_DIR" ]; then
    echo -e "${YELLOW}⚠ ReCode already installed${RESET}"
    read -p "  Update to latest version? (Y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        echo -e "${GRAY}  Skipping update...${RESET}"
    else
        echo -e "${PURPLE}▸ Updating ReCode...${RESET}"
        cd "$INSTALL_DIR" && git pull 2>/dev/null
        echo -e "${GREEN}✓ Updated${RESET}"
    fi
else
    echo -e "${PURPLE}▸ Cloning repository...${RESET}"
    git clone "$REPO_URL" "$INSTALL_DIR" 2>/dev/null
    echo -e "${GREEN}✓ Repository cloned${RESET}"
fi

cd "$INSTALL_DIR"

# Install dependencies
echo ""
echo -e "${PURPLE}▸ Installing dependencies...${RESET}"
npm install --silent 2>/dev/null
echo -e "${GREEN}✓ Dependencies installed${RESET}"

# Create global command
echo -e "${PURPLE}▸ Creating global command...${RESET}"
mkdir -p "$HOME/.local/bin"
cat > "$HOME/.local/bin/recode" << 'EOF'
#!/bin/bash
cd $HOME/recode
exec node recode-temp/package/cli.js "$@"
EOF
chmod +x "$HOME/.local/bin/recode"

# Add to PATH
BASHRC="$HOME/.bashrc"
if [ -f "$BASHRC" ]; then
    if ! grep -q "\.local/bin" "$BASHRC" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$BASHRC"
    fi
fi
echo -e "${GREEN}✓ Command 'recode' created${RESET}"

# ════════════════════════════════════════════════════════════════════════════
# Complete
# ════════════════════════════════════════════════════════════════════════════

echo ""
echo -e "${PURPLE}╔═══════════════════════════════════════════════════════════╗${RESET}"
echo -e "${PURPLE}║${RESET}       ${PINK}INSTALLATION COMPLETE!${RESET}                          ${PURPLE}║${RESET}"
echo -e "${PURPLE}╚═══════════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "  ${BOLD}Run ReCode:${RESET}"
echo -e "    ${CYAN}recode${RESET}"
echo ""
echo -e "  ${BOLD}Refresh terminal:${RESET}"
echo -e "    ${GRAY}source ~/.bashrc${RESET}"
echo ""
echo -e "  ${BOLD}Direct run:${RESET}"
echo -e "    ${GRAY}node $INSTALL_DIR/cli.js${RESET}"
echo ""
echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${GRAY}  Thank you for installing ReCode!${RESET}"
echo ""