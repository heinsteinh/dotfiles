#!/bin/bash
# Test installation process

set -euo pipefail

echo "Testing installation..."

# Test symlinks
test_symlinks() {
    echo "Testing symlinks..."

    [[ -L ~/.vimrc ]] || { echo "ERROR: .vimrc symlink not found"; exit 1; }
    [[ -L ~/.zshrc ]] || { echo "ERROR: .zshrc symlink not found"; exit 1; }
    [[ -L ~/.tmux.conf ]] || { echo "ERROR: .tmux.conf symlink not found"; exit 1; }

    echo "✓ Symlinks test passed"
}

# Test configurations
test_configs() {
    echo "Testing configurations..."

    # Test vim config
    vim --version &> /dev/null || { echo "ERROR: vim not installed"; exit 1; }

    # Test zsh config
    zsh -n ~/.zshrc || { echo "ERROR: zsh config invalid"; exit 1; }

    # Test tmux config
    tmux -f ~/.tmux.conf list-keys &> /dev/null || { echo "ERROR: tmux config invalid"; exit 1; }

    echo "✓ Configurations test passed"
}

test_symlinks
test_configs

echo "All tests passed!"
