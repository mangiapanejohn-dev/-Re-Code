#!/usr/bin/env bash
set -euo pipefail

# RE CODE Installer for Termux
# Usage: curl -fsSL https://cdn.jsdelivr.net/gh/mangiapanejohn-dev/-Re-Code/install-termux.sh | bash
# Or:    curl -fsSL https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install-termux.sh | bash
# Updated: 2026-04-07

REPO_URL="${RECODE_REPO_URL:-https://github.com/mangiapanejohn-dev/-Re-Code.git}"
INSTALL_ROOT="$HOME/recode"
BIN_DIR="$HOME/.local/bin"

# Enhanced TUI Colors
BOLD='\033[1m'
DIM='\033[2m'

# Gradient colors
gradient_start='\033[38;2;147;51;255m'
gradient_mid='\033[38;2;88;166;255m'
gradient_end='\033[38;2;46;204;113m'

ACCENT='\033[38;2;147;51;255m'
INFO='\033[38;2;210;130;255m'
SUCCESS='\033[38;2;46;204;113m'
WARN='\033[38;2;255;176;32m'
ERROR='\033[38;2;255;71;87m'
MUTED='\033[38;2;99;110;121m'
CYAN='\033[38;2;52;199;255m'
YELLOW='\033[38;2;255;204;0m'
PINK='\033[38;2;255;45;85m'
NC='\033[0m'

# Unicode symbols
SYMBOL_OK="✓"
SYMBOL_ERR="✗"
SYMBOL_ARROW="→"
SYMBOL_SPARKLE="✨"
SYMBOL_ROCKET="🚀"

print_banner() {
    echo ""
    echo -e "${gradient_start}╔════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${gradient_start}║${gradient_mid}                                                                            ${gradient_start}║${NC}"
    echo -e "${gradient_start}║${gradient_mid}  ██████╗     ███████╗      ██████╗      ██████╗     ██████╗     ███████╗   ${gradient_start}║${NC}"
    echo -e "${gradient_start}║${gradient_mid}  ██╔══██╗    ██╔════╝     ██╔════╝     ██╔═══██╗    ██╔══██╗    ██╔════╝   ${gradient_start}║${NC}"
    echo -e "${gradient_mid}   ██████╔╝    █████╗       ██║          ██║   ██║    ██║  ██║    █████╗     ${gradient_start}║${NC}"
    echo -e "${gradient_mid}   ██╔══██╗    ██╔══╝       ██║          ██║   ██║    ██║  ██║    ██╔══╝     ${gradient_start}║${NC}"
    echo -e "${gradient_end}   ██║  ██║    ███████╗     ╚██████╗     ╚██████╔╝    ██████╔╝    ███████╗   ${gradient_start}║${NC}"
    echo -e "${gradient_end}   ╚═╝  ╚═╝    ╚══════╝      ╚═════╝      ╚═════╝     ╚═════╝     ╚══════╝   ${gradient_start}║${NC}"
    echo -e "${gradient_start}║${gradient_mid}                                                                            ${gradient_start}║${NC}"
    echo -e "${gradient_start}║${gradient_mid}      ${PINK}[ R ]${CYAN}      ${PINK}[ E ]${CYAN}      ${PINK}[ C ]${CYAN}      ${PINK}[ O ]${CYAN}      ${PINK}[ D ]${CYAN}      ${PINK}[ E ]${gradient_mid}          ${gradient_start}║${NC}"
    echo -e "${gradient_start}║${gradient_mid}                                                                            ${gradient_start}║${NC}"
    echo -e "${gradient_start}║${YELLOW}      Heyy ~ Bro ${SYMBOL_SPARKLE} WANT VIBE CODING KNOW ???                               ${gradient_start}║${NC}"
    echo -e "${gradient_start}║${gradient_mid}                                                                            ${gradient_start}║${NC}"
    echo -e "${gradient_start}║${CYAN}  >_ RE_CODE PROTOCOL ENGAGED ${SYMBOL_ROCKET} NEURAL GRID ONLINE ${YELLOW}// v3.0.2          ${gradient_start}║${NC}"
    echo -e "${gradient_start}╚════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${DIM}Source:${MUTED} ${INSTALL_ROOT}${NC}"
    echo ""
}

ui_error() {
    echo ""
    echo -e "${ERROR}╭───────────────────────────────────────╮${NC}"
    echo -e "${ERROR}│ ${SYMBOL_ERR} ERROR: $1${NC}"
    echo -e "${ERROR}╰───────────────────────────────────────╯${NC}"
    exit 1
}

ui_info() {
    echo -e "${CYAN}${SYMBOL_ARROW} ${1}${NC}"
}

ui_warn() {
    echo -e "${WARN}⚠ ${1}${NC}"
}

ui_success() {
    echo -e "${SUCCESS}${SYMBOL_OK} $1${NC}"
}

ui_step() {
    echo ""
    echo -e "${PINK}━━━ ${BOLD}$1${NC} ━━━"
}

print_steps() {
    echo -e "${DIM}Installation steps:${NC}"
    echo -e "  ${CYAN}1${NC}) Check requirements"
    echo -e "  ${CYAN}2${NC}) Clone/Update source"
    echo -e "  ${CYAN}3${NC}) Install dependencies"
    echo -e "  ${CYAN}4${NC}) Build CLI"
    echo -e "  ${CYAN}5${NC}) Install launcher"
    echo ""
}

