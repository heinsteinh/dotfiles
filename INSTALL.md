# Quick Installation Guide

This guide provides quick steps to get your dotfiles up and running.

## Prerequisites

- Git
- Zsh (recommended)
- Curl or wget

## Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Run the installation script
./install.sh
```

## Alternative Installation Methods

### Using Make
```bash
make install
```

### Manual Installation
```bash
# Install fonts
./scripts/install/install-fonts.sh

# Install CLI tools
./scripts/install/install-cli-tools.sh

# Create symlinks
./scripts/utils/create-symlinks.sh
```

## What Gets Installed

- **Configuration files**: Vim, Tmux, Kitty, Zsh, Git
- **Fonts**: Nerd Fonts (FiraCode, JetBrains Mono, Hack, MesloLGS)
- **CLI Tools**: Modern replacements for common tools
- **Shell enhancements**: Aliases, functions, and customizations

## Next Steps

- Review and customize local configuration files
- See [CUSTOMIZATION.md](docs/CUSTOMIZATION.md) for advanced options
- Check [TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) if you encounter issues

For detailed installation instructions, see [docs/INSTALLATION.md](docs/INSTALLATION.md).