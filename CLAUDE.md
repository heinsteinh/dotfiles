# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Production-ready dotfiles system with automated setup, CI/CD testing across Ubuntu 22.04/24.04, macOS 14+, Fedora, and Arch Linux. Features 70+ modern CLI tools, modular Zsh configuration, and enterprise-grade security scanning.

## Common Commands

### Installation & Setup

```bash
# Interactive setup for new machine (recommended)
./tools/workflows/new-machine.sh

# Main installation script (auto-detects OS)
./install.sh

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

# Skip interactive prompts in tests
DOTFILES_SKIP_INTERACTIVE=true ./tests/test-installation.sh

# Run specific test mode (platform only, no symlinks/configs)
INSTALL_TYPE=platform ./tests/test-installation.sh

# Makefile targets
make test              # Run all tests (installation + aliases + functions)
make doctor            # Run diagnostic checks
make health-check      # System health check
make test-cross-platform  # Cross-platform compatibility tests
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

**CRITICAL**: Zsh configuration follows a strict loading sequence in `config/zsh/.zshrc`:

1. **Oh My Zsh framework initialization** (`source $ZSH/oh-my-zsh.sh`)
   - Includes plugins: git, zsh-autosuggestions, zsh-syntax-highlighting, fast-syntax-highlighting
   - Theme: powerlevel10k (configured separately in `.p10k.zsh`)
2. **Environment variables** - Set directly in `.zshrc` (EDITOR, VISUAL, PATH, etc.)
3. **History configuration** - Options like HIST_VERIFY, SHARE_HISTORY set in `.zshrc`
4. **External module files** - Sourced from `~/.config/zsh/` directory:
   - `exports.zsh` - Additional environment variables and PATH extensions
   - `functions.zsh` - Function definitions (50+ utility functions)
   - `aliases.zsh` - Command aliases (200+ shortcuts)
   - `distro.zsh` - OS-specific configurations
   - `local.zsh` - User customizations (optional, not in repo)

**Why loading order matters**:
- Functions MUST be defined before aliases that reference them
- PATH must be set before conditionally loading tools
- Oh My Zsh plugins must load before custom configurations
- Changing the order breaks functionality - this is intentional and enforced

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

**All OS setup scripts MUST source `scripts/setup/setup-common.sh` first** - this provides the core utility library:

**Essential functions**:
- `detect_os()` - Returns: macos, ubuntu, debian, fedora, arch, or unknown
- `command_exists()` - Check if command is available: `command_exists git`
- `install_package()` - Unified installer, auto-detects package manager
- `backup_file()` - Creates timestamped backup: `file.backup.YYYYMMDD_HHMMSS`
- `ensure_dir()` - Create directory with logging
- `download_file()` - Cross-platform download (curl/wget)
- `is_writable()` - Check file/directory write permissions
- `confirm()` - Interactive yes/no prompt (skipped in CI)

**Logging functions** (color-aware, disabled in CI):
- `log_info()` - Blue [INFO] prefix
- `log_success()` - Green [SUCCESS] prefix
- `log_warning()` - Yellow [WARNING] prefix
- `log_error()` - Red [ERROR] prefix

**Oh My Zsh and shell setup**:
- `install_oh_my_zsh()` - Unattended installation
- `install_zsh_plugins()` - Installs autosuggestions, syntax-highlighting, fast-syntax-highlighting, autocomplete, powerlevel10k
- `set_zsh_default()` - Change shell to zsh (skipped in CI)
- `install_starship()` - Install Starship prompt
- `cleanup_temp_files()` - Clean up old temporary files
- `common_setup()` - Runs all common setup tasks

**Platform support**: Homebrew (macOS), APT (Ubuntu/Debian), DNF (Fedora), Pacman (Arch)

### CI/CD Testing Framework

The `tests/test-installation.sh` runs 17 validation categories with intelligent CI/local detection:

**Environment variables that control testing**:
- `CI=true` - Enables CI mode (lenient error handling with `set -eo pipefail`)
- `DOTFILES_CI_MODE=true` - Additional CI mode flag for dotfiles-specific logic
- `DOTFILES_SKIP_INTERACTIVE=true` - Skip interactive prompts (auto-yes)
- `INSTALL_TYPE=platform|minimal|full` - Controls test scope:
  - `platform`: Only test tool installation (CI default, no symlinks/configs)
  - `minimal`: Test minimal installation
  - `full`: Test everything including symlinks and configs (local default)
- `VERBOSE=true` - Enable verbose test output

**Test execution patterns**:
- CI installations use `timeout 900` (15 minutes) to prevent hangs
- Tests in CI skip: symlink validation, config file creation, shell change tests
- All tests track: TESTS_RUN, TESTS_PASSED, TESTS_FAILED with detailed output
- Failed tests are collected in FAILED_TESTS array for summary

**17 test categories**: Essential commands, modern CLI tools, symlinks, configs, Zsh plugins, Starship, fonts, environment variables, script permissions, performance benchmarks, Git config, Vim, Tmux, SSH, system health, cross-platform compatibility.

**GitHub Actions CI/CD**:
- Matrix testing: Ubuntu 22.04/24.04, macOS 14, Fedora, Arch Linux
- Security scanning: GitLeaks, TruffleHog, Trivy, detect-secrets
- Linting: ShellCheck for shell scripts, MarkdownLint for docs
- Performance tests: Shell startup time (<500ms target)
- Documentation checks: README completeness, broken link detection

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
- Plugin manager: vim-plug (auto-installed on first run)
- Plugins: NERDTree, FZF, Fugitive, ALE, Airline, devicons
- Leader key: Space
- Color scheme: Gruvbox (default)
- Install plugins: Open Vim and run `:PlugInstall`

**Neovim** (`config/nvim/init.lua`):
- Plugin manager: Lazy.nvim (auto-installed on first run)
- LSP: Mason.nvim for language servers
- Plugins: Telescope, Neo-tree, Treesitter, nvim-cmp, Gitsigns, Lualine, Which-key
- Leader key: Space (consistent with Vim)
- Install plugins: Open Neovim, Lazy will auto-install or run `:Lazy sync`
- See `config/nvim/README.md` for complete documentation

**Shared key bindings** (Leader = Space):
- `<leader>f` - Find files (FZF in Vim, Telescope in Neovim)
- `<leader>n` - Toggle file tree (NERDTree/Neo-tree)
- `<leader>rg` - Search in files with ripgrep
- `<leader>gs` - Git status

### Tmux

- **Prefix**: `Ctrl+a` (NOT the default `Ctrl+b` - this is intentional)
- **Plugin manager**: TPM (Tmux Plugin Manager) at `~/.tmux/plugins/tpm`
- **Plugins**: resurrect (session persistence), sensible, yank
- **Split bindings**: `Ctrl+a |` (vertical), `Ctrl+a -` (horizontal)
- **Reload config**: `Ctrl+a r`
- **Install plugins**: In tmux, press `Ctrl+a I` (capital I)
- Status bar: Custom with system info and Git integration

### Ghostty Terminal (Optional)

- **Configuration**: `~/.config/ghostty/config`
- **Themes**: 4 included (Gruvbox, Nord, Dracula, One Dark)
- **Default theme**: Gruvbox (change via `theme = nord` in config)
- **Leader key**: `Cmd` (macOS) / `Super` (Linux)
- **Installation**: Use `--ghostty` or `--full` flag during setup

**Key bindings** (macOS, using `Cmd` = Super):
- `Cmd+T` - New tab
- `Cmd+W` - Close tab
- `Cmd+D` - Split right
- `Cmd+Shift+D` - Split down
- `Cmd+N` - New window
- `Cmd++/-` - Increase/decrease font size
- `Cmd+0` - Reset font size
- `Cmd+F` - Search/quick terminal
- `Cmd+K` - Clear screen

**Customization**:
- Local config: `~/.config/ghostty/local.conf` (not tracked in git)
- Add machine-specific settings without modifying main config
- Copy from `local.conf.example` template

**Platform-specific installation**:
- **macOS**: `brew install --cask ghostty` (Homebrew)
- **Arch**: `sudo pacman -S ghostty` (official repos)
- **Fedora**: COPR repository (`scottames/ghostty`)
- **Ubuntu/Debian**: Build from source (requires Zig 0.13+)

See `config/ghostty/README.md` for complete documentation.

### Zsh Plugins (Oh My Zsh)

Essential plugins loaded in `.zshrc`:
- `git` - Git aliases and workflow enhancements
- `zsh-autosuggestions` - Command completion from history (gray text)
- `zsh-syntax-highlighting` - Real-time syntax highlighting
- `fast-syntax-highlighting` - Performance-optimized highlighting
- `sudo` - Press ESC twice to add sudo to command
- `docker`, `docker-compose` - Docker aliases and completions
- `npm`, `yarn`, `pip`, `python`, `virtualenv` - Language tooling
- `tmux` - Tmux integration
- `fzf` - Fuzzy finder integration
- `systemd`, `ssh-agent`, `gpg-agent` - System utilities

**Theme**: powerlevel10k (configured in `~/.p10k.zsh`)
- Run `p10k configure` to reconfigure theme

## Common Development Tasks

### Adding a New CLI Tool

1. **Choose the right installer script**:
   - `scripts/install/install-cli-tools.sh` - For general CLI utilities (ripgrep, fzf, bat, etc.)
   - `scripts/install/install-dev-tools.sh` - For development environments (Node.js, Python, Go, etc.)

2. **Add installation logic** with platform-specific handling:
   ```bash
   # Example pattern in install-cli-tools.sh
   if ! command_exists tool_name; then
       case "$OS" in
           macos) brew install tool-name ;;
           ubuntu|debian) sudo apt install -y tool-name ;;
           fedora) sudo dnf install -y tool-name ;;
           arch) sudo pacman -S --noconfirm tool-name ;;
       esac
   fi
   ```

3. **Add validation test** in `tests/test-installation.sh`:
   - For CLI tools: Add to `test_modern_cli_tools()` function
   - For dev tools: Add to `test_development_tools()` function
   - Use pattern: `command_exists tool_name || { log_error "Tool not found"; return 1; }`

4. **Test in both environments**:
   - Local: `./scripts/install/install-cli-tools.sh && ./tests/test-installation.sh`
   - CI simulation: `CI=true DOTFILES_CI_MODE=true ./tests/test-installation.sh`

### Adding a New Alias or Function

1. **For aliases**: Edit `config/zsh/aliases.zsh`
   - Group by category (file operations, git, docker, system, etc.)
   - Add comments explaining non-obvious aliases
   - Example: `alias ll='eza -lah --icons --git'`

2. **For functions**: Edit `config/zsh/functions.zsh`
   - Add function with clear documentation
   - Include error handling
   - Example pattern:
     ```bash
     # Description of what function does
     function_name() {
         if ! command_exists dependency; then
             echo "Error: dependency not found"
             return 1
         fi
         # Function logic here
     }
     ```

3. **CRITICAL**: Maintain loading order
   - Functions MUST be in `functions.zsh`
   - Aliases that call functions MUST be in `aliases.zsh`
   - Never define functions in `aliases.zsh` or vice versa

4. **Test the new alias/function**:
   - Test in new shell: `zsh -c 'source ~/.zshrc && your_function'`
   - Add test in `tests/test-functions.sh` or `tests/test-aliases.sh`
   - Ensure it works in both interactive and non-interactive modes

### Supporting a New OS

1. **Create setup script**: `scripts/setup/setup-{distro}.sh`
   - Copy pattern from existing setup scripts
   - Source `setup-common.sh` at the top
   - Implement OS-specific package installation
   - Handle package manager initialization

2. **Update OS detection**: Edit `scripts/setup/setup-common.sh`
   - Add case in `detect_os()` function
   - Test detection: `bash -c 'source scripts/setup/setup-common.sh && detect_os'`

3. **Create distro-specific shell config**: `config/zsh/distro/{distro}.zsh`
   - Add OS-specific aliases and environment variables
   - Handle distro-specific paths and tools
   - Source this in `config/zsh/distro.zsh`

4. **Add CI testing**: Edit `.github/workflows/ci.yml`
   - Add new job with container image for the OS
   - Follow pattern from existing test-ubuntu/test-fedora/test-arch jobs
   - Test both installation and validation

5. **Update documentation**:
   - Add to platform support table in README.md
   - Update installation instructions
   - Add any distro-specific notes

### Modifying Shell Scripts

**Critical patterns to follow**:
- Source `setup-common.sh` for shared functions at script start
- Use CI mode detection for environment-specific behavior
- Use logging functions (`log_info`, `log_success`, etc.) instead of raw `echo`
- Never hardcode paths - use `$HOME`, `$DOTFILES_DIR` variables
- Set appropriate error handling mode (see "Script Error Handling & CI Mode" section)
- Make scripts executable: `chmod +x script.sh`
- Use ShellCheck for linting: `shellcheck script.sh`

**Standard script template**:
```bash
#!/usr/bin/env bash
# Script description here

