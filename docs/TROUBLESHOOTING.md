# 🔧 Troubleshooting Guide

Comprehensive troubleshooting guide for resolving issues across all supported platforms. Updated with latest CI/CD fixes and platform-specific solutions.

## 🔧 Installation Issues

### macOS Homebrew Issues (Enhanced with v2.0 fixes)
```bash
# Error: homebrew/homebrew-cask-fonts does not exist!
# Solution: Automated cleanup in setup-macos.sh handles deprecated taps
brew untap homebrew/homebrew-cask-fonts 2>/dev/null || true
brew tap homebrew/cask-fonts

# Permission denied errors during brew cleanup (fixed in setup script)
sudo chown -R $(whoami) ~/Library/Caches/Homebrew/
export HOMEBREW_NO_INSTALL_CLEANUP=1
export HOMEBREW_NO_ENV_HINTS=1
brew cleanup

# Homebrew PATH issues (Apple Silicon) - auto-detected
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Tap already exists issues (fixed)
brew tap --repair
brew tap --list-official | head -5  # Verify taps are working
```

### Ubuntu 24.04 Package Issues (Fixed in v2.0)
```bash
# Error: Package 'exa' has no installation candidate
# Solution: Automatic migration to 'eza' (handled by setup scripts)
sudo apt update
sudo apt install eza  # Modern replacement for exa

# Legacy fallback if eza unavailable (backup in aliases.zsh)
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --group-directories-first'
elif command -v exa >/dev/null 2>&1; then
    alias ls='exa --group-directories-first'
else
    alias ls='ls --color=auto'  # Traditional fallback
fi

# Manual eza installation if needed
curl -L https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz | tar -xz
sudo mv eza /usr/local/bin/
chmod +x /usr/local/bin/eza
```

### Permission Issues
```bash
# Make install script executable
chmod +x install.sh

# Fix ownership of dotfiles directory
sudo chown -R $USER:$USER ~/.config/

# Fix symlink permissions
find ~/.config -type l -exec ls -la {} \;

# macOS-specific permission fixes
sudo chown -R $(whoami) ~/Library/Fonts/
sudo chown -R $(whoami) ~/Library/Caches/Homebrew/
```

## Shell Configuration Issues

### Function/Alias Conflicts
```bash
# Error: "defining function based on alias 'function_name'"
# This happens when aliases are loaded before functions

# Check for conflicts
grep -r "^alias backup" ~/.config/zsh/
grep -r "^backup(" ~/.config/zsh/

# Solution: Functions are loaded before aliases in proper order
# If still having issues, check ~/.zshrc loading sequence
```

### Parse Errors in Zsh
```bash
# Error: "parse error near '()'"
# Usually caused by alias expansion in function definitions

# Debug syntax
zsh -n ~/.config/zsh/functions.zsh
zsh -n ~/.config/zsh/aliases.zsh

# Check specific function
zsh -c 'source ~/.config/zsh/functions.zsh && declare -f function_name'

# Use 'command' prefix to bypass aliases in functions
# Example: command cp instead of cp
```

### FZF Recursion Issues
```bash
# Error: Maximum function depth exceeded
# Solution: Functions use 'command' prefix to prevent recursion

# Check FZF key bindings
fzf --version
grep -r "bindkey" ~/.config/fzf/

# Reset FZF if needed
rm -rf ~/.fzf
git clone https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### Zsh Module Loading
```bash
# Check loading order (should be functions → aliases)
grep "source.*functions" ~/.zshrc
grep "source.*aliases" ~/.zshrc

# Reload with debug
zsh -x ~/.zshrc 2>&1 | head -50

# Test individual modules
source ~/.config/zsh/functions.zsh  # Should load without errors
source ~/.config/zsh/aliases.zsh    # Should load after functions
```

## Tool-Specific Issues

### Fonts Not Displaying Correctly
```bash
# Reinstall fonts
./scripts/install/install-fonts.sh

# macOS-specific font issues
sudo atsutil databases -remove  # Clear font cache
# System Preferences → Displays → Color → Calibrate (if colors look off)

# Linux font issues
fc-cache -fv  # Refresh font cache
fc-list | grep -i nerd  # Verify Nerd Fonts

# Verify font installation
fc-list | grep -i meslo
fc-list | grep -i "JetBrains Mono"
fc-list | grep -i "Fira Code"

# Configure terminal to use Nerd Font
# For Kitty: font_family JetBrainsMono Nerd Font Mono
# For iTerm2: Preferences → Profiles → Text → Font
# For VS Code: "terminal.integrated.fontFamily": "JetBrainsMono Nerd Font Mono"
```

### Zsh Plugins Not Working
```bash
# Install Oh My Zsh if missing
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Check plugin installation
ls -la ~/.oh-my-zsh/plugins/
ls -la ~/.oh-my-zsh/custom/plugins/

# Reload configuration
source ~/.zshrc

