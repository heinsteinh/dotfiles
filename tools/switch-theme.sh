#!/usr/bin/env bash
# Theme Switcher for Dotfiles
# Switches between different color themes across all CLI tools

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONFIG_DIR="$DOTFILES_DIR/config"

# Available themes
THEMES=("atom-dark" "gruvbox" "nord" "dracula")

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Show usage
show_usage() {
    cat << EOF
Usage: $(basename "$0") [THEME]

Switch between different color themes across all CLI tools.

Available themes:
  atom-dark  - Atom One Dark theme (current default)
  gruvbox    - Gruvbox dark theme
  nord       - Nord theme
  dracula    - Dracula theme

Examples:
  $(basename "$0") atom-dark    # Switch to Atom Dark theme
  $(basename "$0") gruvbox      # Switch to Gruvbox theme
  $(basename "$0")              # Show current theme and available options

Affected applications:
  - Kitty terminal
  - Tmux status bar
  - Vim/Neovim
  - FZF fuzzy finder
  - Bat syntax highlighter

Note: Some changes require restarting applications to take effect.
EOF
}

# Get current theme
get_current_theme() {
    # Check Kitty config for current theme
    if [[ -f "$CONFIG_DIR/kitty/kitty.conf" ]]; then
        local kitty_theme
        kitty_theme=$(grep "^include themes/" "$CONFIG_DIR/kitty/kitty.conf" | head -1 | sed 's/include themes\/\(.*\)\.conf/\1/')
        echo "$kitty_theme"
    else
        echo "unknown"
    fi
}

# Switch Kitty theme
switch_kitty() {
    local theme="$1"
    local kitty_conf="$CONFIG_DIR/kitty/kitty.conf"

    log_info "Switching Kitty terminal theme to $theme..."

    if [[ ! -f "$kitty_conf" ]]; then
        log_error "Kitty config not found: $kitty_conf"
        return 1
    fi

    # Update include statement
    sed -i.bak "s|^include themes/.*\.conf|include themes/${theme}.conf|" "$kitty_conf"
    sed -i.bak "s|^#include themes/${theme}\.conf|include themes/${theme}.conf|" "$kitty_conf"

    # Comment out other theme includes
    for t in "${THEMES[@]}"; do
        if [[ "$t" != "$theme" ]]; then
            sed -i.bak "s|^include themes/${t}\.conf|#include themes/${t}.conf|" "$kitty_conf"
        fi
    done

    rm -f "$kitty_conf.bak"
    log_success "Kitty theme updated"
}

# Switch Tmux theme
switch_tmux() {
    local theme="$1"
    local tmux_conf="$CONFIG_DIR/tmux/.tmux.conf"

    log_info "Switching Tmux theme to $theme..."

    if [[ ! -f "$tmux_conf" ]]; then
        log_error "Tmux config not found: $tmux_conf"
        return 1
    fi

    case "$theme" in
        atom-dark)
            # Atom Dark colors
            sed -i.bak 's|^# Colors.*|# Colors (Atom Dark theme)|' "$tmux_conf"
            sed -i.bak 's|^set -g status-bg .*|set -g status-bg "#282c34"        # ATOM_BG|' "$tmux_conf"
            sed -i.bak 's|^set -g status-fg .*|set -g status-fg "#abb2bf"        # ATOM_FG|' "$tmux_conf"
            ;;
        gruvbox)
            # Gruvbox colors
            sed -i.bak 's|^# Colors.*|# Colors (Gruvbox theme)|' "$tmux_conf"
            sed -i.bak 's|^set -g status-bg .*|set -g status-bg "#282828"|' "$tmux_conf"
            sed -i.bak 's|^set -g status-fg .*|set -g status-fg "#ebdbb2"|' "$tmux_conf"
            ;;
        nord)
            # Nord colors
            sed -i.bak 's|^# Colors.*|# Colors (Nord theme)|' "$tmux_conf"
            sed -i.bak 's|^set -g status-bg .*|set -g status-bg "#2e3440"|' "$tmux_conf"
            sed -i.bak 's|^set -g status-fg .*|set -g status-fg "#eceff4"|' "$tmux_conf"
            ;;
        dracula)
            # Dracula colors
            sed -i.bak 's|^# Colors.*|# Colors (Dracula theme)|' "$tmux_conf"
            sed -i.bak 's|^set -g status-bg .*|set -g status-bg "#282a36"|' "$tmux_conf"
            sed -i.bak 's|^set -g status-fg .*|set -g status-fg "#f8f8f2"|' "$tmux_conf"
            ;;
    esac

    rm -f "$tmux_conf.bak"
    log_success "Tmux theme updated (reload with 'tmux source ~/.tmux.conf')"
}

