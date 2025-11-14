#!/usr/bin/env bash
# macOS-specific setup script

set -euo pipefail

# Source common setup functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

if [[ -f "$DOTFILES_DIR/scripts/setup/setup-common.sh" ]]; then
    source "$DOTFILES_DIR/scripts/setup/setup-common.sh"
else
    echo "[ERROR] Cannot find setup-common.sh"
    exit 1
fi

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    log_error "This script is designed for macOS systems only"
    exit 1
fi

# Set Homebrew environment variables to prevent cleanup issues and hints
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ENV_HINTS=1

# Install Homebrew
install_homebrew() {
    if ! command_exists brew; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        log_success "Homebrew installed successfully"
    else
        log_info "Homebrew already installed"
    fi
}

# Clean up problematic Homebrew taps
cleanup_homebrew_taps() {
    if command_exists brew; then
        log_info "Cleaning up Homebrew taps..."

        # Fix Homebrew cache permissions
        sudo chown -R "$(whoami)" ~/Library/Caches/Homebrew/ 2>/dev/null || {
            log_warning "Could not fix Homebrew cache permissions, continuing..."
        }

        # Remove old deprecated font tap if it exists
        brew untap homebrew/homebrew-cask-fonts 2>/dev/null || true

        # Update Homebrew
        log_info "Updating Homebrew..."
        brew update 2>/dev/null || log_warning "Homebrew update had issues, continuing..."

        log_success "Homebrew taps cleaned up"
    fi
}

# Install essential packages
install_essential_packages() {
    log_info "Installing essential packages..."

    brew install \
        curl wget git vim neovim \
        ranger zsh tmux tree htop neofetch newsboat \
        unzip coreutils findutils gnu-sed gnu-tar grep

    log_success "Essential packages installed"
}

# Install fonts
install_fonts() {
    log_info "Installing fonts..."

    # Clean up any problematic font taps
    brew untap homebrew/homebrew-cask-fonts 2>/dev/null || true

    # Add correct font tap
    brew tap homebrew/cask-fonts

    # Install programming fonts
    brew install --cask \
        font-fira-code font-fira-code-nerd-font \
        font-jetbrains-mono font-jetbrains-mono-nerd-font \
        font-hack font-hack-nerd-font \
        font-meslo-lg font-meslo-lg-nerd-font \
        font-source-code-pro font-cascadia-code font-cascadia-code-pl

    log_success "Fonts installed"
}

# Install Ghostty terminal
install_ghostty() {
    log_info "Installing Ghostty terminal..."

    if ! command_exists ghostty; then
        brew install --cask ghostty
        log_success "Ghostty installed successfully"
    else
        log_info "Ghostty already installed"
    fi
}

# Configure macOS settings
configure_macos_settings() {
    log_info "Configuring macOS settings..."

    # Dock settings
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock tilesize -int 42
    defaults write com.apple.dock orientation -string "bottom"

    # Finder settings
    defaults write com.apple.finder ShowPathbar -bool true
    defaults write com.apple.finder ShowStatusBar -bool true
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    defaults write com.apple.finder AppleShowAllFiles -bool true
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

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
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

    # Energy settings
    sudo pmset -a displaysleep 10
    sudo pmset -a disksleep 10
    sudo pmset -a sleep 30
    sudo pmset -a sms 0

    # Developer settings
    defaults write com.apple.LaunchServices LSQuarantine -bool false
    defaults write com.apple.finder QLEnableTextSelection -bool true
    chflags nohidden ~/Library
    sudo chflags nohidden /Volumes

    # Terminal settings
    defaults write com.apple.terminal StringEncodings -array 4
    defaults write com.apple.terminal "Default Window Settings" -string "Pro"
    defaults write com.apple.terminal "Startup Window Settings" -string "Pro"

    # Menu bar settings
    defaults write com.apple.menuextra.battery ShowPercent -string "YES"

    # Window resize speed
    defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

    # Hot corners - bottom right to show desktop
    defaults write com.apple.dock wvous-br-corner -int 4
    defaults write com.apple.dock wvous-br-modifier -int 0

    log_success "macOS settings configured"
}

# Main function
main() {
    log_info "Starting macOS-specific setup..."

    # Core installation
    cleanup_homebrew_taps
    install_homebrew
    install_essential_packages

    # Install modern CLI tools (using common function)
    install_modern_cli_tools

    # Shell setup (using common functions)
    common_setup

    # Optional installations based on flags
    if [[ "${1:-}" == "--full" ]] || [[ "${INSTALL_TYPE:-}" == "full" ]]; then
        install_nodejs
        install_docker
        install_fonts
        install_ghostty
    elif [[ "${1:-}" == "--dev" ]]; then
        install_nodejs
        install_docker
    elif [[ "${1:-}" == "--fonts" ]]; then
        install_fonts
    elif [[ "${1:-}" == "--ghostty" ]]; then
        install_ghostty
    fi

    # Configuration
    configure_macos_settings

    # Cleanup
    log_info "Cleaning up..."
    brew cleanup
    brew autoremove

    log_success "macOS setup completed successfully!"
    log_info "Please run 'source ~/.zshrc' or restart your terminal to apply changes"

    # Restart required services
    log_info "Restarting Dock and Finder to apply settings..."
    killall Dock
    killall Finder
}

# Run main function with all arguments
main "$@"