# Error handling (adjust based on CI/local)
if [[ "${CI:-}" == "true" ]]; then
    set -eo pipefail  # CI: lenient mode
else
    set -euo pipefail  # Local: strict mode
fi

# Get script directory (for relative path resolution)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"  # Adjust ../ depth as needed

# Source common functions
source "$DOTFILES_DIR/scripts/setup/setup-common.sh"

# Detect environment
if [[ "${CI:-}" == "true" ]]; then
    log_info "Running in CI mode"
fi

# Your script logic here using:
# - command_exists for checking tools
# - install_package for installing packages
# - log_* for output
# - backup_file before modifying configs
```

### Running Tests Before Commit

```bash
# Full validation
./tests/test-installation.sh --verbose

# Quick health check
./tools/doctor.sh

# Run specific test suite
./tests/test-aliases.sh
./tests/test-functions.sh

# Lint shell scripts
find scripts/ -name "*.sh" -exec shellcheck {} \;

# Test in CI mode
CI=true DOTFILES_CI_MODE=true ./tests/test-installation.sh

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

## Important File Locations

### Installation Entry Points
- `install.sh` - Main installation script (auto-detects OS)
- `tools/workflows/new-machine.sh` - Interactive new machine setup wizard

### Core Setup Scripts
- `scripts/setup/setup-common.sh` - **Shared utility library (source this first)**
- `scripts/setup/setup-ubuntu.sh` - Ubuntu/Debian setup
- `scripts/setup/setup-macos.sh` - macOS setup
- `scripts/setup/setup-fedora.sh` - Fedora setup
- `scripts/setup/setup-arch.sh` - Arch Linux setup

