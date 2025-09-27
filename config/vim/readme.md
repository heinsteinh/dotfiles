# Enhanced Vim Configuration

A comprehensive Vim setup with modern plugins and optimized keybindings for efficient development workflow.

## Features

### Plugin Manager
- **vim-plug**: Automatic plugin management with auto-installation

### Core Plugins
- **FZF**: Fuzzy file finder with enhanced search capabilities
- **NERDTree**: File explorer with directory tree view
- **vim-airline**: Enhanced status line with theme support
- **vim-devicons**: File type icons (requires Nerd Font)
- **vim-fugitive**: Comprehensive Git integration
- **vim-gitgutter**: Git diff indicators in the gutter

### Enhanced Search & Navigation
- **incsearch.vim**: Real-time search highlighting with fuzzy matching
- **vim-easymotion**: Jump to any location with minimal keystrokes
- **CtrlP**: Alternative fuzzy file finder
- **far.vim**: Advanced find and replace across multiple files

### Code Quality & Editing
- **ALE**: Asynchronous linting and fixing
- **vim-commentary**: Easy commenting/uncommenting
- **vim-surround**: Manipulate surrounding quotes, brackets, tags
- **auto-pairs**: Automatic bracket/quote pairing
- **indentLine**: Visual indent guides

## Key Bindings

### Leader Key
- **Leader**: `Space`

### File Operations
| Key | Action |
|-----|--------|
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<leader>x` | Save and quit |

### File Navigation
| Key | Action |
|-----|--------|
| `<leader>f` | Find files (FZF) |
| `<leader>p` | Find files (CtrlP) |
| `<leader>n` | Toggle NERDTree |
| `<leader>nf` | Find current file in NERDTree |

### Buffer Management
| Key | Action |
|-----|--------|
| `<leader>b` | List buffers (FZF) |
| `<leader>bd` | Delete buffer |
| `Ctrl+h` | Previous buffer |
| `Ctrl+l` | Next buffer |

### Window Navigation
| Key | Action |
|-----|--------|
| `Ctrl+j` | Move to window below |
| `Ctrl+k` | Move to window above |
| `Ctrl+h` | Move to window left |
| `Ctrl+l` | Move to window right |

### Search & Replace
| Key | Action |
|-----|--------|
| `/` | Enhanced incremental search |
| `?` | Backward search |
| `z/` | Fuzzy search forward |
| `z?` | Fuzzy search backward |
| `<leader>rg` | Search in files (ripgrep) |
| `<leader>/` | Search lines in current buffer |
| `<leader>bl` | Search lines in current buffer |
| `<leader>sr` | Search and replace word under cursor |
| `<leader>ss` | Advanced find/replace (Far.vim) |
| `<leader>*` | Search word under cursor with count |
| `<leader>/` | Clear search highlight |

### EasyMotion Navigation
| Key | Action |
|-----|--------|
| `<leader>s` | Jump to any character |
| `<leader>j` | Jump to any line |
| `<leader>k` | Jump to any line |
| `<leader>w` | Jump to any word |

### Git Integration
| Key | Action |
|-----|--------|
| `<leader>gs` | Git status |
| `<leader>gc` | Git commit |
| `<leader>gp` | Git push |
| `<leader>gl` | Git pull |
| `<leader>gd` | Git diff |
| `<leader>gb` | Git blame |
| `<leader>gg` | Git grep |

### History & Marks
| Key | Action |
|-----|--------|
| `<leader>h` | File history |
| `<leader>hc` | Command history |
| `<leader>hs` | Search history |
| `<leader>m` | Marks |
| `<leader>t` | Tags |

### Configuration
| Key | Action |
|-----|--------|
| `<leader>ev` | Edit vimrc |
| `<leader>sv` | Source vimrc |
| `<leader>rn` | Toggle relative numbers |

### Line Movement
| Key | Action |
|-----|--------|
| `Alt+j` | Move line down |
| `Alt+k` | Move line up |

### Utility
| Key | Action |
|-----|--------|
| `Esc Esc` | Clear search highlighting |

## Installation

1. Install dependencies:
```bash
# Arch Linux
sudo pacman -S vim fzf ripgrep
yay -S ttf-meslo-nerd-font-powerlevel10k

# Optional linters
sudo pacman -S python-flake8 python-pylint shellcheck
npm install -g eslint prettier
```

2. Install the configuration:
```bash
# Backup existing config
mv ~/.vimrc ~/.vimrc.backup

# Copy the new configuration
# (paste the provided vimrc content)

# Open vim and install plugins
vim
:PlugInstall
```

## Customization

### Color Schemes
Available themes: `gruvbox`, `dracula`, `nord-vim`

Change theme in vimrc:
```vim
colorscheme dracula
let g:airline_theme = 'dracula'
```

### Plugin Configuration
All plugin settings are in the "Plugin Configuration" section of the vimrc.

### Custom Keybindings
Add your own mappings in the "Key Mappings" section.

## Tips

1. **FZF Preview**: Use `Ctrl+/` to toggle preview window
2. **Multiple Files**: Use `:Rg` for searching across all files
3. **Git Integration**: Use `<leader>gs` for interactive git status
4. **Quick Navigation**: Use EasyMotion `<leader>s` followed by the character to jump to
5. **Buffer Management**: Use `<leader>b` to quickly switch between open files

## File Types

The configuration includes specific settings for:
- Python (4 spaces)
- JavaScript/TypeScript (2 spaces)
- HTML/CSS (2 spaces)
- YAML (2 spaces)
- Markdown (word wrap enabled)

## Backup & Recovery

The configuration automatically creates backup directories:
- `~/.vim/backup/` - File backups
- `~/.vim/swap/` - Swap files
- `~/.vim/undo/` - Persistent undo history