# Switch Vim theme
switch_vim() {
    local theme="$1"
    local vimrc="$CONFIG_DIR/vim/.vimrc"

    log_info "Switching Vim theme to $theme..."

    if [[ ! -f "$vimrc" ]]; then
        log_error "Vim config not found: $vimrc"
        return 1
    fi

    case "$theme" in
        atom-dark)
            sed -i.bak 's|^colorscheme .*|colorscheme onedark|' "$vimrc"
            sed -i.bak "s|^let g:airline_theme = .*|let g:airline_theme = 'onedark'|" "$vimrc"
            ;;
        gruvbox)
            sed -i.bak 's|^colorscheme .*|colorscheme gruvbox|' "$vimrc"
            sed -i.bak "s|^let g:airline_theme = .*|let g:airline_theme = 'gruvbox'|" "$vimrc"
            ;;
        nord)
            sed -i.bak 's|^colorscheme .*|colorscheme nord|' "$vimrc"
            sed -i.bak "s|^let g:airline_theme = .*|let g:airline_theme = 'nord'|" "$vimrc"
            ;;
        dracula)
            sed -i.bak 's|^colorscheme .*|colorscheme dracula|' "$vimrc"
            sed -i.bak "s|^let g:airline_theme = .*|let g:airline_theme = 'dracula'|" "$vimrc"
            ;;
    esac

    rm -f "$vimrc.bak"
    log_success "Vim theme updated"
}

# Switch Neovim theme
switch_neovim() {
    local theme="$1"
    local nvim_plugins="$CONFIG_DIR/nvim/lua/plugins/init.lua"

    log_info "Switching Neovim theme to $theme..."

    if [[ ! -f "$nvim_plugins" ]]; then
        log_error "Neovim plugins config not found: $nvim_plugins"
        return 1
    fi

    case "$theme" in
        atom-dark)
            sed -i.bak 's|theme = ".*"|theme = "onedark"|' "$nvim_plugins"
            ;;
        gruvbox)
            sed -i.bak 's|theme = ".*"|theme = "gruvbox"|' "$nvim_plugins"
            ;;
        nord)
            sed -i.bak 's|theme = ".*"|theme = "nord"|' "$nvim_plugins"
            ;;
        dracula)
            sed -i.bak 's|theme = ".*"|theme = "dracula"|' "$nvim_plugins"
            ;;
    esac

    rm -f "$nvim_plugins.bak"
    log_success "Neovim theme updated"
}

# Switch bat theme
switch_bat() {
    local theme="$1"
    local bat_config="$HOME/.config/bat/config"

    log_info "Switching bat theme to $theme..."

    if [[ ! -f "$bat_config" ]]; then
        log_error "Bat config not found: $bat_config"
        return 1
    fi

    case "$theme" in
        atom-dark)
            sed -i.bak 's|^--theme=.*|--theme="OneHalfDark"|' "$bat_config"
            ;;
        gruvbox)
            sed -i.bak 's|^--theme=.*|--theme="gruvbox-dark"|' "$bat_config"
            ;;
        nord)
            sed -i.bak 's|^--theme=.*|--theme="Nord"|' "$bat_config"
            ;;
        dracula)
            sed -i.bak 's|^--theme=.*|--theme="Dracula"|' "$bat_config"
            ;;
    esac

    rm -f "$bat_config.bak"
    log_success "Bat theme updated"
}

# Main function
main() {
    # Show usage if no arguments
    if [[ $# -eq 0 ]]; then
        current_theme=$(get_current_theme)
        log_info "Current theme: $current_theme"
        echo ""
        show_usage
        exit 0
    fi

    local theme="$1"

    # Show help
    if [[ "$theme" == "-h" ]] || [[ "$theme" == "--help" ]]; then
        show_usage
        exit 0
    fi

    # Validate theme
    if [[ ! " ${THEMES[@]} " =~ " ${theme} " ]]; then
        log_error "Invalid theme: $theme"
        echo ""
        log_info "Available themes: ${THEMES[*]}"
        exit 1
    fi

    log_info "Switching to $theme theme..."
    echo ""

    # Switch all applications
    switch_kitty "$theme"
    switch_tmux "$theme"
    switch_vim "$theme"
    switch_neovim "$theme"
    switch_bat "$theme"

    echo ""
    log_success "Theme switched to $theme successfully!"
    echo ""
    log_warning "Note: Restart or reload applications for changes to take effect:"
    echo "  - Kitty: Restart terminal or use Ctrl+Shift+F5"
    echo "  - Tmux: Run 'tmux source ~/.tmux.conf' or prefix + r"
    echo "  - Vim: Restart or run ':source \$MYVIMRC'"
    echo "  - Neovim: Restart or run ':Lazy sync'"
    echo "  - FZF: Source zshrc or start new shell"
}

main "$@"