### Component Installers
- `scripts/install/install-cli-tools.sh` - Modern CLI utilities (ripgrep, fzf, bat, etc.)
- `scripts/install/install-dev-tools.sh` - Development environments (Node, Python, Go, Rust)
- `scripts/install/install-fonts.sh` - Nerd Fonts installation
- `scripts/utils/create-symlinks.sh` - Symlink dotfiles to home directory

### Configuration Files (Source)
- `config/zsh/.zshrc` - Main Zsh configuration
- `config/zsh/aliases.zsh` - 200+ command aliases
- `config/zsh/functions.zsh` - 50+ utility functions
- `config/zsh/exports.zsh` - Environment variables
- `config/zsh/distro.zsh` - OS-specific configurations
- `config/vim/.vimrc` - Vim configuration
- `config/nvim/init.lua` - Neovim configuration
- `config/tmux/.tmux.conf` - Tmux configuration
- `config/git/.gitconfig` - Git configuration

### Testing Framework
- `tests/test-installation.sh` - Main test suite (17 categories)
- `tests/test-aliases.sh` - Alias validation
- `tests/test-functions.sh` - Function validation
- `tests/test-cross-platform.sh` - Cross-platform compatibility

### CI/CD
- `.github/workflows/ci.yml` - Main CI/CD pipeline (900+ lines)
  - Multi-OS matrix testing
  - Security scanning
  - Performance tests
  - Linting and documentation checks

