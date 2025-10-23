#!/bin/bash
# Create symbolic links for all configurations

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo "Creating symbolic links from $DOTFILES_DIR"

# Environment detection
if [[ "${CI:-}" == "true" ]]; then
    echo "CI environment detected - creating symlinks for testing"
fi

if [[ "${DOTFILES_SKIP_INTERACTIVE:-}" == "true" ]]; then
    echo "Non-interactive mode - skipping user prompts"
fi

# Function to create symlink safely
create_symlink() {
    local source="$1"
    local target="$2"

    # Check if source exists
    if [[ ! -e "$source" ]]; then
        echo "Warning: Source file does not exist: $source"
        return 1
    fi

    # Create target directory if it doesn't exist
    mkdir -p "$(dirname "$target")"

    # Remove existing file/link
    [[ -e "$target" || -L "$target" ]] && rm -f "$target"

    # Create symlink
    if ln -sf "$source" "$target"; then
        echo "Created: $target -> $source"
    else
        echo "Error: Failed to create symlink: $target -> $source"
        return 1
    fi
}

# Vim
create_symlink "$DOTFILES_DIR/config/vim/.vimrc" "$HOME/.vimrc"

# Neovim
if [[ -d "$DOTFILES_DIR/config/nvim" ]]; then
    create_symlink "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"
fi

# Tmux
create_symlink "$DOTFILES_DIR/config/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Zsh
create_symlink "$DOTFILES_DIR/config/zsh/.zshrc" "$HOME/.zshrc"
create_symlink "$DOTFILES_DIR/config/zsh/.zprofile" "$HOME/.zprofile"

# Zsh modular configuration files
create_symlink "$DOTFILES_DIR/config/zsh/aliases.zsh" "$HOME/.config/zsh/aliases.zsh"
create_symlink "$DOTFILES_DIR/config/zsh/functions.zsh" "$HOME/.config/zsh/functions.zsh"
create_symlink "$DOTFILES_DIR/config/zsh/exports.zsh" "$HOME/.config/zsh/exports.zsh"
create_symlink "$DOTFILES_DIR/config/zsh/distro.zsh" "$HOME/.config/zsh/distro.zsh"

# FZF configuration
if [[ -f "$DOTFILES_DIR/config/fzf/fzf.zsh" ]]; then
    create_symlink "$DOTFILES_DIR/config/fzf/fzf.zsh" "$HOME/.fzf.zsh"
fi

# Git
create_symlink "$DOTFILES_DIR/config/git/.gitconfig" "$HOME/.gitconfig"
create_symlink "$DOTFILES_DIR/config/git/.gitignore_global" "$HOME/.gitignore_global"

# Kitty (if config exists)
if [[ -f "$DOTFILES_DIR/config/kitty/kitty.conf" ]]; then
    create_symlink "$DOTFILES_DIR/config/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

    # Kitty themes
    if [[ -d "$DOTFILES_DIR/config/kitty/themes" ]]; then
        create_symlink "$DOTFILES_DIR/config/kitty/themes" "$HOME/.config/kitty/themes"
    fi

    # Kitty sessions
    if [[ -d "$DOTFILES_DIR/config/kitty/sessions" ]]; then
        create_symlink "$DOTFILES_DIR/config/kitty/sessions" "$HOME/.config/kitty/sessions"
    fi

    # Create local.conf from example if it doesn't exist
    if [[ ! -f "$HOME/.config/kitty/local.conf" && -f "$DOTFILES_DIR/config/kitty/local.conf.example" ]]; then
        cp "$DOTFILES_DIR/config/kitty/local.conf.example" "$HOME/.config/kitty/local.conf"
        echo "Created: $HOME/.config/kitty/local.conf from example"
    fi
fi

# Starship configuration
if [[ -f "$DOTFILES_DIR/config/starship/starship.toml" ]]; then
    create_symlink "$DOTFILES_DIR/config/starship/starship.toml" "$HOME/.config/starship.toml"
fi

# Bat configuration
if [[ -f "$DOTFILES_DIR/config/bat/config" ]]; then
    create_symlink "$DOTFILES_DIR/config/bat/config" "$HOME/.config/bat/config"
fi

# Ranger configuration
if [[ -d "$DOTFILES_DIR/config/ranger" ]]; then
    create_symlink "$DOTFILES_DIR/config/ranger/rc.conf" "$HOME/.config/ranger/rc.conf"
    create_symlink "$DOTFILES_DIR/config/ranger/rifle.conf" "$HOME/.config/ranger/rifle.conf"
    create_symlink "$DOTFILES_DIR/config/ranger/scope.sh" "$HOME/.config/ranger/scope.sh"

    # Ranger colorschemes
    if [[ -d "$DOTFILES_DIR/config/ranger/colorschemes" ]]; then
        create_symlink "$DOTFILES_DIR/config/ranger/colorschemes" "$HOME/.config/ranger/colorschemes"
    fi
fi


# Newsboat configuration
if [[ -f "$DOTFILES_DIR/config/newsboat/config" ]]; then
    create_symlink "$DOTFILES_DIR/config/newsboat/config" "$HOME/.config/newsboat/config"
fi

if [[ -f "$DOTFILES_DIR/config/newsboat/urls" ]]; then
    create_symlink "$DOTFILES_DIR/config/newsboat/urls" "$HOME/.config/newsboat/urls"
fi

# Okular configuration (PDF viewer with Vim-like keybindings)
if [[ -f "$DOTFILES_DIR/config/okular/okularrc" ]]; then
    create_symlink "$DOTFILES_DIR/config/okular/okularrc" "$HOME/.config/okularrc"
fi

# Okular keybindings (KDE XML format)
if [[ -f "$DOTFILES_DIR/config/okular/part.rc" ]]; then
    mkdir -p "$HOME/.local/share/kxmlgui5/okular"
    create_symlink "$DOTFILES_DIR/config/okular/part.rc" "$HOME/.local/share/kxmlgui5/okular/part.rc"
fi

if [[ -f "$DOTFILES_DIR/config/okular/shell.rc" ]]; then
    mkdir -p "$HOME/.local/share/kxmlgui5/okular"
    create_symlink "$DOTFILES_DIR/config/okular/shell.rc" "$HOME/.local/share/kxmlgui5/okular/shell.rc"
fi

echo "Symlinks created successfully!"
