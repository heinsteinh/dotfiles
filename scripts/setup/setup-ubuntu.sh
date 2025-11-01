#!/usr/bin/env bash
# Ubuntu/Debian-specific setup script

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

# Check if running on Ubuntu/Debian
is_ubuntu_or_debian() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        [[ "$ID" == "ubuntu" || "$ID" == "debian" ]] && return 0
    fi

    # Fallback to lsb_release if available
    if command_exists lsb_release; then
        local distro=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
        [[ "$distro" == "ubuntu" || "$distro" == "debian" ]] && return 0
    fi

    # Check /etc/issue as another fallback
    if [[ -f /etc/issue ]] && grep -qiE 'ubuntu|debian' /etc/issue; then
        return 0
    fi

    # Check if we're in a Ubuntu/Debian container (CI environment)
    if [[ "${CI:-}" == "true" ]] && [[ -f /etc/debian_version ]]; then
        log_info "Detected Ubuntu/Debian-based container in CI environment"
        return 0
    fi

    return 1
}

if ! is_ubuntu_or_debian; then
    log_error "This script is designed for Ubuntu/Debian systems only"
    exit 1
fi

# Install Ghostty terminal (build from source)
install_ghostty() {
    log_info "Installing Ghostty terminal from source..."

    # Skip in CI environment (too complex and time-consuming)
    if [[ "${CI:-}" == "true" ]]; then
        log_info "CI environment detected, skipping Ghostty build from source"
        return
    fi

    if command_exists ghostty; then
        log_info "Ghostty already installed"
        return
    fi

    # Install dependencies
    log_info "Installing Ghostty build dependencies..."
    sudo apt install -y \
        libgtk-4-dev \
        libadwaita-1-dev \
        gettext \
        libxml2-utils

    # Check for Zig compiler
    if ! command_exists zig; then
        log_warning "Zig compiler not found. Ghostty requires Zig 0.13 or 0.14."
        log_warning "Please install Zig from https://ziglang.org/download/ and re-run this script."
        log_warning "Skipping Ghostty installation for now."
        return
    fi

    # Verify Zig version (should be 0.13 or 0.14)
    local zig_version=$(zig version 2>/dev/null || echo "unknown")
    log_info "Found Zig version: $zig_version"

    # Build Ghostty
    log_info "Cloning and building Ghostty (this may take a while)..."
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    if git clone https://github.com/ghostty-org/ghostty.git; then
        cd ghostty

        # Ubuntu 24.04/Debian 12 specific build flag
        local build_flags="-Doptimize=ReleaseFast -p $HOME/.local"
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            if [[ "$VERSION_ID" == "24.04" ]] || [[ "$VERSION_ID" =~ ^12 ]]; then
                log_info "Detected Ubuntu 24.04 or Debian 12, using special build flags..."
                build_flags="$build_flags -fno-sys=gtk4-layer-shell"
            fi
        fi

        # Build with timeout (max 15 minutes)
        if timeout 900 zig build $build_flags; then
            log_success "Ghostty built and installed to ~/.local/bin/"

            # Ensure ~/.local/bin is in PATH
            if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
                log_info "Adding ~/.local/bin to PATH in .zshrc"
                echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
            fi
        else
            log_error "Ghostty build failed or timed out"
            cd "$HOME"
            rm -rf "$temp_dir"
            return 1
        fi
    else
        log_error "Failed to clone Ghostty repository"
        cd "$HOME"
        rm -rf "$temp_dir"
        return 1
    fi

    # Cleanup
    cd "$HOME"
    rm -rf "$temp_dir"
    log_success "Ghostty installation completed"
}

main() {
    log_info "Setting up Ubuntu/Debian-specific configurations..."

    # Update package lists
    log_info "Updating package lists..."
    sudo apt update -qq

    # Install essential packages
    log_info "Installing essential packages..."
    sudo apt install -y -qq \
        curl wget git vim neovim \
        ranger zsh tmux tree htop unzip \
        software-properties-common apt-transport-https \
        ca-certificates gnupg lsb-release

    # Install optional packages (don't fail if unavailable)
    sudo apt install -y -qq newsboat 2>/dev/null || log_warning "newsboat not available, skipping..."

    # Install modern CLI tools (using common function)
    install_modern_cli_tools

    # Install Node.js (using common function)
    install_nodejs

    # Install Docker (using common function)
    install_docker

    # Install Rust (skip in CI)
    if [[ "${CI:-}" != "true" ]] && ! command_exists cargo; then
        log_info "Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        # shellcheck source=/dev/null
        [[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
    fi

    # Install development tools (minimal in CI)
    if [[ "${CI:-}" == "true" ]]; then
        sudo apt install -y -qq \
            build-essential python3 python3-pip || log_warning "Some development tools failed to install"
    else
        sudo apt install -y -qq \
            build-essential python3 python3-pip \
            golang-go default-jdk || log_warning "Some development tools failed to install"
    fi

    # Run common setup (Zsh, Oh My Zsh, plugins, Starship)
    common_setup

    # Optional installations based on flags
    if [[ "${1:-}" == "--ghostty" ]] || [[ "${1:-}" == "--full" ]]; then
        install_ghostty
    fi

    # Clean up
    log_info "Cleaning up..."
    sudo apt autoremove -y -qq
    sudo apt autoclean -qq

    log_success "Ubuntu/Debian setup completed successfully!"
    log_info "Please run 'source ~/.zshrc' or restart your terminal to apply changes"
}

main "$@"
