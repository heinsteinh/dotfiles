#!/usr/bin/env bash
# New machine setup workflow

set -euo pipefail

# Set TERM if not set (for CI environments)
if [[ -z "${TERM:-}" ]]; then
    export TERM=xterm-256color
fi

# Detect CI environment
if [[ "${CI:-}" == "true" ]] || [[ "${DOTFILES_CI_MODE:-}" == "true" ]] || [[ "${DOTFILES_SKIP_INTERACTIVE:-}" == "true" ]]; then
    DOTFILES_CI_MODE=true
    DOTFILES_SKIP_INTERACTIVE=true
else
    DOTFILES_CI_MODE=false
    DOTFILES_SKIP_INTERACTIVE=false
fi

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Source common setup functions first (this defines colors and logging)
if [[ -f "$DOTFILES_DIR/scripts/setup/setup-common.sh" ]]; then
    source "$DOTFILES_DIR/scripts/setup/setup-common.sh"
else
    echo "ERROR: Common setup script not found: $DOTFILES_DIR/scripts/setup/setup-common.sh"
    exit 1
fi


# Configuration
MACHINE_NAME=""
INSTALL_TYPE=""
USER_EMAIL=""
USER_NAME=""

welcome_message() {
    if [[ "$DOTFILES_CI_MODE" != "true" ]]; then
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
    else
        log_info "Starting New Machine Setup (CI Mode)"
    fi
}

collect_user_info() {
    if [[ "$DOTFILES_SKIP_INTERACTIVE" == "true" ]]; then
        # CI Mode: Use defaults from stdin or environment
        MACHINE_NAME=${MACHINE_NAME:-$(hostname)}
        INSTALL_TYPE=${INSTALL_TYPE:-"minimal"}
        USER_NAME=${USER_NAME:-"testuser"}
        USER_EMAIL=${USER_EMAIL:-"test@example.com"}
        
        # Try to read from stdin if available (for echo piping)
        if [[ -p /dev/stdin ]]; then
            read -r MACHINE_NAME || true
            read -r USER_EMAIL || true
            read -r INSTALL_TYPE || true
        fi
        
        log_info "CI Mode - Using configuration:"
        echo "  Machine name: $MACHINE_NAME"
        echo "  Installation type: $INSTALL_TYPE"
        echo "  Git name: ${USER_NAME:-<not set>}"
        echo "  Git email: ${USER_EMAIL:-<not set>}"
        return
    fi
    
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
    
    # Auto-confirm in CI mode
    if [[ "$DOTFILES_SKIP_INTERACTIVE" == "true" ]]; then
        log_info "Auto-confirming: $message"
        return 0
    fi

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
    esac
}

# New function to handle OS-specific setup
run_os_setup() {
    local os
    os=$(detect_os)

    log_info "Running $os-specific setup..."

    case "$os" in
        macos)
            if [[ -x "$DOTFILES_DIR/scripts/setup/setup-macos.sh" ]]; then
                "$DOTFILES_DIR/scripts/setup/setup-macos.sh"
            else
                log_warning "macOS setup script not found, running manual setup..."
                manual_macos_setup
            fi
            ;;
        ubuntu|debian)
            if [[ -x "$DOTFILES_DIR/scripts/setup/setup-ubuntu.sh" ]]; then
                "$DOTFILES_DIR/scripts/setup/setup-ubuntu.sh"
            else
                log_warning "Ubuntu/Debian setup script not found"
            fi
            ;;
        fedora)
            if [[ -x "$DOTFILES_DIR/scripts/setup/setup-fedora.sh" ]]; then
                "$DOTFILES_DIR/scripts/setup/setup-fedora.sh"
            else
                log_warning "Fedora setup script not found"
            fi
            ;;
        *)
            log_warning "No specific setup for OS: $os"
            ;;
    esac
}