# Debug plugin loading
echo $plugins
```

### Vim Plugins Not Loading
```bash
# Install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install plugins
vim +PlugInstall +qall

# Update plugins
vim +PlugUpdate +qall

# Check vim version compatibility
vim --version | head -5
```

### Git Configuration Issues
```bash
# Check git configuration
git config --list --global

# Fix git user configuration
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"

# Check git hooks
ls -la ~/.config/git/hooks/

# Test git aliases
git config --get-regexp alias
```

### Symlinks Not Created
```bash
# Run symlink creation
make create-symlinks

# Check existing symlinks
find ~/.config -type l -ls

# Manually create missing symlinks
ln -sf ~/dotfiles/config/zsh/.zshrc ~/.zshrc
ln -sf ~/dotfiles/config/tmux/.tmux.conf ~/.tmux.conf

# Verify symlink targets
ls -la ~/.zshrc ~/.tmux.conf
```

## 🍎 macOS-Specific Issues

### System Settings Not Applied
```bash
# Settings require restart to take effect
sudo shutdown -r now

# Force reload system services
killall Dock
killall Finder
killall SystemUIServer

# Check if settings were applied
defaults read com.apple.dock autohide
defaults read com.apple.finder AppleShowAllFiles
```

### macOS Development Issues
```bash
# Install Xcode command line tools
xcode-select --install

# Install Homebrew if missing
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Fix PATH for Homebrew (Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile

# Corporate/managed Mac issues
# Some settings may be restricted by IT policies
# Check: System Preferences → Profiles for management restrictions
```

### macOS Key Repeat Issues
```bash
# If key repeat settings don't work:
# System Preferences → Keyboard → Key Repeat (set to Fast)
# System Preferences → Keyboard → Delay Until Repeat (set to Short)

# Force apply via defaults (requires restart)
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10
```

## 🐧 Linux-Specific Issues

### Linux Distribution Issues
```bash
# Ubuntu/Debian
sudo apt update && sudo apt upgrade

# Arch Linux
sudo pacman -Syu

# Fedora
sudo dnf update

# Check package manager
which apt || which pacman || which dnf || which brew
```

## 🆕 CI/CD & Testing Issues (New in v2.0)

### Test Script Hanging
```bash
# Error: Tests hang on remote systems or CI
# Solution: Enhanced timeout handling (fixed in test-installation.sh)
export CI=true  # Enable CI-aware mode
export INSTALLATION_TYPE="minimal"  # Skip heavy configurations
./tests/test-installation.sh --timeout=30

# Debug test hanging
./tests/test-installation.sh --verbose --debug
```

### GitHub Actions Failures
```bash
# Container resource issues (fixed)
# Enhanced error handling with proper exit codes
if ! command -v tool >/dev/null 2>&1; then
    echo "Warning: tool not available in CI environment"
    exit 0  # Don't fail CI for optional tools
fi

# Memory issues in containers
ulimit -v 2048000  # Limit virtual memory
export NODE_OPTIONS="--max-old-space-size=1024"
```

### Security Scanning False Positives
```bash
# GitLeaks/TruffleHog false positives
# Add to .gitleaksignore or .truffletogignore
echo "path/to/false/positive:generic-api-key" >> .gitleaksignore

# Review security scan results
find .github/sarif-results/ -name "*.sarif" | head -3
```

## 🧪 Performance Troubleshooting

### Shell Startup Time Issues
```bash
# Profile zsh startup (should be <500ms)
time zsh -i -c exit

# Identify slow components
zsh -xvs 2>&1 | head -20

# Disable heavy plugins temporarily
sed -i 's/plugins=(/plugins=(#/' ~/.zshrc
source ~/.zshrc
# Re-enable: sed -i 's/plugins=(#/plugins=(/' ~/.zshrc
```

### System Resource Issues
```bash
# Monitor resource usage
htop        # Interactive process viewer
btop        # Modern alternative
iostat 1    # I/O statistics
free -h     # Memory usage

# Clean up system resources
./scripts/maintenance/cleanup.sh
sudo apt autoremove  # Ubuntu/Debian
brew cleanup         # macOS
```

## 🆘 Getting Help

### Self-Diagnosis Tools
```bash
# Run comprehensive health check
./tools/doctor.sh

# Test specific components
./tests/test-installation.sh --verbose

# Check system compatibility
./scripts/debug/test-ci-detection.sh
```

### Support Channels
1. **📚 Documentation**: Check comprehensive guides in `docs/`
2. **🔍 Search Issues**: Review existing GitHub issues and solutions
3. **🧪 Run Tests**: Use built-in diagnostic tools
4. **🆕 Create Issue**: Report bugs with system info and logs
5. **💬 Discussion**: Join community discussions for tips and tricks

### Bug Report Template
```bash
# Include this information when reporting issues:
uname -a                    # System information
echo $SHELL                 # Shell version
cat /etc/os-release        # OS details
./tests/test-installation.sh --verbose  # Test results
```
