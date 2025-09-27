# Cross-Platform Dotfiles

A comprehensive dotfiles configuration that works seamlessly across Linux and macOS, featuring modern CLI tools, enhanced terminal experience, and productive development workflow.

## ✨ Features

- **🔧 Cross-platform compatibility** (Linux/macOS)
- **⚡ Automated installation** with OS detection
- **🛠️ Modern CLI tools** integration (zsh, tmux, vim, git, fzf, bat, ripgrep)
- **🎨 Beautiful terminal** with Starship prompt
- **📝 Comprehensive documentation**
- **🧪 Testing framework**
- **🔄 Git workflows** and automation

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/heinsteinh/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Make installation script executable and run
chmod +x install.sh
./install.sh
```

## 📦 Included Tools & Configurations

### Terminal & Shell
- **Zsh** with custom aliases and exports
- **Starship** prompt for a beautiful command line
- **Tmux** with productivity-focused sessions
- **Kitty** terminal emulator configuration

### Development Tools
- **Git** configuration with hooks
- **Vim** with essential plugins
- **SSH** configuration templates
- **Modern CLI replacements**:
  - `bat` (better cat)
  - `fzf` (fuzzy finder)  
  - `ripgrep` (better grep)

### System Integration
- **Font management** (FiraCode, Hack, JetBrains Mono, MesloLGS)
- **Backup utilities** for safe configuration changes
- **Cross-platform scripts** for Arch Linux and macOS

## 📚 Documentation

- [Installation Guide](docs/INSTALLATION.md) - Detailed setup instructions
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions

## 🏗️ Project Structure

```
.dotfiles/
├── config/           # Application configurations
│   ├── git/          # Git configuration and hooks
│   ├── kitty/        # Terminal emulator config
│   ├── tmux/         # Terminal multiplexer config
│   ├── vim/          # Vim configuration
│   └── zsh/          # Zsh shell configuration
├── scripts/          # Installation and utility scripts
│   ├── install/      # Component installation scripts
│   ├── setup/        # OS-specific setup scripts
│   └── utils/        # Utility and maintenance scripts
├── fonts/            # Programming fonts
├── templates/        # Configuration templates
└── docs/             # Documentation
```

## 🔧 Customization

1. **Fork this repository** to your GitHub account
2. **Clone your fork**: `git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles`
3. **Modify configurations** in the `config/` directory
4. **Add personal scripts** to `local/scripts/`
5. **Update documentation** as needed

## 🧪 Testing

Run the test suite to ensure everything is working correctly:

```bash
cd ~/.dotfiles
./tests/test-installation.sh
```

## 📝 License

MIT License - see [LICENSE](LICENSE) for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📞 Support

If you encounter any issues:
1. Check the [Troubleshooting Guide](docs/TROUBLESHOOTING.md)
2. Search existing [Issues](https://github.com/heinsteinh/dotfiles/issues)
3. Open a new issue with detailed information