# Fallback manual macOS setup
manual_macos_setup() {
    log_info "Running manual macOS setup..."

    # Install Homebrew if not present
    if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    # Install essential packages
    log_info "Installing essential packages..."
    brew install \
        git curl wget \
        zsh tmux vim \
        fzf ripgrep fd eza bat \
        htop tree || log_warning "Some packages failed to install"

    log_success "macOS manual setup complete"
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

    # Change to dotfiles directory
    cd "$DOTFILES_DIR"

    # Run OS-specific setup first
    run_os_setup

    # Run common setup (Oh My Zsh, plugins, etc.)
    common_setup

    # Core configurations only
    if [[ -x "./scripts/utils/create-symlinks.sh" ]]; then
        ./scripts/utils/create-symlinks.sh
    else
        log_error "Symlinks script not found: ./scripts/utils/create-symlinks.sh"
        return 1
    fi

    # Install essential fonts
    if [[ -x "./scripts/install/install-fonts.sh" ]]; then
        ./scripts/install/install-fonts.sh
    else
        log_warning "Fonts script not found, skipping font installation"
    fi

    log_success "Minimal installation completed"
}

run_full_installation() {
    log_info "Running full installation..."

    # Change to dotfiles directory to ensure relative paths work
    cd "$DOTFILES_DIR"

    # Run OS-specific setup first
    run_os_setup

    # Run common setup (Oh My Zsh, plugins, etc.)
    common_setup

    # Run the main install script
    if [[ -x "./install.sh" ]]; then
        ./install.sh
    else
        log_error "Main install script not found or not executable: ./install.sh"
        return 1
    fi

    log_success "Full installation completed"
}

run_development_installation() {
    log_info "Running development installation..."

    # Full installation first
    run_full_installation || return 1

    # Change to dotfiles directory
    cd "$DOTFILES_DIR"

    # Development tools (check if script exists)
    if [[ -x "./scripts/install/install-dev-tools.sh" ]]; then
        ./scripts/install/install-dev-tools.sh
    else
        log_warning "Development tools script not found, skipping..."
    fi

    # Docker (optional)
    if [[ -x "./scripts/install/install-docker.sh" ]] && confirm "Install Docker?"; then
        ./scripts/install/install-docker.sh
    fi

    # Node.js (optional)
    if [[ -x "./scripts/install/install-nodejs.sh" ]] && confirm "Install Node.js?"; then
        ./scripts/install/install-nodejs.sh
    fi

    log_success "Development installation completed"
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
    cd "$DOTFILES_DIR"
    IFS=',' read -ra SELECTED <<< "$selections"
    for selection in "${SELECTED[@]}"; do
        selection=$(echo "$selection" | xargs) # trim whitespace
        case $((selection-1)) in
            0) create_core_symlinks ;;
            1) setup_shell_configs ;;
            2) setup_terminal_configs ;;
            3) setup_editor_configs ;;
            4) setup_git_configs ;;
            5) [[ -x "./scripts/install/install-fonts.sh" ]] && ./scripts/install/install-fonts.sh || log_warning "Fonts script not found" ;;
            6) [[ -x "./scripts/install/install-cli-tools.sh" ]] && ./scripts/install/install-cli-tools.sh || log_warning "CLI tools script not found" ;;
            7) [[ -x "./scripts/install/install-dev-tools.sh" ]] && ./scripts/install/install-dev-tools.sh || log_warning "Dev tools script not found" ;;
            8) [[ -x "./scripts/install/install-docker.sh" ]] && ./scripts/install/install-docker.sh || log_warning "Docker script not found" ;;
            9) [[ -x "./scripts/install/install-nodejs.sh" ]] && ./scripts/install/install-nodejs.sh || log_warning "Node.js script not found" ;;
        esac
    done
}

# Helper functions for custom installation
create_core_symlinks() {
    log_info "Creating core configuration symlinks..."
    cd "$DOTFILES_DIR"
    if [[ -x "./scripts/utils/create-symlinks.sh" ]]; then
        ./scripts/utils/create-symlinks.sh
    else
        log_error "Symlinks script not found or not executable"
        return 1
    fi
}

