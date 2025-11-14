#!/bin/bash
# Quick bootstrap script for new environments

set -euo pipefail

echo "Bootstrapping dotfiles..."

# Minimal setup for quick start
git clone https://github.com/heinsteinh/dotfile.git ~/.dotfiles
cd ~/.dotfiles
chmod +x install.sh
./install.sh

echo "Bootstrap complete!"
