#!/bin/bash
# CLI tools installation script

set -euo pipefail

echo "Installing additional CLI tools..."

# Detect package manager and install tools
if command -v pacman &> /dev/null; then
    # Arch Linux
    sudo pacman -S --needed --noconfirm \
        neofetch lazygit bottom starship
elif command -v apt &> /dev/null; then
    # Ubuntu/Debian
    sudo apt update
    sudo apt install -y neofetch
elif command -v brew &> /dev/null; then
    # macOS
    brew install neofetch lazygit bottom starship
fi

echo "CLI tools installation complete!"
