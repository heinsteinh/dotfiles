# 🚀 Modern Cross-Platform Dotfiles

A comprehensive, battle-tested dotfiles configuration with automated setup, extensive CI/CD testing, and advanced security scanning. Works seamlessly across Ubuntu, macOS, Fedora, and Arch Linux with intelligent OS detection and modern CLI tools.

## 🎯 Quick Start

### 🔄 Automated Installation (Recommended)
```bash
# Clone and enter the dotfiles directory
git clone https://github.com/heinsteinh/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Interactive setup with OS detection
./tools/workflows/new-machine.sh

# Or direct platform-specific setup
./scripts/setup/setup-ubuntu.sh    # Ubuntu/Debian
./scripts/setup/setup-macos.sh     # macOS  
./scripts/setup/setup-fedora.sh    # Fedora
./scripts/setup/setup-arch.sh      # Arch Linux
```

### 🛡️ What Gets Installed
- **Essential tools**: Git, Zsh, Vim, Tmux, modern CLI utilities
- **Development tools**: Node.js, Python, Go, Rust toolchains  
- **Modern CLI**: ripgrep, fzf, eza, bat, fd, starship, htop
- **Zsh plugins**: Oh My Zsh, autosuggestions, syntax highlighting, fast-syntax-highlighting, autocomplete
- **Fonts**: Nerd Fonts (MesloLGS, FiraCode, JetBrains Mono, Hack)
- **Security**: Comprehensive scanning and validation

## ✨ Features

### 🏗️ Automated Setup & CI/CD
- **🤖 Intelligent OS Detection**: Automatically detects Ubuntu, macOS, Fedora, Arch Linux
- **⚡ New Machine Workflow**: Interactive setup for minimal/full installations  
- **🔄 CI/CD Testing**: Multi-OS testing on GitHub Actions (Ubuntu 22.04/24.04, macOS 14, Fedora, Arch)
- **🛡️ Security Scanning**: GitLeaks, TruffleHog, Trivy integration with SARIF reports
- **📋 Comprehensive Testing**: 17-test validation suite for all components

### 🔧 Core Development Environment
- **🐚 Zsh**: Oh My Zsh + 4 essential plugins (autosuggestions, syntax-highlighting, fast-syntax-highlighting, autocomplete)
- **📝 Vim**: Modern plugin setup with vim-plug, fuzzy finding, git integration
- **📺 Tmux**: TPM plugin manager with productivity enhancements
- **🖥️ Kitty**: GPU-accelerated terminal with theme support
- **🔀 Git**: Advanced configuration with hooks, aliases, and security

### 🚀 Modern CLI Arsenal
- **🔍 Search & Find**: `ripgrep` (rg), `fzf` (fuzzy finder), `fd` (find alternative)  
- **📁 File Management**: `eza` (modern ls), `bat` (syntax-highlighted cat), `tree`
- **⚡ Performance**: `htop`/`btop` (system monitoring), `starship` (fast prompt)
- **🛠️ Development**: `lazygit` (git UI), language toolchains (Node.js, Python, Go, Rust)
- **🎨 Enhancements**: Nerd Fonts, color schemes, shell integrations

### 🆕 Latest Major Improvements
- **✅ Ubuntu 24.04 Full Support** - Updated package management and tool compatibility
- **🔧 Enhanced Setup Scripts** - Comprehensive OS-specific installation with error handling
- **🧪 CI-Aware Testing** - Smart test framework that adapts to CI vs local environments  
- **🔐 Advanced Security** - Multi-tool secret scanning with artifact preservation
- **📦 Modular Architecture** - Clean separation of concerns with extensible structure
- **🎯 Performance Optimized** - Lazy loading and efficient resource management

## 🔧 Installation Options

### 🎯 Interactive New Machine Setup (Recommended)
```bash
# Clone repository
git clone https://github.com/heinsteinh/dotfiles.git ~/.dotfiles && cd ~/.dotfiles

# Run interactive setup wizard
./tools/workflows/new-machine.sh
# - Prompts for user info (name, email)
# - Offers minimal vs full installation  
# - Automatically detects and configures OS
# - Handles all dependencies and setup
```

### 🚀 Platform-Specific Direct Installation
```bash
# Ubuntu/Debian Systems
./scripts/setup/setup-ubuntu.sh

# macOS Systems  
./scripts/setup/setup-macos.sh

# Fedora Systems
./scripts/setup/setup-fedora.sh

# Arch Linux Systems
./scripts/setup/setup-arch.sh
```

### 🛠️ Manual Component Installation
```bash
# Individual components
./scripts/install/install-fonts.sh        # Nerd Fonts
./scripts/install/install-cli-tools.sh    # Modern CLI tools
./scripts/install/install-dev-tools.sh    # Development environments
./scripts/utils/create-symlinks.sh        # Dotfile symlinks

# Testing and validation
./tests/test-installation.sh --verbose    # Comprehensive testing
```

