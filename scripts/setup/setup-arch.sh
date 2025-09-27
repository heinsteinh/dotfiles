#!/bin/bash
# Arch Linux setup script

set -euo pipefail

echo "Setting up Arch Linux environment..."

# Update system
sudo pacman -Syu --noconfirm

# Install essential packages
sudo pacman -S --needed --noconfirm \
    base-devel git curl wget \
    zsh tmux vim \
    fzf ripgrep fd exa bat \
    htop tree unzip

echo "Arch Linux setup complete!"
