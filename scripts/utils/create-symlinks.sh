#!/bin/bash
# Create symbolic links for all configurations

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "Creating symbolic links from $DOTFILES_DIR"

# Function to create symlink safely
create_symlink() {
    local source="$1"
    local target="$2"

    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Remove existing file/link
    [[ -e "$target" || -L "$target" ]] && rm -f "$target"

    # Create symlink
    ln -sf "$source" "$target"
    echo "Created: $target -> $source"
}

# Vim
create_symlink "$DOTFILES_DIR/config/vim/.vimrc" "$HOME/.vimrc"

# Tmux
create_symlink "$DOTFILES_DIR/config/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Zsh
create_symlink "$DOTFILES_DIR/config/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/config/zsh/.zprofile" "$HOME/.zprofile"

# Git
create_symlink "$DOTFILES_DIR/config/git/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/config/git/.gitignore_global" "$HOME/.gitignore_global"

# Kitty (if config exists)
if [[ -f "$DOTFILES_DIR/config/kitty/kitty.conf" ]]; then
    create_symlink "$DOTFILES_DIR/config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
fi

echo "Symlinks created successfully!"
