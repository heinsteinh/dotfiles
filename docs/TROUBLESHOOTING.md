# Troubleshooting Guide

Complete troubleshooting guide for common issues across all supported platforms.

## 🔧 Installation Issues

### macOS Homebrew Issues
```bash
# Error: homebrew/homebrew-cask-fonts does not exist!
# Solution: Clean up deprecated taps (automatically handled by setup)
brew untap homebrew/homebrew-cask-fonts
brew tap homebrew/cask-fonts

# Permission denied errors during brew cleanup
sudo chown -R $(whoami) ~/Library/Caches/Homebrew/
brew cleanup

# Homebrew PATH issues (Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
source ~/.zprofile
```

### Ubuntu 24.04 Package Issues
```bash
# Error: Package 'exa' has no installation candidate
# Solution: Use eza instead (automatically handled by setup scripts)
sudo apt update
sudo apt install eza

# If eza is not available in repositories
wget https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz
tar -xzf eza_*.tar.gz
sudo mv eza /usr/local/bin/
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

## Getting Help

1. Check the documentation in \`docs/\`
2. Review configuration files
3. Run health check: \`make health\`
4. Create an issue on GitHub
