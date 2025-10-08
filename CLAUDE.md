# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Production-ready dotfiles system with automated setup, CI/CD testing across Ubuntu 22.04/24.04, macOS 14+, Fedora, and Arch Linux. Features 70+ modern CLI tools, modular Zsh configuration, and enterprise-grade security scanning.

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
# Run comprehensive test suite (17-category validation)
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

## Critical Architecture Patterns

### Script Error Handling & CI Mode

**All shell scripts follow strict error handling patterns**:
- Local mode: `set -euo pipefail` (fail on undefined variables)
- CI mode: `set -eo pipefail` (more lenient, no `-u` flag)
- CI detection: Check `${CI:-}` or `${DOTFILES_CI_MODE:-}` variables
- Color output disabled in CI: `[[ "${CI:-}" == "true" ]]` disables ANSI codes

**Example pattern used throughout codebase**:
```bash
if [[ "${CI:-}" == "true" ]]; then
    set -eo pipefail  # CI: lenient mode
else
    set -euo pipefail  # Local: strict mode
fi
```

### Modular Zsh Configuration Loading Order

**CRITICAL**: Zsh modules load in a specific order (defined in `config/zsh/.zshrc`):

1. Oh My Zsh framework initialization
2. `exports.zsh` - Environment variables and PATH
3. `functions.zsh` - Function definitions
4. `aliases.zsh` - Command aliases (200+ shortcuts)
5. `distro.zsh` - OS-specific configurations
6. `local.zsh` - User customizations (optional)

**Why this matters**: Functions must be defined before aliases that reference them. Changing the loading order breaks functionality. This is enforced by sourcing files in specific order in `.zshrc`.

### OS Detection System

Multi-method detection approach for reliability (in `scripts/setup/setup-common.sh`):

```bash
detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)
            if [[ -f /etc/os-release ]]; then
                . /etc/os-release; echo "$ID"
            elif command_exists lsb_release; then
                lsb_release -si | tr '[:upper:]' '[:lower:]'
            else
                echo "unknown"
            fi
            ;;
        *) echo "unknown" ;;
    esac
}
```

Priority order:
1. `/etc/os-release` (standard)
2. `lsb_release -si` (if available)
3. `/etc/issue` (fallback)
4. CI environment detection (`$CI` variable)
5. Package manager detection

**Container-Aware**: Scripts adapt behavior in CI (skip symlink tests, disable colors, use defaults).

### Package Management Abstraction Layer

Each OS setup script sources `scripts/setup/setup-common.sh` which provides:
- `install_package()` - Unified cross-platform installation
- `command_exists()` - Check tool availability
- `detect_os()` - OS identification
- `log_info()`, `log_success()`, `log_error()`, `log_warning()` - Logging
- `backup_file()` - Safe backup before overwriting
- `ensure_dir()` - Create directories with logging

**Platform support**: Homebrew (macOS), APT (Ubuntu/Debian), DNF (Fedora), Pacman (Arch)

### CI/CD Testing Framework

The `tests/test-installation.sh` runs 17 validation categories with CI awareness:

- **CI mode detection**: Automatically adapts tests based on `$CI` environment variable
- **Timeout handling**: All CI installations use `timeout 900` (15 minutes) to prevent hangs
- **Skipped in CI**: Symlink validation, config file creation tests (these run only in full installations)
- **Platform-aware**: Tests adapt to available tools per OS

**Key test categories**: Essential commands, CLI tools, symlinks, configs, shell plugins, Starship, fonts, environment variables, script permissions, performance benchmarks, system health.

**CI vs Local Mode**:
- CI: `INSTALL_TYPE=platform` (only tests tool installation, not config placement)
- Local: `INSTALL_TYPE=full` (tests everything including symlinks and configs)

### Security Scanning Pipeline

4-layer security approach in `.github/workflows/ci.yml`:

1. **GitLeaks** - Git history secret detection with SARIF output
2. **TruffleHog** - Entropy-based analysis for secrets
3. **Trivy** - CVE vulnerability scanning and secret detection
4. **Custom Patterns** - Dotfiles-specific validation (SSH keys, certificates, environment files)

**SARIF Integration**: All scanners output SARIF format for GitHub Security tab (when Advanced Security is enabled).

**Artifact Preservation**: 30-day retention of all security scan results as workflow artifacts.

## Key Configuration Details

### Vim/Neovim

**Vim** (`config/vim/.vimrc`):
- Plugin manager: vim-plug
- Plugins: NERDTree, FZF, Fugitive, ALE, Airline
- Leader key: Space

**Neovim** (`config/nvim/init.lua`):
- Plugin manager: Lazy.nvim
- LSP: Mason.nvim for language servers
- Plugins: Telescope, Neo-tree, Treesitter, nvim-cmp, Gitsigns
- Leader key: Space (consistent with Vim)

**Shared key bindings**:
- `<leader>f` - Find files
- `<leader>n` - Toggle file tree
- `<leader>rg` - Search in files
- `<leader>gs` - Git status

### Tmux

- **Prefix**: `Ctrl+a` (NOT the default `Ctrl+b`)
- **Plugin manager**: TPM (Tmux Plugin Manager)
- **Plugins**: resurrect (session persistence), sensible, yank
- **Split bindings**: `Ctrl+a |` (vertical), `Ctrl+a -` (horizontal)

