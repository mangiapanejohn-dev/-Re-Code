#!/usr/bin/env bash
set -euo pipefail

# ReCode Installer for Termux
# Usage: curl -fsSL https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install-termux.sh | bash
# Updated: 2026-04-04

REPO_URL="${RECODE_REPO_URL:-https://github.com/mangiapanejohn-dev/-Re-Code.git}"
INSTALL_ROOT="$HOME/recode"
BIN_DIR="$HOME/.local/bin"

BOLD='\033[1m'
ACCENT='\033[38;2;147;51;255m'
INFO='\033[38;2;210;130;255m'
SUCCESS='\033[38;2;47;201;113m'
WARN='\033[38;2;255;176;32m'
ERROR='\033[38;2;226;61;100m'
MUTED='\033[38;2;139;127;119m'
NC='\033[0m'

print_banner() {
    echo ""
    echo -e "${ACCENT}██████╗ ███████╗███████╗ ██████╗ ███╗   ██╗██╗██╗  ██╗${NC}"
    echo -e "${ACCENT}██╔══██╗██╔════╝██╔════╝██╔═══██╗████╗  ██║██║╚██╗██╔╝${NC}"
    echo -e "${ACCENT}██████╔╝█████╗  ███████╗██║   ██║██╔██╗ ██║██║ ╚███╔╝ ${NC}"
    echo -e "${ACCENT}██╔══██╗██╔══╝  ╚════██║██║   ██║██║╚██╗██║██║ ██╔██╗${NC}"
    echo -e "${ACCENT}██║  ██║███████╗███████║╚██████╔╝██║ ╚████║██║██╔╝╚██╗${NC}"
    echo -e "${ACCENT}╚═╝  ╚═╝╚══════╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝${NC}"
    echo ""
    echo -e "${BOLD}ReCode Installer (Termux)${NC}"
    echo -e "${MUTED}Source: ${INSTALL_ROOT}${NC}"
    echo ""
    echo -e "${INFO}Setting up ReCode on Termux...${NC}"
    echo ""
}

ui_error() {
    echo -e "${ERROR}[ERROR] $1${NC}" >&2
    exit 1
}

ui_info() {
    echo -e "${INFO}[INFO] $1${NC}"
}

ui_warn() {
    echo -e "${WARN}[WARN] $1${NC}"
}

ui_success() {
    echo -e "${SUCCESS}[OK] $1${NC}"
}

check_requirements() {
    if ! command -v node >/dev/null 2>&1; then
        ui_info "Installing Node.js..."
        apt-get install -y nodejs 2>/dev/null || pkg install -y nodejs 2>/dev/null
    fi

    local node_major
    node_major=$(node -p "process.versions.node.split('.')[0]" 2>/dev/null || echo "0")
    if [[ "$node_major" -lt 22 ]]; then
        ui_error "Node.js 22+ is required. Current: $(node -v)"
    fi

    if ! command -v git >/dev/null 2>&1; then
        ui_info "Installing Git..."
        apt-get install -y git 2>/dev/null || pkg install -y git 2>/dev/null
    fi

    if ! command -v npm >/dev/null 2>&1; then
        ui_error "npm is required. Reinstall Node.js with npm."
    fi

    ui_success "Requirements checked (Node $(node -v))"
}

install_or_update_source() {
    if [[ -d "$INSTALL_ROOT/.git" ]]; then
        ui_info "Updating existing ReCode checkout..."
        cd "$INSTALL_ROOT"
        git remote set-url origin "$REPO_URL" >/dev/null 2>&1 || true
        if git fetch --depth 1 origin main >/dev/null 2>&1; then
            git checkout -q main >/dev/null 2>&1 || true
            git reset --hard origin/main >/dev/null 2>&1
            ui_success "Source updated"
            return
        fi
    fi

    if [[ -e "$INSTALL_ROOT" ]]; then
        rm -rf "$INSTALL_ROOT"
    fi

    ui_info "Cloning ReCode source..."
    git clone --depth 1 "$REPO_URL" "$INSTALL_ROOT"
    ui_success "Source cloned"
}

run_install() {
    cd "$INSTALL_ROOT"
    ui_info "Installing dependencies..."
    npm install
    ui_success "Dependencies installed"
}

run_build() {
    cd "$INSTALL_ROOT"
    ui_info "Building ReCode CLI..."
    npm run build
    ui_success "Build completed"
}

install_launcher() {
    mkdir -p "$BIN_DIR"

    cat >"$BIN_DIR/recode" <<WRAPPER
#!/usr/bin/env bash
cd $HOME/recode
exec node \$HOME/recode/recode-temp/package/cli.js "\$@"
WRAPPER

    chmod +x "$BIN_DIR/recode"

    # Add to PATH
    if [[ -f "$HOME/.bashrc" ]]; then
        if ! grep -q "\.local/bin" "$HOME/.bashrc" 2>/dev/null; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        fi
    fi

    ui_success "Launcher installed at ${BIN_DIR}/recode"
}

print_success() {
    echo ""
    ui_success "ReCode installed successfully!"
    echo ""
    echo -e "${BOLD}Next steps${NC}"
    echo "  1) Verify: recode -v"
    echo "  2) First launch: recode"
    echo "  3) Get help: recode --help"
    echo ""
    echo -e "${MUTED}If 'recode' is not found, restart Termux or run: source ~/.bashrc${NC}"
}

main() {
    print_banner

    # Check if in Termux
    if [[ ! -d "/data/data/com.termux" && ! -d "$PREFIX" ]]; then
        ui_warn "Not running in Termux - continuing anyway"
    fi

    check_requirements
    install_or_update_source
    run_install
    run_build
    install_launcher

    print_success
}

main "$@"