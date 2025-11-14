#!/bin/bash
# Font installation script

set -euo pipefail

echo "Installing Nerd Fonts..."

# Detect OS and set font directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    FONT_DIR="$HOME/Library/Fonts"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    FONT_DIR="$HOME/.local/share/fonts"
fi

mkdir -p "$FONT_DIR"

# Download and install MesloLGS Nerd Font
echo "Installing MesloLGS Nerd Font..."
curl -fLo "$FONT_DIR/MesloLGS NF Regular.ttf" \
    https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf

curl -fLo "$FONT_DIR/MesloLGS NF Bold.ttf" \
    https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf

curl -fLo "$FONT_DIR/MesloLGS NF Italic.ttf" \
    https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf

curl -fLo "$FONT_DIR/MesloLGS NF Bold Italic.ttf" \
    https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

# Refresh font cache on Linux
if command -v fc-cache &> /dev/null; then
    fc-cache -fv
fi

echo "Fonts installed successfully!"
