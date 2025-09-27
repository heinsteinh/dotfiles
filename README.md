# Cross-Platform Dotfiles

A comprehensive dotfiles configuration that works seamlessly across Linux (Arch, Ubuntu) and macOS, featuring modern CLI tools, enhanced terminal experience, and productive development workflow.

## Quick Start

```bash
# Clone the repository
git clone https://github.com/heinsteinh/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run installation (recommended)
make install

# Or manual installation
./install.sh

# Restart terminal or reload config
source ~/.zshrc
```

## Features

### Core Components
- **Zsh** with Oh My Zsh and Powerlevel10k theme
- **Vim** with vim-plug and essential plugins
- **Tmux** with TPM and productivity plugins
- **Kitty** terminal with optimized configuration
- **Git** with sensible defaults and aliases

### Enhanced CLI Tools
- **FZF** - Fuzzy finding for files, history, and commands
- **Eza** - Modern ls replacement with git integration (successor to exa)
- **Bat** - Cat with syntax highlighting and git integration
- **Ripgrep** - Fast text search with smart filtering
- **Fd** - Fast and user-friendly find alternative
- **Lazygit** - Terminal UI for git operations
- **Starship** - Cross-shell prompt with git integration
- **Zoxide** - Smarter cd command with frecency

### Recent Improvements ✨
- **Ubuntu 24.04 Support** - Updated exa → eza for compatibility
- **Conflict Resolution** - Fixed all function/alias conflicts
- **Modular Configuration** - Organized zsh config into separate files
- **Enhanced Functions** - 50+ utility functions with fzf integration
- **Better Error Handling** - Graceful fallbacks and conflict prevention

## Installation Options

### Complete Setup
```bash
make install          # Full installation
make install-arch     # Arch Linux specific
make install-macos    # macOS specific
make install-fonts    # Fonts only
```

### Manual Steps
```bash
# 1. Backup existing configs
make backup

# 2. Install system packages
./scripts/setup-arch.sh    # or setup-macos.sh

# 3. Install fonts
./scripts/install-fonts.sh

# 4. Install CLI tools
./scripts/install-cli-tools.sh

# 5. Create symlinks
./install.sh
```

## Configuration Files

### Zsh Configuration (Modular Structure)
- **Main config**: `config/zsh/.zshrc` - Core configuration and plugin setup
- **Aliases**: `config/zsh/aliases.zsh` - 200+ command aliases and shortcuts
- **Functions**: `config/zsh/functions.zsh` - 50+ utility functions with fzf integration
- **Exports**: `config/zsh/exports.zsh` - Environment variables and PATH setup
- **Distro**: `config/zsh/distro.zsh` - OS-specific configurations and detection

Key features:
- **Smart Loading**: Functions before aliases to prevent conflicts
- **Enhanced History**: Shared history with deduplication
- **Fuzzy Integration**: FZF for files, history, processes, git branches
- **Package Manager Aliases**: Auto-detects pacman, apt, brew, dnf
- **Modern Tools**: Integrated eza, bat, ripgrep, fd with fallbacks
- **Git Integration**: Advanced aliases and functions for git workflows

### Vim Configuration
- **Enhanced search** with FZF integration
- **File exploration** with NERDTree
- **Git integration** with fugitive and gitgutter
- **Code quality** with ALE linting
- **Modern interface** with airline and devicons

Key bindings (Leader: Space):
- `<leader>f` - Find files
- `<leader>n` - Toggle file tree
- `<leader>rg` - Search in files
- `<leader>gs` - Git status

### Tmux Configuration
- **Vim-like navigation** and key bindings
- **Enhanced status bar** with system info
- **Plugin management** with TPM
- **Session persistence** with resurrect

Key bindings (Prefix: Ctrl+a):
- `Ctrl+a |` - Split vertically
- `Ctrl+a -` - Split horizontally
- `h/j/k/l` - Navigate panes
- `Ctrl+a r` - Reload config

### Kitty Terminal
- **Gruvbox color scheme**
- **Nerd Font integration**
- **Optimized performance** settings
- **Cross-platform compatibility**