### Maintenance Scripts
- `scripts/maintenance/update-all.sh` - Update all tools and dependencies
- `scripts/maintenance/cleanup.sh` - Clean temporary files
- `scripts/maintenance/backup-dotfiles.sh` - Backup existing configs
- `scripts/maintenance/health-check.sh` - System health check
- `tools/doctor.sh` - Diagnostic checks

## Key Environment Variables

### CI/CD Control Variables
- `CI=true` - Enable CI mode (lenient error handling, no colors)
- `DOTFILES_CI_MODE=true` - Additional CI mode indicator
- `DOTFILES_SKIP_INTERACTIVE=true` - Skip all interactive prompts
- `VERBOSE=true` - Enable verbose output in tests

### Installation Control
- `INSTALL_TYPE=platform|minimal|full` - Control installation scope
- `DEBIAN_FRONTEND=noninteractive` - Non-interactive Debian/Ubuntu installs
- `DOTFILES_DIR` - Dotfiles directory location (auto-detected)

### Testing Control
- `SKIP_INTERACTIVE=true` - Skip interactive tests
- `TEST_DIR` - Temporary directory for tests

### Shell Configuration
- `ZSH` - Oh My Zsh installation directory (`$HOME/.oh-my-zsh`)
- `ZSH_CUSTOM` - Oh My Zsh custom plugins/themes directory

## Project Statistics

- **Installation Scripts**: 8 comprehensive setup scripts (5 OS-specific + 3 component installers)
- **Test Framework**: 17-category validation suite with CI-aware smart testing
- **Security Integration**: 4 enterprise-grade scanning tools with SARIF reporting
- **CLI Tools Arsenal**: 70+ modern command-line utilities
- **Configuration Files**: 20+ cross-platform dotfiles
- **CI/CD Pipeline**: Multi-OS matrix testing (Ubuntu 22.04/24.04, macOS 14, Fedora, Arch)
- **Performance Target**: <500ms shell startup time (monitored in CI)
- **Documentation**: 8 comprehensive guides (4,600+ lines total)
