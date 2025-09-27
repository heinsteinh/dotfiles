# Installation Guide

## Quick Installation

\`\`\`bash
git clone https://github.com/GITHUB_USER/REPO_NAME.git ~/.dotfiles
cd ~/.dotfiles
make install
\`\`\`

## Platform-Specific Installation

### Arch Linux
\`\`\`bash
make install-arch
\`\`\`

### Ubuntu/Debian
\`\`\`bash
make install-ubuntu
\`\`\`

### macOS
\`\`\`bash
make install-macos
\`\`\`

## Manual Installation

1. Clone the repository
2. Run platform-specific setup script
3. Install fonts: \`make install-fonts\`
4. Install CLI tools: \`make install-cli\`
5. Create symlinks: \`make create-symlinks\`

## Post-Installation

1. Restart your terminal
2. Run \`source ~/.zshrc\`
3. Install vim plugins: \`:PlugInstall\`
4. Configure git user information

## Customization

Create local override files:
- \`~/.vimrc.local\`
- \`~/.zshrc.local\`
- \`~/.tmux.conf.local\`

These files will be automatically sourced and are gitignored.
