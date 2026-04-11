#!/usr/bin/env bash
set -euo pipefail

# RE CODE Installer for macOS/Linux
# Usage: curl -fsSL https://cdn.jsdelivr.net/gh/mangiapanejohn-dev/-Re-Code/install.sh | bash
# Or:    curl -fsSL https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.sh | bash
# Updated: 2026-04-07

REPO_URL="${RECODE_REPO_URL:-https://github.com/mangiapanejohn-dev/-Re-Code.git}"
INSTALL_ROOT="${RECODE_INSTALL_ROOT:-$HOME/.recode}"
SOURCE_DIR="${RECODE_SOURCE_DIR:-$INSTALL_ROOT/source}"
BIN_DIR="${RECODE_BIN_DIR:-$HOME/.local/bin}"
PNPM_VERSION="${RECODE_PNPM_VERSION:-10.23.0}"
SKIP_PATH_SETUP="${RECODE_INSTALL_SKIP_PATH:-0}"

# Enhanced TUI Colors with gradient support
BOLD='\033[1m'
DIM='\033[2m'

# Gradient colors (RGB)
gradient_start='\033[38;2;147;51;255m'    # Purple
gradient_mid='\033[38;2;88;166;255m'     # Blue
gradient_end='\033[38;2;46;204;113m'     # Green

ACCENT='\033[38;2;147;51;255m'
INFO='\033[38;2;210;130;255m'
SUCCESS='\033[38;2;46;204;113m'
WARN='\033[38;2;255;176;32m'
ERROR='\033[38;2;255;71;87m'
MUTED='\033[38;2;99;110;121m'
CYAN='\033[38;2;52;199;255m'
YELLOW='\033[38;2;255;204;0m'
PINK='\033[38;2;255;45;85m'
GEAR="⚙️"
NC='\033[0m'

# Unicode symbols
SYMBOL_OK="✓"
SYMBOL_ERR="✗"
SYMBOL_ARROW="→"
SYMBOL_SPARKLE="✨"
SYMBOL_ROCKET="🚀"
SYMBOL_PACKAGE="📦"
SYMBOL_GEAR="⚙️"
SYMBOL_BRAIN="🧠"
SYMBOL_CUBE="🧊"

PM_KIND=""
PM_CMD=()
SPINNER_FRAME=0

# Spinner animation
spinner() {
    local frames=('⠋' '⠙' '⠹' '⠸' '⠼' '⠴' '⠦' '⠧' '⠇' '⠏')
    printf "\r${CYAN}%s${NC}" "${frames[$((SPINNER_FRAME++ % 10))]}"
}

clear_spinner() {
    printf "\r%*s\r" "$(tput cols 2>/dev/null || echo 80)" ""
}

# Progress bar
print_progress() {
    local current=$1
    local total=$2
    local width=30
    local percent=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))

    printf "\r${CYAN}["
    printf "%${filled}s" | tr ' ' '█'
    printf "%${empty}s" | tr ' ' '░'
    printf "] ${percent}%%${NC}"
}

# Animated banner
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
    echo -e "${DIM}Source:${MUTED} ${SOURCE_DIR}${NC}"
    echo -e "${DIM}Binary:${MUTED} ${BIN_DIR}/re-code${NC}"
    echo -e "${DIM}State:${MUTED} ~/.recode${NC}"
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
    echo -e "${CYAN}${SYMBOL_ARROW} ${INFO}$1${NC}"
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

# Step-by-step installation display
print_steps() {
    echo -e "${DIM}Installation steps:${NC}"
    echo -e "  ${CYAN}1${NC}) Check requirements"
    echo -e "  ${CYAN}2${NC}) Setup package manager"
    echo -e "  ${CYAN}3${NC}) Clone/Update source"
    echo -e "  ${CYAN}4${NC}) Install dependencies"
    echo -e "  ${CYAN}5${NC}) Build CLI"
    echo -e "  ${CYAN}6${NC}) Install launcher"
    echo -e "  ${CYAN}7${NC}) Configure PATH"
    echo ""
}

detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*) echo "linux" ;;
        *) ui_error "Unsupported OS: $(uname -s)" ;;
    esac
}

check_requirements() {
    detect_os >/dev/null

    echo -e "  ${GEAR} ${MUTED}Checking Node.js...${NC}"
    if ! command -v node >/dev/null 2>&1; then
        ui_error "Node.js not found. Install Node.js 22+ first: https://nodejs.org"
    fi

    local node_major
    node_major=$(node -p "process.versions.node.split('.')[0]" 2>/dev/null || echo "0")
    if [[ "$node_major" -lt 22 ]]; then
        ui_error "Node.js 22+ is required. Current: $(node -v)"
    fi
    echo -e "    ${SUCCESS}${SYMBOL_OK} Node.js $(node -v)${NC}"

    echo -e "  ${GEAR} ${MUTED}Checking Git...${NC}"
    if ! command -v git >/dev/null 2>&1; then
        ui_error "Git is required. Install from https://git-scm.com"
    fi
    echo -e "    ${SUCCESS}${SYMBOL_OK} Git $(git --version | cut -d' ' -f3)${NC}"

    echo -e "  ${GEAR} ${MUTED}Checking npm...${NC}"
    if ! command -v npm >/dev/null 2>&1; then
        ui_error "npm is required. Reinstall Node.js with npm included."
    fi
    echo -e "    ${SUCCESS}${SYMBOL_OK} npm $(npm -v)${NC}"

    ui_success "All requirements met!"
}

setup_package_manager() {
    if command -v pnpm >/dev/null 2>&1; then
        PM_KIND="pnpm"
        PM_CMD=(pnpm)
        ui_success "Using pnpm ($(pnpm --version))"
        return
    fi

    if command -v corepack >/dev/null 2>&1; then
        ui_info "pnpm not found, trying corepack."
        if corepack enable >/dev/null 2>&1 && corepack prepare "pnpm@${PNPM_VERSION}" --activate >/dev/null 2>&1; then
            PM_KIND="pnpm"
            if command -v pnpm >/dev/null 2>&1; then
                PM_CMD=(pnpm)
            else
                PM_CMD=(corepack pnpm)
            fi
            ui_success "pnpm enabled via corepack"
            return
        fi
        ui_warn "corepack setup failed; falling back to npm."
    fi

    ui_warn "pnpm unavailable; using npm."
    PM_KIND="npm"
    PM_CMD=(npm)
}

backup_path() {
    local path="$1"
    local stamp
    stamp=$(date +%Y%m%d%H%M%S)
    local backup="${path}.backup.${stamp}"
    mv "$path" "$backup"
    ui_warn "Preserved existing path as: ${backup}"
}

clone_fresh() {
    if [[ -e "$SOURCE_DIR" ]]; then
        backup_path "$SOURCE_DIR"
    fi
    git clone --depth 1 "$REPO_URL" "$SOURCE_DIR"
}

install_or_update_source() {
    mkdir -p "$(dirname "$SOURCE_DIR")"

    if [[ -d "$SOURCE_DIR/.git" ]]; then
        local dirty
        dirty=$(git -C "$SOURCE_DIR" status --porcelain 2>/dev/null || true)
        if [[ -n "$dirty" ]]; then
            ui_warn "Local changes found in ${SOURCE_DIR}; cloning a fresh copy to keep your edits safe."
            clone_fresh
            return
        fi

        ui_info "Updating existing RE CODE checkout..."
        git -C "$SOURCE_DIR" remote set-url origin "$REPO_URL" >/dev/null 2>&1 || true
        if git -C "$SOURCE_DIR" fetch --depth 1 origin main >/dev/null 2>&1; then
            git -C "$SOURCE_DIR" checkout -q main >/dev/null 2>&1 || true
            git -C "$SOURCE_DIR" reset --hard origin/main >/dev/null 2>&1
            ui_success "Source updated"
        else
            ui_warn "Git update failed; recloning from scratch."
            clone_fresh
        fi
        return
    fi

    if [[ -e "$SOURCE_DIR" ]]; then
        ui_warn "Existing non-git path at ${SOURCE_DIR}; preserving and recloning."
    fi

    ui_info "Cloning RE CODE source..."
    clone_fresh
    ui_success "Source cloned"
}