setup_shell_configs() {
    log_info "Setting up shell configurations..."
    # Run common setup which includes Oh My Zsh and plugins
    common_setup
    # Zsh configs are handled by symlinks
    create_core_symlinks
}

setup_terminal_configs() {
    log_info "Setting up terminal configurations..."
    # Terminal configs are handled by symlinks
    create_core_symlinks
}

setup_editor_configs() {
    log_info "Setting up editor configurations..."
    # Editor configs are handled by symlinks
    create_core_symlinks
}

setup_git_configs() {
    log_info "Setting up git configurations..."
    create_core_symlinks
    setup_git_config
}

setup_git_config() {
    if [[ -n "$USER_NAME" ]] && [[ -n "$USER_EMAIL" ]]; then
        log_info "Setting up Git configuration..."

        git config --global user.name "$USER_NAME"
        git config --global user.email "$USER_EMAIL"

        # Copy git template if it doesn't exist
        if [[ -f "$DOTFILES_DIR/templates/.gitconfig.template" ]] && [[ ! -f "$HOME/.gitconfig.local" ]]; then
            cp "$DOTFILES_DIR/templates/.gitconfig.template" "$HOME/.gitconfig.local"
            # Update template with actual values
            sed -i.bak "s/Your Name/$USER_NAME/g" "$HOME/.gitconfig.local"
            sed -i.bak "s/your.email@example.com/$USER_EMAIL/g" "$HOME/.gitconfig.local"
            rm -f "$HOME/.gitconfig.local.bak"
        fi

        log_success "Git configured with name: $USER_NAME, email: $USER_EMAIL"
    fi
}

setup_ssh_keys() {
    if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
        if confirm "Generate SSH key for Git repositories?"; then
            log_info "Generating SSH key..."

            # Use email if provided, otherwise use default
            local email_comment="${USER_EMAIL:-$(whoami)@$(hostname)}"

            # Create .ssh directory if it doesn't exist
            mkdir -p "$HOME/.ssh"
            chmod 700 "$HOME/.ssh"

            ssh-keygen -t ed25519 -C "$email_comment" -f "$HOME/.ssh/id_ed25519" -N ""

            # Start ssh-agent and add key
            eval "$(ssh-agent -s)" >/dev/null 2>&1
            ssh-add "$HOME/.ssh/id_ed25519" >/dev/null 2>&1

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

    # Ensure common setup is complete
    if ! command -v zsh &> /dev/null; then
        log_warning "Zsh not found, running common setup again..."
        common_setup
    fi

    # Set zsh as default shell (skip in CI)
    if [[ "$DOTFILES_CI_MODE" != "true" ]]; then
        set_zsh_default
    fi

    # Source configurations (skip in CI to avoid issues)
    if [[ "$DOTFILES_CI_MODE" != "true" ]] && [[ -f "$HOME/.zshrc" ]]; then
        log_info "Sourcing zsh configuration..."
        zsh -c "source ~/.zshrc" || true
    fi

    # Run health check
    if [[ -x "$DOTFILES_DIR/tools/doctor.sh" ]]; then
        log_info "Running system health check..."
        "$DOTFILES_DIR/tools/doctor.sh" --quiet || true
    fi

    # Clean up temporary files
    cleanup_temp_files
}

cleanup_temp_files() {
    log_info "Cleaning up temporary files..."
    # Remove any temporary files created during installation
    rm -rf /tmp/dotfiles-*
    rm -rf /tmp/install-*
    log_success "Temporary files cleaned up"
}

show_completion_message() {
    if [[ "$DOTFILES_CI_MODE" != "true" ]]; then
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
    fi

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

    if [[ -f "$HOME/.ssh/id_ed25519.pub" ]]; then
        log_info "Your SSH public key (add to Git hosting):"
        echo
        cat "$HOME/.ssh/id_ed25519.pub"
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
