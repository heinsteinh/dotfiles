# Theming Guide

Comprehensive guide for managing color themes across all CLI applications in this dotfiles system.

## Table of Contents

- [Overview](#overview)
- [Available Themes](#available-themes)
- [Current Theme](#current-theme)
- [Quick Theme Switching](#quick-theme-switching)
- [Affected Applications](#affected-applications)
- [Theme Architecture](#theme-architecture)
- [Adding a New Theme](#adding-a-new-theme)
- [Manual Theme Configuration](#manual-theme-configuration)
- [Troubleshooting](#troubleshooting)

## Overview

This dotfiles system uses **Atom Dark** as the default theme across all CLI applications for a consistent visual experience. All applications share the same color palette defined in `config/themes/atom-dark.sh`.

## Available Themes

| Theme       | Description                              | Status   |
|-------------|------------------------------------------|----------|
| `atom-dark` | Atom One Dark theme (default)            | ✅ Active |
| `gruvbox`   | Gruvbox dark theme                       | ⏳ Ready  |
| `nord`      | Nord theme                               | ⏳ Ready  |
| `dracula`   | Dracula theme                            | ⏳ Ready  |

## Current Theme

The current theme is **Atom Dark** across:

- ✅ Kitty terminal
- ✅ Tmux status bar
- ✅ Vim/Neovim
- ✅ FZF fuzzy finder
- ✅ Bat syntax highlighter

## Quick Theme Switching

### Using the Theme Switcher Script

The easiest way to switch themes is using the built-in theme switcher:

```bash
# Show current theme and available options
theme

# Switch to a specific theme
theme atom-dark
theme gruvbox
theme nord
theme dracula

# Or use the full command
theme-switch atom-dark
```

### What the Theme Switcher Does

The `theme` command automatically updates configuration for:

1. **Kitty** - Updates theme include in `config/kitty/kitty.conf`
2. **Tmux** - Changes status bar colors in `config/tmux/.tmux.conf`
3. **Vim** - Updates colorscheme and airline theme in `config/vim/.vimrc`
4. **Neovim** - Changes colorscheme and lualine theme in `config/nvim/lua/plugins/init.lua`
5. **Bat** - Updates syntax highlighting theme in `~/.config/bat/config`

### Applying Theme Changes

After switching themes, reload applications:

```bash
# Kitty: Restart terminal or press
Ctrl+Shift+F5

# Tmux: Reload configuration
tmux source ~/.tmux.conf
# Or press: prefix + r (Ctrl+a r)

# Vim: Reload vimrc
:source $MYVIMRC

# Neovim: Sync plugins
:Lazy sync

# FZF: Reload shell
source ~/.zshrc
# Or start a new shell
```

## Affected Applications

### Kitty Terminal

**Configuration:** `config/kitty/kitty.conf`
**Theme files:** `config/kitty/themes/*.conf`

Kitty themes define:
- Foreground/background colors
- ANSI color palette (16 colors)
- Selection colors
- Cursor colors
- Border colors
- Tab bar colors

**Quick theme switch in Kitty:**
- F1: Atom Dark
- F2: Gruvbox
- F3: Dracula
- F4: Nord

### Tmux Status Bar

**Configuration:** `config/tmux/.tmux.conf`

Tmux theming controls:
- Status bar background/foreground
- Window status colors
- Active/inactive pane borders
- Message colors

### Vim

**Configuration:** `config/vim/.vimrc`
**Plugins:** `joshdick/onedark.vim`, `morhetz/gruvbox`, `dracula/vim`, `arcticicestudio/nord-vim`

Vim theming includes:
- Syntax highlighting colors
- Airline status bar theme
- FZF color integration

**Install plugins:**
```vim
:PlugInstall
```

### Neovim

**Configuration:** `config/nvim/lua/plugins/init.lua`
**Plugins:** `navarasu/onedark.nvim`, `ellisonleao/gruvbox.nvim`

Neovim theming includes:
- Syntax highlighting (Treesitter-aware)
- Lualine status bar theme
- LSP diagnostic colors
- Telescope picker colors

**Install plugins:**
```vim
:Lazy sync
```

### FZF Fuzzy Finder

**Configuration:** `config/fzf/fzf.zsh`

FZF theming controls:
- Background/foreground colors
- Selection highlight
- Border colors
- Prompt colors
- Marker colors

### Bat Syntax Highlighter

**Configuration:** `~/.config/bat/config`
**Theme:** Uses built-in themes

Bat theme mappings:
- `atom-dark` → `OneHalfDark`
- `gruvbox` → `gruvbox-dark`
- `nord` → `Nord`
- `dracula` → `Dracula`

**Preview bat themes:**
```bash
bat --list-themes
bat --theme=OneHalfDark <file>
```

## Theme Architecture

### Central Color Palette

**File:** `config/themes/atom-dark.sh`

This file serves as the **single source of truth** for all Atom Dark colors. It defines:

- Base colors (background, foreground, black, white)
- ANSI color palette (16 colors)
- Semantic colors (red, green, yellow, blue, purple, cyan, orange)
- UI colors (comment, selection, cursor, borders)
- Syntax highlighting colors
- Git diff colors

**Usage in scripts:**
```bash
source "$HOME/.dotfiles/config/themes/atom-dark.sh"
echo "$ATOM_BG"    # #282c34
echo "$ATOM_BLUE"  # #61afef
```

**Helper functions:**
```bash
# Convert hex to RGB
hex_to_rgb "#282c34"  # Returns: 40 44 52

# Get color by name
get_atom_color "bg"     # Returns: #282c34
get_atom_color "blue"   # Returns: #61afef
```

### Theme File Structure

```
config/
├── themes/
│   ├── atom-dark.sh           # Central color palette
│   ├── gruvbox.sh             # (Future) Gruvbox palette
│   ├── nord.sh                # (Future) Nord palette
│   └── dracula.sh             # (Future) Dracula palette
│
├── kitty/
│   ├── kitty.conf             # Main config with theme include
│   └── themes/
│       ├── atom-dark.conf     # Atom Dark colors
│       ├── gruvbox.conf       # Gruvbox colors
│       ├── nord.conf          # Nord colors
│       └── dracula.conf       # Dracula colors
│
├── tmux/.tmux.conf            # Inline color definitions
├── vim/.vimrc                 # Colorscheme setting
├── nvim/lua/plugins/init.lua  # Colorscheme plugin config
├── fzf/fzf.zsh                # FZF color env vars
└── bat/config                 # Bat theme setting
```

## Adding a New Theme

### 1. Create Central Color Palette

Create `config/themes/yourtheme.sh`:

```bash
#!/usr/bin/env bash
# Your Theme Color Palette

# Base Colors
export YOURTHEME_BG="#..."
export YOURTHEME_FG="#..."

# ANSI Colors
export YOURTHEME_COLOR0="#..."
export YOURTHEME_COLOR1="#..."
# ... (continue for all 16 colors)

# Semantic Colors
export YOURTHEME_RED="#..."
export YOURTHEME_GREEN="#..."
export YOURTHEME_YELLOW="#..."
export YOURTHEME_BLUE="#..."
export YOURTHEME_PURPLE="#..."
export YOURTHEME_CYAN="#..."

# UI Colors
export YOURTHEME_COMMENT="#..."
export YOURTHEME_SELECTION="#..."
export YOURTHEME_CURSOR="#..."

# Helper function
get_yourtheme_color() {
    case "$1" in
        bg|background) echo "$YOURTHEME_BG" ;;
        fg|foreground) echo "$YOURTHEME_FG" ;;
        # ... add more cases
    esac
}

export -f get_yourtheme_color 2>/dev/null || true
```

### 2. Create Kitty Theme

Create `config/kitty/themes/yourtheme.conf`:

```conf
# Your Theme for Kitty

# Basic colors
foreground            #...
background            #...
selection_foreground  #...
selection_background  #...

# Cursor colors
cursor                #...
cursor_text_color     #...

# ANSI colors
color0  #...  # Black
color1  #...  # Red
color2  #...  # Green
color3  #...  # Yellow
color4  #...  # Blue
color5  #...  # Magenta
color6  #...  # Cyan
color7  #...  # White
color8  #...  # Bright Black
# ... (continue for colors 9-15)
```

### 3. Update Theme Switcher

Edit `tools/switch-theme.sh`:

```bash
# Add theme to THEMES array
THEMES=("atom-dark" "gruvbox" "nord" "dracula" "yourtheme")

# Add case for Tmux colors
switch_tmux() {
    case "$theme" in
        yourtheme)
            sed -i.bak 's|^set -g status-bg .*|set -g status-bg "#..."|' "$tmux_conf"
            sed -i.bak 's|^set -g status-fg .*|set -g status-fg "#..."|' "$tmux_conf"
            ;;
    esac
}

# Add cases for Vim, Neovim, and Bat
```

### 4. Install Color Scheme Plugins

**For Vim:**
```vim
" Add to config/vim/.vimrc
Plug 'username/yourtheme.vim'
```

**For Neovim:**
```lua
-- Add to config/nvim/lua/plugins/init.lua
{
  "username/yourtheme.nvim",
  priority = 1000,
}
```

### 5. Test the New Theme

```bash
# Switch to your new theme
theme yourtheme

# Reload applications and verify colors
```

## Manual Theme Configuration

If you prefer to manually configure themes without using the theme switcher:

### Kitty

Edit `config/kitty/kitty.conf`:
```conf
# Comment out current theme
#include themes/atom-dark.conf

# Include new theme
include themes/yourtheme.conf
```

Reload: `Ctrl+Shift+F5`

### Tmux

Edit `config/tmux/.tmux.conf`:
```bash
# Update status bar colors
set -g status-bg "#..."
set -g status-fg "#..."
```

Reload: `tmux source ~/.tmux.conf`

### Vim

Edit `config/vim/.vimrc`:
```vim
colorscheme yourtheme
let g:airline_theme = 'yourtheme'
```

Reload: `:source $MYVIMRC`

### Neovim

Edit `config/nvim/lua/plugins/init.lua`:
```lua
require("yourtheme").setup()
require("yourtheme").load()

require("lualine").setup({
  options = { theme = "yourtheme" }
})
```

Reload: `:Lazy sync`

### FZF

Edit `config/fzf/fzf.zsh`:
```bash
export FZF_DEFAULT_OPTS="
--color=bg+:#...,bg:#...,spinner:#...,hl:#...
--color=fg:#...,header:#...,info:#...,pointer:#...
--color=marker:#...,fg+:#...,prompt:#...,hl+:#...
"
```

Reload: `source ~/.zshrc`

### Bat

Edit `~/.config/bat/config`:
```bash
--theme="YourThemeName"
```

No reload needed (applies to new invocations)

## Troubleshooting

### Colors Look Wrong

**Problem:** Colors don't match expected theme
**Solution:**
1. Check terminal supports 24-bit color: `echo $COLORTERM` (should be `truecolor`)
2. Verify Kitty config: `kitty --debug-config | grep theme`
3. Test Vim colors: `:hi` to show highlight groups
4. Check Tmux colors: `tmux show-options -g | grep color`

### Theme Not Changing

**Problem:** Theme switcher runs but colors stay the same
**Solution:**
1. Verify script has execute permissions: `ls -l ~/.dotfiles/tools/switch-theme.sh`
2. Check for error messages: `theme yourtheme 2>&1 | less`
3. Manually verify config files were updated
4. Ensure you reloaded/restarted applications

### Vim/Neovim Theme Missing

**Problem:** `:colorscheme yourtheme` gives error
**Solution:**
1. Install plugin: `:PlugInstall` (Vim) or `:Lazy sync` (Neovim)
2. Check plugin installed: `ls ~/.vim/plugged/` or `:Lazy`
3. Verify plugin name matches colorscheme name
4. Check for plugin errors: `:messages`

### FZF Colors Not Updating

**Problem:** FZF still shows old colors
**Solution:**
1. Reload shell: `source ~/.zshrc`
2. Check env var: `echo $FZF_DEFAULT_OPTS`
3. Start new shell session
4. Verify fzf.zsh is sourced in .zshrc

### Bat Theme Not Found

**Problem:** Bat says theme doesn't exist
**Solution:**
1. List available themes: `bat --list-themes`
2. Use exact theme name (case-sensitive)
3. Rebuild cache: `bat cache --build`
4. Update bat: `brew upgrade bat` or equivalent

### Theme Partially Applied

**Problem:** Some apps use new theme, others don't
**Solution:**
1. Run theme switcher again: `theme yourtheme`
2. Check each config file manually
3. Restart applications individually
4. Check for backup files (*.bak) that might be interfering

### Performance Issues with Theme

**Problem:** Terminal feels sluggish after theme change
**Solution:**
1. Disable transparency in Kitty: set `background_opacity 1.0`
2. Reduce blur: set `background_blur 0`
3. Disable animations
4. Check if theme has expensive background images

## Related Documentation

- [README.md](README.md) - Main dotfiles documentation
- [config/kitty/README.md](config/kitty/README.md) - Kitty-specific configuration
- [config/nvim/README.md](config/nvim/README.md) - Neovim setup guide
- [CLAUDE.md](CLAUDE.md) - Project instructions for Claude Code

## Color Palette Reference

### Atom Dark Colors

| Color          | Hex       | Usage                          |
|----------------|-----------|--------------------------------|
| Background     | `#282c34` | Editor background              |
| Foreground     | `#abb2bf` | Normal text                    |
| Red            | `#e06c75` | Errors, deletions              |
| Green          | `#98c379` | Success, additions             |
| Yellow         | `#d19a66` | Warnings, changes              |
| Blue           | `#61afef` | Info, functions                |
| Purple/Magenta | `#c678dd` | Keywords, special              |
| Cyan           | `#56b6c2` | Constants, strings             |
| Comment Gray   | `#5c6370` | Comments, disabled text        |
| Selection      | `#3e4451` | Visual selection background    |
| Cursor         | `#528bff` | Cursor color                   |

### Quick Reference Commands

```bash
# Show current theme
theme

# List all available themes
theme --help

# Switch theme
theme atom-dark
theme gruvbox
theme nord
theme dracula

# Reload applications after theme change
tmux source ~/.tmux.conf           # Tmux
vim +:source\ \$MYVIMRC +:q        # Vim
nvim +:Lazy\ sync +:q              # Neovim
source ~/.zshrc                     # FZF

# Test colors
bat --list-themes                  # Bat themes
echo $FZF_DEFAULT_OPTS            # FZF colors
kitty +kitten themes               # Kitty theme picker
```

## Contributing

When adding new themes or improving existing ones:

1. **Test thoroughly** across all applications
2. **Document color choices** in theme palette files
3. **Maintain consistency** with the central palette pattern
4. **Update theme switcher** to support new themes
5. **Document in this guide** with clear instructions

## Credits

- **Atom One Dark** - Original theme by GitHub/Atom
- **Gruvbox** - retro groove color scheme by morhetz
- **Nord** - arctic, north-bluish color palette
- **Dracula** - dark theme created by Zeno Rocha
