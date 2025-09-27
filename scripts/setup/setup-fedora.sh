#!/usr/bin/env bash
# Fedora-specific setup script

set -euo pipefail

# Colors and logging functions
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

main() {
    log_info "Setting up Fedora-specific configurations..."

    # Update system
    log_info "Updating system packages..."
    sudo dnf update -y

    # Install RPM Fusion repositories
    sudo dnf install -y \
        https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
        https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

    # Install essential packages
    log_info "Installing essential packages..."
    sudo dnf install -y \
        curl wget git vim zsh tmux tree htop neofetch unzip \
        ripgrep fd-find bat exa fzf starship

    # Install development tools
    sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y python3 python3-pip nodejs npm golang rust cargo

    # Set zsh as default shell
    if [[ "$SHELL" != */zsh ]]; then
        chsh -s "$(which zsh)"
    fi

    log_success "Fedora setup completed!"
}

main "$@"