### Zsh Plugins (Oh My Zsh)

Essential plugins in `.zshrc`:
- `zsh-autosuggestions` - Command completion from history
- `zsh-syntax-highlighting` - Real-time syntax highlighting
- `fast-syntax-highlighting` - Performance-optimized highlighting
- `git` - Git workflow enhancements
- Plus: docker, npm, yarn, tmux, fzf integrations

## Common Development Tasks

### Adding a New CLI Tool

1. Add installation logic to `scripts/install/install-cli-tools.sh` or `install-dev-tools.sh`
2. Handle platform-specific package names in the install script
3. Add validation test in `tests/test-installation.sh` (usually in `test_modern_cli_tools()` function)
4. Test in both CI and local environments

### Adding a New Alias or Function

1. **For aliases**: Edit `config/zsh/aliases.zsh`
2. **For functions**: Edit `config/zsh/functions.zsh`
3. **CRITICAL**: Ensure functions are defined before aliases that reference them (maintain loading order)
4. Test in both local and CI environments

### Supporting a New OS

1. Create `scripts/setup/setup-{distro}.sh` following existing patterns
2. Add OS detection case in `setup-common.sh` `detect_os()` function
3. Create `config/zsh/distro/{distro}.zsh` for OS-specific shell configs
4. Add CI job in `.github/workflows/ci.yml` with container image
5. Add to README.md platform support table

### Modifying Shell Scripts

**Critical patterns to follow**:
- Source `setup-common.sh` for shared functions at script start
- Use CI mode detection for environment-specific behavior
- Use logging functions (`log_info`, `log_success`, etc.) instead of raw `echo`
- Never hardcode paths - use `$HOME`, `$DOTFILES_DIR` variables
- Set appropriate error handling mode (see "Script Error Handling & CI Mode" section)

**Example script structure**:
```bash
#!/usr/bin/env bash
set -euo pipefail  # or set -eo pipefail in CI

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

# Source common functions
source "$DOTFILES_DIR/scripts/setup/setup-common.sh"

# Detect environment
if [[ "${CI:-}" == "true" ]]; then
    log_info "Running in CI mode"
fi

# Your logic here using shared functions
```

### Running Tests Before Commit

```bash
# Full validation
./tests/test-installation.sh --verbose

# Quick health check
./tools/doctor.sh

# Specific platform test
make setup-ubuntu && make test
```

## Performance Optimization

The configuration targets **<500ms shell startup** (monitored in CI):

- **Lazy loading**: Heavy tools (NVM, rbenv) load on first use
- **Caching**: FZF completions, command results cached
- **Conditional loading**: Features load only when tools are available
- **Optimized plugin order**: Fast plugins load first

## Platform-Specific Notes

### macOS
- 20+ developer-optimized system settings in setup script
- Homebrew path handling (`/opt/homebrew` for Apple Silicon, `/usr/local` for Intel)
- macOS-specific aliases in `config/zsh/distro/macos.zsh`

### Ubuntu/Debian
- APT package manager with `DEBIAN_FRONTEND=noninteractive` for CI
- Ubuntu 24.04 uses `eza` (migration from deprecated `exa`)
- Repository additions for modern tools (Starship, Lazygit)

### Fedora
- DNF package manager with RPM Fusion repos
- Flatpak integration for GUI apps
- Group install patterns for development tools

### Arch Linux
- Pacman package manager
- AUR support via `yay` (installed if not present)
- Rolling release considerations

## Troubleshooting Patterns

### Debug Mode

Enable verbose output in any script:
```bash
# For test scripts
VERBOSE=true ./tests/test-installation.sh

# For general shell debugging
zsh -xvs

# For CI debugging (in workflow)
env CI=true DOTFILES_CI_MODE=true bash -x ./script.sh
```

### Common Issues

**Zsh plugins not loading**:
- Check Oh My Zsh installation: `ls -la ~/.oh-my-zsh/custom/plugins/`
- Verify plugin directory: `git clone` the missing plugin to `~/.oh-my-zsh/custom/plugins/`

**Fonts not displaying**:
- Re-run: `./scripts/install/install-fonts.sh`
- Refresh font cache (Linux): `fc-cache -fv`

**Symlinks not created**:
- Run manually: `./scripts/utils/create-symlinks.sh`
- Check for existing files blocking symlink creation

**CI tests failing**:
- Verify CI-aware variables are set: `CI=true`, `DOTFILES_CI_MODE=true`, `DOTFILES_SKIP_INTERACTIVE=true`
- Check timeout handling (CI installations use `timeout 900`)
- Ensure tests skip symlink/config validation in CI mode

## Project Statistics

- **Installation Scripts**: 8 comprehensive setup scripts (5 OS-specific + 3 component installers)
- **Test Framework**: 17-category validation suite with CI-aware smart testing
- **Security Integration**: 4 enterprise-grade scanning tools with SARIF reporting
- **CLI Tools Arsenal**: 70+ modern command-line utilities
- **Configuration Files**: 20+ cross-platform dotfiles
- **CI/CD Pipeline**: Multi-OS matrix testing (Ubuntu 22.04/24.04, macOS 14, Fedora, Arch)
- **Performance Target**: <500ms shell startup time (monitored in CI)
