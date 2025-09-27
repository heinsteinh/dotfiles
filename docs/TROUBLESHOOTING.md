# Troubleshooting Guide

## Common Issues

### Fonts Not Displaying Correctly
- Reinstall fonts: \`make install-fonts\`
- Verify font installation: \`fc-list | grep -i meslo\`
- Configure terminal to use Nerd Font

### Zsh Plugins Not Working
- Install Oh My Zsh: \`sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"\`
- Check plugin installation directory
- Reload configuration: \`source ~/.zshrc\`

### Vim Plugins Not Loading
- Install vim-plug: \`:PlugInstall\`
- Update plugins: \`:PlugUpdate\`
- Check vim version compatibility

### Symlinks Not Created
- Run: \`make create-symlinks\`
- Check file permissions
- Verify dotfiles directory path

## Getting Help

1. Check the documentation in \`docs/\`
2. Review configuration files
3. Run health check: \`make health\`
4. Create an issue on GitHub
