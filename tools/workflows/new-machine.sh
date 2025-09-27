#!/usr/bin/env bash
# New machine setup workflow

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Configuration
MACHINE_NAME=""
INSTALL_TYPE=""
USER_EMAIL=""
USER_NAME=""

welcome_message() {
    clear
    cat << 'EOF'
    ╔══════════════════════════════════════════════════╗
    ║                                                  ║
    ║            🚀 New Machine Setup                  ║
    ║                                                  ║
    ║        Welcome to your dotfiles installation!    ║
    ║                                                  ║
    ╚══════════════════════════════════════════════════╝
EOF
    echo
}

collect_user_info() {
    log_info "Let's gather some information about your setup..."
    echo
    
    # Machine name
    read -p "Machine name (default: $(hostname)): " MACHINE_NAME
    MACHINE_NAME=${MACHINE_NAME:-$(hostname)}
    
    # Installation type
    echo
    echo "Choose installation type:"
    echo "1) Full installation (recommended)"
    echo "2) Minimal installation (basic configs only)"
    echo "3) Development installation (full + dev tools)"
    echo "4) Custom installation (choose components)"
    
    read -p "Enter choice [1-4]: " choice
    case $choice in
        1) INSTALL_TYPE="full" ;;
        2) INSTALL_TYPE="minimal" ;;
        3) INSTALL_TYPE="development" ;;
        4) INSTALL_TYPE="custom" ;;
        *) INSTALL_TYPE="full" ;;
    esac
    
    # Git configuration
    echo
    log_info "Git configuration (leave empty to skip):"
    read -p "Your name: " USER_NAME
    read -p "Your email: " USER_EMAIL
    
    # Confirmation
    echo
    log_info "Configuration summary:"
    echo "  Machine name: $MACHINE_NAME"
    echo "  Installation type: $INSTALL_TYPE"
    echo "  Git name: ${USER_NAME:-<not set>}"
    echo "  Git email: ${USER_EMAIL:-<not set>}"
    echo
    
    if ! confirm "Proceed with installation?"; then
        log_error "Installation cancelled by user"
        exit 1
    fi
}

confirm() {
    local message="$1"
    local response
    
    while true; do
        read -p "$message (y/n): " response
        case "$response" in
            [Yy]|[Yy][Ee][Ss]) return 0 ;;
            [Nn]|[Nn][Oo]) return 1 ;;
            *) echo "Please answer yes or no." ;;
        esac
    done
}

detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)
            if [[ -f /etc/os-release ]]; then
                . /etc/os-release
                echo "$ID"
            else
                echo "linux"
            fi
            ;;
        *) echo "unknown" ;;
    esac
}

install_prerequisites() {
    local os
    os=$(detect_os)
    
    log_info "Installing prerequisites for $os..."
    
    case "$os" in
        macos)
            # Install Xcode command line tools
            if ! xcode-select -p &> /dev/null; then
                log_info "Installing Xcode command line tools..."
                xcode-select --install
                log_info "Please complete the Xcode installation and run this script again"
                exit 0
            fi
            
            # Install Homebrew
            if ! command -v brew &> /dev/null; then
                log_info "Installing Homebrew..."
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                
                # Add Homebrew to PATH
                echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            ;;
        ubuntu|debian)
            sudo apt update
            sudo apt install -y curl wget git zsh
            ;;
        fedora)
            sudo dnf install -y curl wget git zsh
            ;;
        arch)
            sudo pacman -Sy --noconfirm curl wget git zsh
            ;;
        *)
            log_warning "Unknown OS, skipping prerequisites"
            ;;
    esac
}

run_installation() {
    log_info "Starting $INSTALL_TYPE installation..."
    
    case "$INSTALL_TYPE" in
        minimal)
            run_minimal_installation
            ;;
        full)
            run_full_installation
            ;;
        development)
            run_development_installation
            ;;
        custom)
            run_custom_installation
            ;;
    esac
}

run_minimal_installation() {
    log_info "Running minimal installation..."
    
    # Core configurations only
    "$DOTFILES_DIR/scripts/utils/create-symlinks.sh" --minimal
    
    # Install essential fonts
    "$DOTFILES_DIR/scripts/install/install-fonts.sh" --essential
}

run_full_installation() {
    log_info "Running full installation..."
    
    # Run the main install script
    "$DOTFILES_DIR/install.sh"
    
    # Install fonts
    "$DOTFILES_DIR/scripts/install/install-fonts.sh"
    
    # Install CLI tools
    "$DOTFILES_DIR/scripts/install/install-cli-tools.sh"
}

run_development_installation() {
    log_info "Running development installation..."
    
    # Full installation first
    run_full_installation
    
    # Development tools
    "$DOTFILES_DIR/scripts/install/install-dev-tools.sh"
    
    # Docker (optional)
    if confirm "Install Docker?"; then
        "$DOTFILES_DIR/scripts/install/install-docker.sh"
    fi
    
    # Node.js (optional)
    if confirm "Install Node.js?"; then
        "$DOTFILES_DIR/scripts/install/install-nodejs.sh"
    fi
}

