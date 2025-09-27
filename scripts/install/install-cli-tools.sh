#!/bin/bash
# Install additional CLI tools

echo "Installing additional CLI tools..."

# Detect package manager
if command -v pacman &> /dev/null; then
    # Arch Linux
    sudo pacman -S --needed --noconfirm \
        ranger \
        docker docker-compose \
        httpie \
        jq \
        nmap \
        tldr

    yay -S --noconfirm \
        thefuck \
        neofetch

elif command -v brew &> /dev/null; then
    # macOS
    brew install \
        ranger \
        docker docker-compose \
        httpie \
        jq \
        nmap \
        tldr \
        thefuck \
        neofetch

elif command -v apt &> /dev/null; then
    # Debian/Ubuntu
    sudo apt update
    sudo apt install -y \
        ranger \
        docker.io docker-compose \
        httpie \
        jq \
        nmap \
        tldr \
        neofetch
fi

# Install global npm packages
npm install -g \
    http-server \
    json-server \
    live-server \
    nodemon

# Install Python packages (user-level to avoid system package conflicts)
pip3 install --user \
    httpie \
    youtube-dl \
    speedtest-cli \
    howdoi

echo "CLI tools installation complete!"
