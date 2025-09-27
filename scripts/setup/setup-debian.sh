#!/usr/bin/env bash
# Debian-specific setup script

set -euo pipefail

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

main() {
    log_info "Setting up Debian-specific configurations..."

    # Update package lists
    log_info "Updating package lists..."
    sudo apt update

    # Install essential packages
    log_info "Installing essential packages..."
    sudo apt install -y \
        curl wget git vim zsh tmux tree htop neofetch unzip \
        software-properties-common apt-transport-https ca-certificates gnupg

    # Install backports if needed
    if ! grep -q "bullseye-backports" /etc/apt/sources.list.d/* 2>/dev/null; then
        echo "deb http://deb.debian.org/debian bullseye-backports main" | sudo tee /etc/apt/sources.list.d/backports.list
        sudo apt update
    fi

    # Install modern CLI tools from backports
    sudo apt install -y -t bullseye-backports ripgrep fd-find || sudo apt install -y ripgrep fd-find

    # Set zsh as default shell
    if [[ "$SHELL" != */zsh ]]; then
        chsh -s "$(which zsh)"
    fi

    log_success "Debian setup completed!"
}

main "$@"
