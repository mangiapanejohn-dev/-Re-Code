#!/bin/bash
# ReCode Beautiful Installer - Purple/Pink Theme
# Supports macOS / Linux

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

gradient_text() {
    local text="$1"
    local chars=($(echo "$text" | grep -o .))
    local colors=("$PURPLE" "$MAGENTA" "$PINK" "$PURPLE")
    local n=${#chars[@]}
    local color_idx=0
    for ((i=0; i<n; i++)); do
        echo -en "${colors[$color_idx]}${chars[$i]}"
        if [ $((i % 3)) -eq 0 ]; then
            color_idx=$(( (color_idx + 1) % 4 ))
        fi
    done
    echo -en "${RESET}"
}

box_draw() {
    local text="$1"
    local width=60
    local padding=$(( (width - ${#text}) / 2 ))
    echo ""
    echo -e "${PURPLE}╔$(printf '═%.0s' $(seq 1 $width))╗${RESET}"
    echo -ne "${PURPLE}║$(printf ' %.0s' $(seq 1 $padding))${RESET}"
    gradient_text "$text"
    echo -ne "${PURPLE}$(printf ' %.0s' $(seq 1 $((width - padding - ${#text}))))║${RESET}"
    echo ""
    echo -e "${PURPLE}╚$(printf '═%.0s' $(seq 1 $width))╝${RESET}"
    echo ""
}

# ════════════════════════════════════════════════════════════════════════════
# ASCII ART BANNER
# ════════════════════════════════════════════════════════════════════════════

show_banner() {
    echo ""
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
}

spinner() {
    local pid=$1
    local spin='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        echo -ne "\r${PINK}${spin:$i:1}${RESET} "
        sleep 0.1
        i=$(( (i + 1) % 10 ))
    done
    echo -ne "\r"
}

# ════════════════════════════════════════════════════════════════════════════
# MAIN INSTALLATION
# ════════════════════════════════════════════════════════════════════════════

main() {
    show_banner

    echo -e "${PURPLE}▸ Checking Node.js...${RESET}"
    if ! command -v node &> /dev/null; then
        echo -e "${RED}✗ Node.js not found${RESET}"
        echo -e "${GRAY}  Please install from: https://nodejs.org/${RESET}"
        exit 1
    fi
    echo -e "${GREEN}✓${RESET} ${WHITE}Node.js: $(node --version)${RESET}"

    echo -e "${PURPLE}▸ Checking npm...${RESET}"
    if ! command -v npm &> /dev/null; then
        echo -e "${RED}✗ npm not found${RESET}"
        exit 1
    fi
    echo -e "${GREEN}✓${RESET} ${WHITE}npm: $(npm --version)${RESET}"

    REPO_URL="https://github.com/mangiapanejohn-dev/-Re-Code.git"
    INSTALL_DIR="$HOME/recode"

    echo ""
    echo -e "${PURPLE}▸ Preparing installation...${RESET}"

    if [ -d "$INSTALL_DIR" ]; then
        box_draw "UPDATE MODE"
        echo -e "${YELLOW}⚠ ReCode already installed at $INSTALL_DIR${RESET}"
        read -p "  Update to latest version? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            echo -e "${GRAY}  Skipping update...${RESET}"
        else
            echo -e "${PURPLE}▸ Updating ReCode...${RESET}"
            cd "$INSTALL_DIR"
            git pull 2>/dev/null || echo -e "${YELLOW}  Using existing files${RESET}"
        fi
    else
        box_draw "FRESH INSTALL"
        echo -e "${PURPLE}▸ Cloning repository...${RESET}"
        git clone "$REPO_URL" "$INSTALL_DIR" 2>/dev/null &
        pid=$!
        spinner $pid
        wait $pid
        echo -e "${GREEN}✓ Repository cloned${RESET}"
    fi

    cd "$INSTALL_DIR"

    echo ""
    echo -e "${PURPLE}▸ Installing dependencies...${RESET}"
    npm install --silent 2>/dev/null &
    pid=$!
    spinner $pid
    wait $pid
    echo -e "${GREEN}✓ Dependencies installed${RESET}"

    echo -e "${PURPLE}▸ Creating global command...${RESET}"
    if [ -L "/usr/local/bin/recode" ]; then
        rm -f /usr/local/bin/recode
    fi
    ln -sf "$INSTALL_DIR/recode-temp/package/cli.js" /usr/local/bin/recode 2>/dev/null || sudo ln -sf "$INSTALL_DIR/recode-temp/package/cli.js" /usr/local/bin/recode
    echo -e "${GREEN}✓ Command 'recode' created${RESET}"

    echo ""
    box_draw "INSTALLATION COMPLETE!"

    echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "  ${BOLD}Run ReCode:${RESET}"
    echo -e "    ${CYAN}recode${RESET}"
    echo ""
    echo -e "  ${BOLD}Direct run:${RESET}"
    echo -e "    ${GRAY}node $INSTALL_DIR/cli.js${RESET}"
    echo ""
    echo -e "  ${BOLD}Get help:${RESET}"
    echo -e "    ${GRAY}recode --help${RESET}"
    echo ""
    echo -e "${PINK}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
    echo ""
    echo -e "${GRAY}  Thank you for installing ReCode!${RESET}"
    echo ""
}

main "$@"