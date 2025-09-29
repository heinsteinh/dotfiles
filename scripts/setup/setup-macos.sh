#!/usr/bin/env bash
# macOS-specific setup script

set -euo pipefail

# Source common setup functions for colors and logging
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

if [[ -f "$DOTFILES_DIR/scripts/setup/setup-common.sh" ]]; then
    source "$DOTFILES_DIR/scripts/setup/setup-common.sh"
fi

# Additional logging functions if not defined
if ! declare -f log_info > /dev/null 2>&1; then
    log_info() { echo "[INFO] $1"; }
fi

if ! declare -f log_success > /dev/null 2>&1; then
    log_success() { echo "[SUCCESS] $1"; }
fi

if ! declare -f log_warning > /dev/null 2>&1; then
    log_warning() { echo "[WARNING] $1"; }
fi

if ! declare -f log_error > /dev/null 2>&1; then
    log_error() { echo "[ERROR] $1"; }
fi

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    log_error "This script is designed for macOS systems only"
    exit 1
fi

# Install Homebrew
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        log_success "Homebrew installed successfully"
    else
        log_info "Homebrew already installed, updating..."
        brew update
    fi
}

# Install essential packages
install_essential_packages() {
    log_info "Installing essential packages..."

    # Core utilities
    brew install \
        curl \
        wget \
        git \
        vim \
        ranger \
        zsh \
        tmux \
        tree \
        htop \
        neofetch \
        unzip \
        coreutils \
        findutils \
        gnu-sed \
        gnu-tar \
        grep

    log_success "Essential packages installed"
}

# Install modern CLI tools
install_modern_cli_tools() {
    log_info "Installing modern CLI tools..."

    brew install \
        ripgrep \
        fd \
        bat \
        eza \
        fzf \
        jq \
        yq \
        lazygit \
        lazydocker \
        bottom \
        procs \
        dust \
        tokei \
        hyperfine \
        bandwhich \
        gping

    log_success "Modern CLI tools installed"
}

# Install development tools
install_development_tools() {
    log_info "Installing development tools..."

    # Programming languages and tools
    brew install \
        python@3.11 \
        python@3.12 \
        node \
        go \
        rust \
        openjdk \
        maven \
        gradle

    # Development utilities
    brew install \
        docker \
        docker-compose \
        kubernetes-cli \
        helm \
        terraform \
        ansible \
        vault \
        consul \
        nomad

    log_success "Development tools installed"
}

# Install GUI applications
install_gui_applications() {
    log_info "Installing GUI applications..."

    # Install essential cask applications
    brew install --cask \
        iterm2 \
        visual-studio-code \
        firefox \
        google-chrome \
        slack \
        discord \
        zoom \
        docker \
        postman \
        tableplus \
        rectangle \
        alfred \
        raycast \
        cleanmymac \
        the-unarchiver \
        appcleaner \
        keka \
        vlc \
        spotify

    log_success "GUI applications installed"
}

# Install fonts
install_fonts() {
    log_info "Installing fonts..."

    # Add font tap
    brew tap homebrew/cask-fonts

    # Install programming fonts
    brew install --cask \
        font-fira-code \
        font-fira-code-nerd-font \
        font-jetbrains-mono \
        font-jetbrains-mono-nerd-font \
        font-hack \
        font-hack-nerd-font \
        font-meslo-lg \
        font-meslo-lg-nerd-font \
        font-source-code-pro \
        font-cascadia-code \
        font-cascadia-code-pl

    log_success "Fonts installed"
}

# Configure macOS settings
configure_macos_settings() {
    log_info "Configuring macOS settings..."

    # Dock settings
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock tilesize -int 48
    defaults write com.apple.dock orientation -string "bottom"

    # Finder settings
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Screenshot settings
    defaults write com.apple.screencapture location -string "$HOME/Desktop/Screenshots"
    defaults write com.apple.screencapture type -string "png"
    defaults write com.apple.screencapture disable-shadow -bool true

    # Trackpad settings
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

    # Keyboard settings
    defaults write NSGlobalDomain KeyRepeat -int 2
    defaults write NSGlobalDomain InitialKeyRepeat -int 15

    # Energy saving
    sudo pmset -a displaytimeout 10
    sudo pmset -a disksleep 10
    sudo pmset -a sleep 30

    log_success "macOS settings configured"
}

# Install Starship prompt
install_starship() {
    if ! command -v starship &> /dev/null; then
        log_info "Installing Starship prompt..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        log_success "Starship prompt installed"
    else
        log_info "Starship prompt already installed"
    fi
}

# Set zsh as default shell
set_zsh_default() {
    if [[ "$SHELL" != */zsh ]]; then
        log_info "Setting zsh as default shell..."
        chsh -s "$(which zsh)"
        log_warning "Please restart your terminal for shell change to take effect"
    else
        log_info "Zsh is already the default shell"
    fi
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        log_info "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "Oh My Zsh installed"
    else
        log_info "Oh My Zsh already installed"
    fi
}

# Install Zsh plugins
install_zsh_plugins() {
    log_info "Installing Zsh plugins..."
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions
    if [[ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]]; then
        log_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
    fi

    # zsh-syntax-highlighting
    if [[ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$zsh_custom/plugins/zsh-syntax-highlighting"
    fi

    # zsh-fast-syntax-highlighting
    if [[ ! -d "$zsh_custom/plugins/fast-syntax-highlighting" ]]; then
        log_info "Installing zsh-fast-syntax-highlighting..."
        git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git "$zsh_custom/plugins/fast-syntax-highlighting"
    fi

    # zsh-autocomplete
    if [[ ! -d "$zsh_custom/plugins/zsh-autocomplete" ]]; then
        log_info "Installing zsh-autocomplete..."
        git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git "$zsh_custom/plugins/zsh-autocomplete"
    fi

    log_success "Zsh plugins installed"
}

# Cleanup
cleanup() {
    log_info "Cleaning up..."
    brew cleanup
    brew autoremove
    log_success "Cleanup completed"
}

# Main function
main() {
    log_info "Starting macOS-specific setup..."

    # Core installation
    install_homebrew
    install_essential_packages
    install_modern_cli_tools

    # Shell setup
    install_starship
    set_zsh_default
    install_oh_my_zsh
    install_zsh_plugins

    # Optional installations (ask user)
    if [[ "${1:-}" == "--full" ]] || [[ "${INSTALL_TYPE:-}" == "development" ]]; then
        install_development_tools
        install_gui_applications
        install_fonts
    elif [[ "${1:-}" == "--dev" ]]; then
        install_development_tools
    elif [[ "${1:-}" == "--gui" ]]; then
        install_gui_applications
        install_fonts
    fi

    # Configuration
    configure_macos_settings

    # Cleanup
    cleanup

    log_success "macOS setup completed successfully!"
    log_info "Please run 'source ~/.zshrc' or restart your terminal to apply changes"

    # Restart required services
    log_info "Restarting Dock and Finder to apply settings..."
    killall Dock
    killall Finder
}

# Run main function with all arguments
main "$@"
