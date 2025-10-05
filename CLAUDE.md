# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a comprehensive, production-ready dotfiles system with automated setup, CI/CD testing, and enterprise-grade security scanning. Battle-tested across Ubuntu 22.04/24.04, macOS 14+, Fedora, and Arch Linux with 70+ modern CLI tools.

## Common Commands

### Installation & Setup

```bash
# Interactive setup for new machine (recommended)
./tools/workflows/new-machine.sh

# OS-specific direct installation
./scripts/setup/setup-ubuntu.sh    # Ubuntu/Debian
./scripts/setup/setup-macos.sh     # macOS
./scripts/setup/setup-fedora.sh    # Fedora
./scripts/setup/setup-arch.sh      # Arch Linux

# Component installation
./scripts/install/install-fonts.sh        # Nerd Fonts
./scripts/install/install-cli-tools.sh    # Modern CLI tools
./scripts/install/install-dev-tools.sh    # Development environments
./scripts/utils/create-symlinks.sh        # Dotfile symlinks
```

### Testing & Validation

```bash
# Run comprehensive test suite (17-test validation)
./tests/test-installation.sh --verbose

# Makefile targets
make test              # Run all tests
make doctor            # Run diagnostic checks
make health-check      # System health check
```

### Maintenance

```bash
# Update all tools and dependencies
./scripts/maintenance/update-all.sh

# Clean temporary files and caches
./scripts/maintenance/cleanup.sh

# Backup existing configs
make backup
```

## Architecture

### Directory Structure

```
dotfiles/
├── config/                  # Configuration templates
│   ├── zsh/                # Shell configuration (modular)
│   │   ├── .zshrc          # Main Zsh config
│   │   ├── aliases.zsh     # 200+ command aliases
│   │   ├── functions.zsh   # 50+ utility functions with fzf
│   │   ├── exports.zsh     # Environment variables
│   │   ├── distro.zsh      # OS detection and routing
│   │   └── distro/         # OS-specific configs
│   │       ├── macos.zsh
│   │       ├── ubuntu.zsh
│   │       ├── arch.zsh
│   │       └── fedora.zsh
│   ├── nvim/               # Neovim with Lazy.nvim
│   │   └── init.lua        # Modern LSP, Telescope, Neo-tree
│   ├── vim/                # Classic Vim with vim-plug
│   ├── tmux/               # Terminal multiplexer with TPM
│   ├── git/                # Version control
│   └── kitty/              # GPU-accelerated terminal
│
├── scripts/
│   ├── setup/              # OS-specific installers
│   ├── install/            # Component installers
│   ├── utils/              # Utility scripts
│   └── maintenance/        # Ongoing maintenance
│
├── tools/workflows/        # User-facing workflows
│   ├── new-machine.sh      # Interactive setup wizard
│   ├── doctor.sh           # Health check & diagnostics
│   └── bootstrap.sh        # Minimal bootstrap
│
└── tests/                  # Validation framework
    └── test-installation.sh # 17-category test suite
```

### Modular Zsh Configuration

**Critical Loading Order** (defined in `config/zsh/.zshrc`):
1. Oh My Zsh framework initialization
2. `exports.zsh` - Environment variables and PATH
3. `functions.zsh` - Function definitions (must load before aliases)
4. `aliases.zsh` - Command aliases (200+ shortcuts)
5. `distro.zsh` - OS-specific configurations
6. `local.zsh` - User customizations (optional)

**Why This Matters**: Functions must be defined before aliases that reference them. Changing the loading order will break functionality.

### OS Detection System

The codebase uses a multi-method detection approach for reliability:

```bash
# Priority order:
1. /etc/os-release (standard)
2. lsb_release -si (if available)
3. /etc/issue (fallback)
4. CI environment detection ($CI variable)
5. Package manager detection
```

**Container-Aware**: Scripts detect CI environments and adapt behavior (skip symlink tests, disable colors, use defaults).

### Package Management Abstraction

Each OS-specific setup script (`setup-{os}.sh`) sources `setup-common.sh` which provides:
- `install_package()` - Unified package installation
- `command_exists()` - Check tool availability
- `detect_os()` - OS identification
- Logging functions (`log_info`, `log_success`, `log_error`, etc.)

## CI/CD System

### GitHub Actions Pipeline

Located in `.github/workflows/ci.yml`:
- Multi-OS matrix testing (Ubuntu 22.04/24.04, macOS 14, Fedora, Arch)
- 4-layer security scanning (GitLeaks, TruffleHog, Trivy, custom patterns)
- ShellCheck for POSIX compliance
- Performance benchmarks (shell startup < 500ms)
- CI-aware testing with timeout handling

### Testing Framework

The `tests/test-installation.sh` script runs 17 comprehensive validation categories:
1. Essential commands availability
2. Modern CLI tools installation
3. Core symlinks creation
4. Config directory structure
5. Zsh configuration validity
6. Vim configuration
7. Tmux configuration
8. Git configuration
9. Shell plugins functionality
10. Starship prompt
11. SSH configuration
12. Font installation
13. Environment variables
14. Script permissions
15. CI/CD compatibility
16. Performance benchmarks
17. System health

