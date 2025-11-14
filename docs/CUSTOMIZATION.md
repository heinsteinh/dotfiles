# Customization Guide

This guide explains how to customize your dotfiles configuration to fit your personal preferences and workflow.

## Overview

The dotfiles are designed to be modular and easily customizable. Each configuration can be overridden with local settings that won't be committed to git.

## Local Configuration Files

### Zsh Customization

Create `config/zsh/local.zsh` to add personal zsh configurations:

```bash
# Example local zsh config
alias myproject="cd ~/Projects/important-project"
export CUSTOM_PATH="$HOME/my-tools/bin:$PATH"

# Custom functions
function weather() {
    curl wttr.in/$1
}
```

### Vim Customization

Create `config/vim/local.vim` for personal vim settings:

```vim
" Example local vim config
colorscheme dracula
set relativenumber
let g:airline_theme = 'dracula'
```

### Neovim Customization

Create `config/nvim/local.lua` for personal neovim settings:

```lua
-- Example local neovim config
vim.cmd("colorscheme nord")
vim.opt.relativenumber = true

-- Custom keymaps
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })

-- LSP settings
require("lspconfig").pyright.setup({
  -- custom pyright settings
})
```

The Neovim configuration uses Lua and provides more advanced customization options. See `config/nvim/README.md` for detailed documentation.

### Tmux Customization

Create `config/tmux/local.tmux.conf` for tmux overrides:

```bash
# Example local tmux config
set -g status-position top
bind-key r source-file ~/.tmux.conf \; display-message "Config reloaded!"
```

### Git Customization

Copy `templates/.gitconfig.template` to `local/config/.gitconfig`:

```ini
[user]
    name = Your Name
    email = your.email@example.com

[core]
    editor = vim
```

## Environment-Specific Configurations

### Work Environment

Create work-specific configurations in the `local/` directory:

```bash
# local/config/work.zsh
export WORK_MODE=true
alias vpn="sudo openconnect company-vpn.com"
alias deploy="kubectl apply -f deployment.yaml"
```

### Development Projects

Create project-specific configurations:

```bash
# local/scripts/project-setup.sh
#!/bin/bash
cd ~/Projects/main-project
docker-compose up -d
npm run dev
```

## Theme Customization

### Terminal Colors

The dotfiles include several pre-configured themes:

- **Gruvbox**: Warm, retro feel
- **Dracula**: Dark theme with vibrant colors
- **Nord**: Arctic, north-bluish clean theme

To change themes:

1. **Kitty**: Edit `config/kitty/kitty.conf` and change the include line
2. **Vim**: Add `colorscheme <theme>` to `config/vim/local.vim`
3. **Tmux**: Modify status bar colors in `config/tmux/local.tmux.conf`

### Custom Theme Creation

Create your own theme by:

1. Adding color definitions to `config/kitty/themes/mytheme.conf`
2. Creating corresponding vim colorscheme
3. Updating tmux status bar colors

## Key Bindings

### Custom Key Bindings

Add personal key bindings to respective local config files:

```bash
# Zsh key bindings (local.zsh)
bindkey '^P' history-search-backward
bindkey '^N' history-search-forward
```

```vim
" Vim key bindings (local.vim)
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
```

```bash
# Tmux key bindings (local.tmux.conf)
bind-key h select-pane -L
bind-key j select-pane -D
bind-key k select-pane -U
bind-key l select-pane -R
```

## Plugin Management

### Adding Vim Plugins

Edit `config/vim/plugins.vim` and add your plugin:

```vim
Plug 'plugin-author/plugin-name'
```

Then run `:PlugInstall` in vim.

### Adding Zsh Plugins

For Oh My Zsh plugins, edit your local zsh config:

```bash
# Add to local.zsh
plugins=(git docker kubectl)
```

### Adding Tmux Plugins

If using Tmux Plugin Manager, add to your local tmux config:

```bash
set -g @plugin 'tmux-plugins/tmux-battery'
```

## Font Configuration

### Installing Additional Fonts

1. Download your preferred Nerd Font
2. Place it in `fonts/YourFont/` directory
3. Run `scripts/install/install-fonts.sh`
4. Update terminal configuration to use the new font

### Font Size and Settings

Update font settings in:
- **Kitty**: `config/kitty/kitty.conf`
- **VS Code**: Via settings JSON
- **Terminal**: Via system preferences

## Aliases and Functions

### Personal Aliases

Add to `config/zsh/local.zsh`:

```bash
# Development aliases
alias dc='docker-compose'
alias k='kubectl'
alias tf='terraform'

# System aliases
alias ll='ls -la'
alias grep='rg'
alias cat='bat'
```

### Custom Functions

Create utility functions:

```bash
# Function to create and enter directory
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Function to find and kill process
fkill() {
    ps aux | grep "$1" | grep -v grep | awk '{print $2}' | xargs kill
}
```

## Environment Variables

### Development Environment

Set up development paths in local configs:

```bash
# local/config/dev.zsh
export JAVA_HOME=/usr/local/opt/openjdk
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$ANDROID_HOME/platform-tools:$PATH
```

### API Keys and Secrets

Store sensitive information in local files (never commit these):

```bash
# local/config/secrets.zsh (add to .gitignore)
export AWS_ACCESS_KEY_ID="your-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export GITHUB_TOKEN="your-github-token"
```

## Machine-Specific Settings

### macOS Specific

```bash
# local/config/macos.zsh
export HOMEBREW_PREFIX="/opt/homebrew"
alias finder="open ."
```

### Linux Specific

```bash
# local/config/linux.zsh
alias pbcopy='xclip -selection clipboard'
alias pbpaste='xclip -selection clipboard -o'
```

## Backup and Sync

### Personal Backup Strategy

1. Keep local configs in a private repository
2. Use symlinks to sync between machines
3. Regular backups of important local files

### Version Control for Local Changes

```bash
# Initialize local git repo
cd local/
git init
git add .
git commit -m "Initial local configuration"
```

## Troubleshooting

### Common Issues

1. **Symlinks not working**: Check file permissions
2. **Plugins not loading**: Verify plugin manager installation
3. **Colors not displaying**: Ensure terminal supports 256 colors

### Debug Mode

Enable debug mode for troubleshooting:

```bash
# Add to local config
export DEBUG_DOTFILES=true
```

## Migration Between Machines

### Export Current Settings

```bash
# Create settings export
./scripts/utils/backup-dotfiles.sh
```

### Import on New Machine

```bash
# Import backed up settings
./scripts/utils/restore-dotfiles.sh backup.tar.gz
```

## Contributing Back

If you create useful customizations:

1. Create a template version (remove personal info)
2. Submit a pull request
3. Document the customization in this guide

## Additional Resources

- [Installation Guide](INSTALLATION.md) - Complete setup instructions
- [CLI Tools Reference](CLI-TOOLS.md) - Modern CLI tools documentation
- [Troubleshooting Guide](TROUBLESHOOTING.md) - Common issues and solutions