## Essential CLI Tools

### File Management
```bash
ll              # Enhanced ls with eza
fd pattern      # Fast find
tree            # Directory structure
bat file.txt    # Syntax highlighted cat
```

### Text Processing
```bash
rg "pattern"    # Fast grep
fzf             # Interactive finder
jq '.key'       # JSON processing
```

### Development
```bash
lg              # Lazygit UI
g s             # Git status (alias)
d ps            # Docker ps (alias)
py script.py    # Python3 (alias)
```

### System Monitoring
```bash
htop            # Process monitor
btop            # Modern system monitor
df -h           # Disk usage
ss -tuln        # Network connections
```

## Customization

### Adding Personal Configurations
Create these files for local customizations:
```bash
~/.zshrc.local      # Local zsh config
~/.vimrc.local      # Local vim config
~/.tmux.conf.local  # Local tmux config
```

### Color Schemes
Available themes in vim:
- `gruvbox` (default)
- `dracula`
- `nord-vim`

Change in `config/vim/.vimrc`:
```vim
colorscheme dracula
let g:airline_theme = 'dracula'
```

### Platform-Specific Settings
The configuration automatically detects:
- **macOS**: Homebrew paths, macOS-specific aliases
- **Linux**: Package manager detection, clipboard tools
- **Arch Linux**: Pacman aliases and AUR support

## Key Bindings Reference

### Zsh
```bash
Ctrl+R          # History search with fzf
Ctrl+T          # File finder
Alt+C           # Directory finder
```

### Vim
```bash
Space+f         # Find files
Space+rg        # Search in files
Space+n         # File tree
Space+gs        # Git status
Space+s         # Jump to character (EasyMotion)
```

### Tmux
```bash
Ctrl+a |        # Split vertical
Ctrl+a -        # Split horizontal
Ctrl+a h/j/k/l  # Navigate panes
Ctrl+a [        # Copy mode
```

### Kitty
```bash
Ctrl+Shift+T    # New tab
Ctrl+Shift+N    # New window
Ctrl+Shift+C    # Copy
Ctrl+Shift+V    # Paste
```

## Font Requirements

The configuration uses Nerd Fonts for proper icon display:
- **MesloLGS NF** (primary)
- **FiraCode NF** (alternative)
- **JetBrains Mono NF** (alternative)
- **Hack NF** (alternative)

Auto-installed by `install-fonts.sh`

## Backup and Restore

### Backup Existing Configs
```bash
make backup
# Creates backups in ~/.dotfiles-backup/
```

### Restore
```bash
# Manual restore
cp ~/.dotfiles-backup/.vimrc ~/.vimrc
cp ~/.dotfiles-backup/.zshrc ~/.zshrc
# etc.
```

## Troubleshooting

### Common Issues

**Fonts not displaying correctly:**
```bash
# Reinstall fonts
./scripts/install-fonts.sh
fc-cache -fv  # Linux only
```

**Zsh plugins not working:**
```bash
# Reinstall Oh My Zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
```

**Tmux plugins not loading:**
```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# In tmux: Ctrl+a + I
```

**Vim plugins not installing:**
```bash
# Open vim and run
:PlugInstall
:PlugUpdate
```

### Performance Issues

**Zsh slow startup:**
```bash
# Profile startup time
zsh -xvs
# Disable heavy plugins temporarily
```

**Vim slow with large files:**
```bash
# Disable syntax highlighting for large files
:syntax off
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Test on both Linux and macOS
4. Submit a pull request

## Platform Support

- **macOS** 10.15+ (Intel/Apple Silicon)
- **Arch Linux** (latest)
- **Ubuntu** 20.04+ / Debian 11+
- **Other Linux**: Partial support

## Dependencies

Auto-installed by setup scripts:
- Git, Curl, Wget
- Zsh, Tmux, Vim/Neovim
- FZF, Ripgrep, Eza, Bat
- Node.js, Python3
- Platform-specific package managers

## License

MIT License - feel free to use and modify as needed.
