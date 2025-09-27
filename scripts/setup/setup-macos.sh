#!/bin/bash
# macOS setup script

set -euo pipefail

echo "Setting up macOS environment..."

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install essential packages
brew install \
    git curl wget \
    zsh tmux vim \
    fzf ripgrep fd exa bat \
    htop tree

echo "macOS setup complete!"