### 📋 Makefile Targets (Legacy)
```bash
make install          # Full installation
make backup           # Backup existing configs
make test            # Run test suite
make clean           # Clean temporary files
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

## 🔄 CI/CD & Quality Assurance

### 🧪 Comprehensive Testing Pipeline
Our GitHub Actions workflow ensures reliability across all supported platforms:

```yaml
✅ Multi-OS Testing:
  - Ubuntu 22.04 & 24.04 (in containers)
  - macOS 14 (native runners)  
  - Fedora Latest (container)
  - Arch Linux Latest (container)

🔍 Security Scanning:
  - GitLeaks: Repository secret detection
  - TruffleHog: Advanced secret scanning  
  - Trivy: Vulnerability & secret analysis
  - Custom patterns: Dotfiles-specific checks

🛠️ Quality Checks:
  - ShellCheck: Shell script linting
  - MarkdownLint: Documentation validation
  - Link checking: Broken link detection
  - Performance testing: Shell startup benchmarks
```

### 🛡️ Security Features
- **Secret Scanning**: Multi-tool approach with SARIF reporting
- **Vulnerability Detection**: Trivy scanning for known CVEs
- **Permission Validation**: Script and file permission checks
- **Artifact Preservation**: Security results saved for 30 days
- **CI Integration**: Automated scanning on every push/PR

### ✅ Test Coverage
17 comprehensive tests covering:
- Essential command availability
- Modern CLI tool installation  
- Configuration file validity
- Symlink creation and integrity
- Plugin functionality
- Cross-platform compatibility
- Performance benchmarks

## 🌍 Platform Support

| Platform | Version | Status | Notes |
|----------|---------|--------|-------|
| **Ubuntu** | 22.04, 24.04 | ✅ Full | Primary development platform |
| **macOS** | 14+ | ✅ Full | Homebrew + native tools |
| **Fedora** | Latest | ✅ Full | DNF + RPM Fusion support |
| **Arch Linux** | Rolling | ✅ Full | Pacman + AUR via yay |
| **Debian** | 11+ | 🟡 Partial | Compatible with Ubuntu setup |
| **Other Linux** | Various | 🟡 Partial | May require manual tweaks |

### 📦 Auto-Installed Dependencies

**Core System Tools:**
- Git, Curl, Wget, Zsh, Bash
- Vim/Neovim, Tmux, Essential build tools

**Modern CLI Enhancement:**
- `fzf`, `ripgrep`, `fd`, `bat`, `eza`
- `htop`, `tree`, `starship`, `lazygit`

**Development Environments:**
- Node.js (via official repos/Homebrew)
- Python 3 + pip
- Go, Rust (via official installers)
- Docker (where applicable)

**Fonts & Themes:**
- Nerd Fonts collection (MesloLGS, FiraCode, JetBrains Mono, Hack)
- Color schemes (Gruvbox, Dracula, Nord)

## 📈 Project Statistics

- **🔧 Setup Scripts**: 5 OS-specific installation scripts
- **⚙️ Configuration Files**: 15+ carefully tuned dotfiles
- **🧪 Test Suite**: 17 comprehensive validation tests
- **🛡️ Security Tools**: 4 integrated scanning tools
- **📚 Documentation**: 6 comprehensive guides + inline help
- **🚀 CI Jobs**: 12 automated testing jobs per commit

## � Documentation

| Document | Description |
|----------|-------------|
| [📋 Installation Guide](docs/INSTALLATION.md) | Comprehensive setup instructions for all platforms |
| [🎨 Customization Guide](docs/CUSTOMIZATION.md) | Learn how to personalize your setup |
| [🔧 Troubleshooting](docs/TROUBLESHOOTING.md) | Solutions to common issues |
| [🏗️ Architecture Guide](docs/ARCHITECTURE.md) | System design and technical implementation |
| [🤝 Contributing Guide](docs/CONTRIBUTING.md) | How to contribute to the project |
| [📜 CLI Tools Reference](docs/CLI-TOOLS.md) | Complete list of included modern CLI tools |

## �📄 License

MIT License - Free to use, modify, and distribute. See [LICENSE](LICENSE) for details.

---

## 🤝 Contributing

We welcome contributions! Our automated testing pipeline runs on every PR to ensure quality and compatibility across all supported platforms.

**Quick Start:**
```bash
git clone https://github.com/yourusername/dotfiles.git
cd dotfiles
./tools/workflows/new-machine.sh  # Test the installation
./tests/test-installation.sh --verbose  # Validate everything works
```

For detailed contribution guidelines, development workflow, and coding standards, see our [Contributing Guide](docs/CONTRIBUTING.md).