run_custom_installation() {
    log_info "Running custom installation..."
    
    local components=(
        "Core configurations"
        "Shell configurations (zsh, aliases, functions)"
        "Terminal configurations (tmux, kitty)"
        "Editor configurations (vim)"
        "Git configurations"
        "Fonts"
        "CLI tools"
        "Development tools"
        "Docker"
        "Node.js"
    )
    
    echo "Choose components to install:"
    for i in "${!components[@]}"; do
        echo "$((i+1))) ${components[$i]}"
    done
    echo
    
    read -p "Enter component numbers (e.g., 1,2,3): " selections
    
    # Process selections
    IFS=',' read -ra SELECTED <<< "$selections"
    for selection in "${SELECTED[@]}"; do
        case $((selection-1)) in
            0) create_core_symlinks ;;
            1) setup_shell_configs ;;
            2) setup_terminal_configs ;;
            3) setup_editor_configs ;;
            4) setup_git_configs ;;
            5) "$DOTFILES_DIR/scripts/install/install-fonts.sh" ;;
            6) "$DOTFILES_DIR/scripts/install/install-cli-tools.sh" ;;
            7) "$DOTFILES_DIR/scripts/install/install-dev-tools.sh" ;;
            8) "$DOTFILES_DIR/scripts/install/install-docker.sh" ;;
            9) "$DOTFILES_DIR/scripts/install/install-nodejs.sh" ;;
        esac
    done
}

setup_git_config() {
    if [[ -n "$USER_NAME" ]] && [[ -n "$USER_EMAIL" ]]; then
        log_info "Setting up Git configuration..."
        
        git config --global user.name "$USER_NAME"
        git config --global user.email "$USER_EMAIL"
        
        # Copy git template
        cp "$DOTFILES_DIR/templates/.gitconfig.template" "$HOME/.gitconfig.local"
        
        log_success "Git configured with name: $USER_NAME, email: $USER_EMAIL"
    fi
}

setup_ssh_keys() {
    if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
        if confirm "Generate SSH key for Git repositories?"; then
            log_info "Generating SSH key..."
            
            ssh-keygen -t ed25519 -C "$USER_EMAIL" -f "$HOME/.ssh/id_ed25519" -N ""
            
            # Start ssh-agent and add key
            eval "$(ssh-agent -s)"
            ssh-add "$HOME/.ssh/id_ed25519"
            
            log_success "SSH key generated: $HOME/.ssh/id_ed25519.pub"
            log_info "Add this public key to your Git hosting service:"
            echo
            cat "$HOME/.ssh/id_ed25519.pub"
            echo
        fi
    fi
}

create_local_configs() {
    log_info "Creating local configuration directories..."
    
    # Create local directories
    mkdir -p "$HOME/.local/bin"
    mkdir -p "$HOME/.local/share"
    mkdir -p "$HOME/.config"
    
    # Create dotfiles local directories
    mkdir -p "$DOTFILES_DIR/local/config"
    mkdir -p "$DOTFILES_DIR/local/scripts"
    mkdir -p "$DOTFILES_DIR/local/notes"
    
    # Create machine-specific config
    cat > "$DOTFILES_DIR/local/config/machine.env" << EOF
# Machine-specific environment variables
MACHINE_NAME="$MACHINE_NAME"
INSTALL_DATE="$(date)"
INSTALL_TYPE="$INSTALL_TYPE"
OS="$(detect_os)"
EOF
}

final_setup() {
    log_info "Performing final setup steps..."
    
    # Set zsh as default shell
    if [[ "$SHELL" != */zsh ]] && command -v zsh &> /dev/null; then
        log_info "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
    fi
    
    # Source configurations
    if [[ -f "$HOME/.zshrc" ]]; then
        log_info "Sourcing zsh configuration..."
        zsh -c "source ~/.zshrc" || true
    fi
    
    # Run health check
    if [[ -x "$DOTFILES_DIR/tools/doctor.sh" ]]; then
        log_info "Running system health check..."
        "$DOTFILES_DIR/tools/doctor.sh" --quiet || true
    fi
}

show_completion_message() {
    clear
    cat << 'EOF'
    ╔══════════════════════════════════════════════════╗
    ║                                                  ║
    ║            🎉 Installation Complete!             ║
    ║                                                  ║
    ║         Your dotfiles are now configured!        ║
    ║                                                  ║
    ╚══════════════════════════════════════════════════╝
EOF
    
    echo
    log_success "Installation completed successfully!"
    echo
    log_info "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. If you generated an SSH key, add it to your Git hosting service"
    echo "  3. Review and customize configurations in: $DOTFILES_DIR/local/"
    echo "  4. Run 'make doctor' to verify your setup"
    echo
    log_info "Useful commands:"
    echo "  make help          - Show available commands"
    echo "  make update        - Update all tools and configurations"
    echo "  make doctor        - Run health check"
    echo "  make clean         - Clean up temporary files"
    echo
    
    if [[ -n "$USER_EMAIL" ]]; then
        log_info "Your SSH public key (add to Git hosting):"
        echo
        cat "$HOME/.ssh/id_ed25519.pub" 2>/dev/null || echo "SSH key not found"
        echo
    fi
}

main() {
    # Check if already in dotfiles directory
    if [[ ! -f "$DOTFILES_DIR/install.sh" ]]; then
        log_error "Please run this script from the dotfiles directory"
        exit 1
    fi
    
    welcome_message
    collect_user_info
    install_prerequisites
    run_installation
    setup_git_config
    setup_ssh_keys
    create_local_configs
    final_setup
    show_completion_message
}

main "$@"