**CI vs Local Mode**: Tests adapt based on `$CI` environment variable. In CI, symlink/config tests are skipped since they're not created during tool installation tests.

## Key Plugins & Tools

### Vim/Neovim
- **Vim**: Uses vim-plug with NERDTree, FZF, Fugitive, ALE
- **Neovim**: Uses Lazy.nvim with LSP (Mason), Telescope, Neo-tree, Treesitter
- **Leader key**: Space (consistent across both)
- **Key bindings**: `<leader>f` (find files), `<leader>n` (file tree), `<leader>rg` (search), `<leader>gs` (git status)

### Zsh Plugins (Oh My Zsh)
- `zsh-autosuggestions` - Command completion from history
- `zsh-syntax-highlighting` - Real-time syntax highlighting
- `fast-syntax-highlighting` - Performance-optimized highlighting
- `git` - Git workflow enhancements
- Plus: docker, npm, yarn, tmux, fzf integrations

### Tmux
- **Prefix**: Ctrl+a (not default Ctrl+b)
- **Plugin manager**: TPM (Tmux Plugin Manager)
- **Plugins**: resurrect (session persistence), sensible, yank
- **Split keys**: `Ctrl+a |` (vertical), `Ctrl+a -` (horizontal)

## Important Development Notes

### Modifying Scripts

**Shell Scripts**:
- All scripts use `set -euo pipefail` for safety (except in CI where `set -eo pipefail` is used)
- CI mode detection: Check `${CI:-}` or `${DOTFILES_CI_MODE:-}` variables
- Always source `setup-common.sh` for shared functions
- Use logging functions (`log_info`, `log_success`, etc.) instead of raw echo

**Configuration Files**:
- Zsh configs are modular - edit specific files in `config/zsh/`
- For local customizations, create `*.local` files (e.g., `.zshrc.local`, `.vimrc.local`)
- Never hardcode paths - use variables like `$HOME`, `$DOTFILES_DIR`

### Testing Changes

Always run tests before committing:
```bash
# Full validation
./tests/test-installation.sh --verbose

# Quick health check
./tools/doctor.sh

# Platform-specific
make test-cross-platform
```

### Security Considerations

- Git hooks in `config/git/hooks/` prevent commits with secrets
- Security scanning runs automatically in CI
- Never commit actual credentials - use `.example` templates
- Scripts validate permissions before execution

### Performance Optimization

The configuration is optimized for fast startup:
- **Lazy loading**: Heavy tools (NVM, rbenv) load on first use
- **Caching**: FZF completions, command results cached
- **Conditional loading**: Features load only when tools are available
- **Target**: Shell startup < 500ms (monitored in CI)

## Cross-Platform Compatibility

### Platform-Specific Logic

When adding OS-specific code:
```bash
case "$(uname -s)" in
    Darwin)
        # macOS-specific code
        ;;
    Linux)
        # Linux-specific code
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            case "$ID" in
                ubuntu|debian) ;;
                fedora) ;;
                arch) ;;
            esac
        fi
        ;;
esac
```

### Package Manager Handling

Use the abstraction in `setup-common.sh`:
- `install_package()` automatically detects and uses correct package manager
- Homebrew (macOS), APT (Ubuntu/Debian), DNF (Fedora), Pacman (Arch)

## Common Tasks

### Adding a New CLI Tool

1. Add to appropriate install script: `scripts/install/install-cli-tools.sh` or `install-dev-tools.sh`
2. Add platform-specific package names if they differ
3. Add validation test in `tests/test-installation.sh`
4. Update documentation in `docs/CLI-TOOLS.md`

### Adding a New Alias or Function

1. For aliases: Edit `config/zsh/aliases.zsh`
2. For functions: Edit `config/zsh/functions.zsh`
3. Ensure functions are defined before aliases that use them
4. Test in both local and CI environments

### Supporting a New OS

1. Create `scripts/setup/setup-{distro}.sh`
2. Add OS detection in `setup-common.sh`
3. Create `config/zsh/distro/{distro}.zsh` for OS-specific configs
4. Add CI/CD job in `.github/workflows/ci.yml`
5. Update README.md platform support table

## Troubleshooting

### Common Issues

**Zsh plugins not loading**: Check Oh My Zsh installation and plugin directories in `~/.oh-my-zsh/custom/plugins/`

**Fonts not displaying**: Run `./scripts/install/install-fonts.sh` and refresh font cache (`fc-cache -fv` on Linux)

**Symlinks not created**: Run `./scripts/utils/create-symlinks.sh` manually

**CI tests failing**: Check if tests are CI-aware (should skip symlink/config validation in CI mode)

### Debug Mode

Enable verbose output:
```bash
# For test scripts
VERBOSE=true ./tests/test-installation.sh

# For shell debugging
zsh -xvs
```