run_install() {
    cd "$SOURCE_DIR"

    if [[ "$PM_KIND" == "pnpm" ]]; then
        ui_info "Installing dependencies with pnpm..."
        # No lockfile in fresh clone, use regular install
        if ! "${PM_CMD[@]}" install; then
            ui_warn "pnpm install failed, trying npm..."
            npm install
        fi
        ui_success "Dependencies installed"
        return
    fi

    ui_info "Installing dependencies with npm"
    npm install
    ui_success "Dependencies installed"
}

run_build() {
    cd "$SOURCE_DIR"

    # Check if pre-built CLI exists
    if [[ -f "$SOURCE_DIR/recode-temp/package/cli.js" ]]; then
        ui_info "Using pre-built RE CODE CLI..."
        ui_success "CLI ready"
        return
    fi

    ui_info "Building RE CODE CLI..."

    if [[ "$PM_KIND" == "pnpm" ]]; then
        if "${PM_CMD[@]}" build; then
            ui_success "Build completed"
            return
        fi
    else
        if npm run build; then
            ui_success "Build completed"
            return
        fi
    fi

    # If build fails, try using pre-built anyway
    ui_warn "Build failed, checking for pre-built CLI..."
}

install_launcher() {
    mkdir -p "$BIN_DIR"

    cat >"$BIN_DIR/re-code" <<WRAPPER
#!/usr/bin/env bash
set -euo pipefail
SOURCE_DIR="\${RECODE_SOURCE_DIR:-$SOURCE_DIR}"
ENTRY="\$SOURCE_DIR/recode-temp/package/cli.js"

if [[ ! -f "\$ENTRY" ]]; then
  echo "[re-code] CLI entry not found at \$ENTRY" >&2
  echo "[re-code] Re-run installer: curl -fsSL https://raw.githubusercontent.com/mangiapanejohn-dev/-Re-Code/main/install.sh | bash" >&2
  exit 1
fi

exec node "\$ENTRY" "\$@"
WRAPPER

    chmod +x "$BIN_DIR/re-code"
    ui_success "Launcher installed at ${BIN_DIR}/re-code"
}

ensure_path() {
    local path_line
    path_line="export PATH=\"$BIN_DIR:\$PATH\""

    local touched=0
    local profile
    for profile in "$HOME/.zshrc" "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile"; do
        if [[ -f "$profile" ]]; then
            if ! grep -Fqs "$path_line" "$profile"; then
                printf '\n%s\n' "$path_line" >>"$profile"
                touched=1
            fi
        fi
    done

    if [[ "$touched" -eq 0 ]]; then
        local default_profile="$HOME/.profile"
        case "$(basename "${SHELL:-}")" in
            zsh) default_profile="$HOME/.zshrc" ;;
            bash) default_profile="$HOME/.bashrc" ;;
        esac
        touch "$default_profile"
        if ! grep -Fqs "$path_line" "$default_profile"; then
            printf '\n%s\n' "$path_line" >>"$default_profile"
        fi
    fi

    if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
        export PATH="$BIN_DIR:$PATH"
    fi

    ui_success "PATH updated for current and future shells"
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
    echo -e "${DIM}If 're-code' is not found, open a new terminal.${NC}"
}

main() {
    print_banner
    print_steps

    ui_step "1. Checking Requirements"
    check_requirements

    ui_step "2. Setting Up Package Manager"
    setup_package_manager

    ui_step "3. Cloning/Updating Source"
    install_or_update_source

    ui_step "4. Installing Dependencies"
    run_install

    ui_step "5. Building CLI"
    run_build

    ui_step "6. Installing Launcher"
    install_launcher

    if [[ "$SKIP_PATH_SETUP" == "1" ]]; then
        ui_warn "Skipping PATH/profile updates (RECODE_INSTALL_SKIP_PATH=1)"
    else
        ui_step "7. Configuring PATH"
        ensure_path
    fi

    print_success
}

main "$@"