check_requirements() {
    echo -e "  ${CYAN}Checking Node.js...${NC}"

    if ! command -v node >/dev/null 2>&1; then
        ui_info "Installing Node.js via pkg..."
        pkg install -y nodejs 2>/dev/null || apt-get install -y nodejs 2>/dev/null
    fi

    local node_major
    node_major=$(node -p "process.versions.node.split('.')[0]" 2>/dev/null || echo "0")
    if [[ "$node_major" -lt 22 ]]; then
        ui_error "Node.js 22+ is required. Current: $(node -v)"
    fi
    echo -e "    ${SUCCESS}${SYMBOL_OK} Node.js $(node -v)${NC}"

    echo -e "  ${CYAN}Checking Git...${NC}"
    if ! command -v git >/dev/null 2>&1; then
        ui_info "Installing Git via pkg..."
        pkg install -y git 2>/dev/null || apt-get install -y git 2>/dev/null
    fi
    echo -e "    ${SUCCESS}${SYMBOL_OK} Git $(git --version | cut -d' ' -f3)${NC}"

    echo -e "  ${CYAN}Checking npm...${NC}"
    if ! command -v npm >/dev/null 2>&1; then
        ui_error "npm is required. Reinstall Node.js with npm."
    fi
    echo -e "    ${SUCCESS}${SYMBOL_OK} npm $(npm -v)${NC}"

    ui_success "All requirements met!"
}

install_or_update_source() {
    if [[ -d "$INSTALL_ROOT/.git" ]]; then
        ui_info "Updating existing RE CODE checkout..."
        cd "$INSTALL_ROOT"
        git remote set-url origin "$REPO_URL" >/dev/null 2>&1 || true
        if git fetch --depth 1 origin main >/dev/null 2>&1; then
            git checkout -q main >/dev/null 2>&1 || true
            git reset --hard origin/main >/dev/null 2>&1
            ui_success "Source updated to latest"
            return
        fi
    fi

    if [[ -e "$INSTALL_ROOT" ]]; then
        rm -rf "$INSTALL_ROOT"
    fi

    ui_info "Cloning RE CODE from GitHub..."
    git clone --depth 1 "$REPO_URL" "$INSTALL_ROOT"
    ui_success "Source cloned successfully"
}

run_install() {
    cd "$INSTALL_ROOT"
    ui_info "Running npm install..."
    npm install
    ui_success "Dependencies installed"
}

run_build() {
    cd "$INSTALL_ROOT"

    # Check if pre-built CLI exists
    if [[ -f "$INSTALL_ROOT/recode-temp/package/cli.js" ]]; then
        ui_info "Using pre-built RE CODE CLI..."
        ui_success "CLI ready"
        return
    fi

    ui_info "Building RE CODE CLI..."
    if npm run build; then
        ui_success "Build completed"
        return
    fi

    ui_warn "Build failed, checking for pre-built CLI..."
}

install_launcher() {
    mkdir -p "$BIN_DIR"

    cat >"$BIN_DIR/re-code" <<WRAPPER
#!/usr/bin/env bash
cd $HOME/recode
exec node \$HOME/recode/recode-temp/package/cli.js "\$@"
WRAPPER

    chmod +x "$BIN_DIR/re-code"

    # Add to PATH
    if [[ -f "$HOME/.bashrc" ]]; then
        if ! grep -q "\.local/bin" "$HOME/.bashrc" 2>/dev/null; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        fi
    fi

    ui_success "Launcher installed at ${BIN_DIR}/re-code"
}

print_success() {
    echo ""
    echo -e "${gradient_start}╔════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${gradient_start}║${gradient_mid}                                                                            ${gradient_start}║${NC}"
    echo -e "${gradient_start}║${SUCCESS}                    ${SYMBOL_OK} RE CODE INSTALLED SUCCESSFULLY ${SYMBOL_SPARKLE}                      ${gradient_start}║${NC}"
    echo -e "${gradient_start}║${gradient_mid}                                                                            ${gradient_start}║${NC}"
    echo -e "${gradient_start}║${CYAN}                      ${SYMBOL_ROCKET} NEURAL GRID ONLINE // READY ${gradient_start}║${NC}"
    echo -e "${gradient_start}║${gradient_mid}                                                                            ${gradient_start}║${NC}"
    echo -e "${gradient_start}╚════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${BOLD}${PINK}Next steps:${NC}"
    echo -e "  ${CYAN}${SYMBOL_ARROW} ${MUTED}Verify:${NC}    re-code -v"
    echo -e "  ${CYAN}${SYMBOL_ARROW} ${MUTED}Launch:${NC}   re-code"
    echo -e "  ${CYAN}${SYMBOL_ARROW} ${MUTED}Help:${NC}      re-code --help"
    echo ""
    echo -e "${DIM}If 're-code' not found, restart Termux or run: source ~/.bashrc${NC}"
}

main() {
    print_banner
    print_steps

    # Check if in Termux
    if [[ ! -d "/data/data/com.termux" && ! -d "$PREFIX" ]]; then
        ui_warn "Not running in Termux - continuing anyway"
    fi

    ui_step "1. Checking Requirements"
    check_requirements

    ui_step "2. Cloning/Updating Source"
    install_or_update_source

    ui_step "3. Installing Dependencies"
    run_install

    ui_step "4. Building CLI"
    run_build

    ui_step "5. Installing Launcher"
    install_launcher

    print_success
}

main "$@"
