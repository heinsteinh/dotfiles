# Ghostty Terminal Configuration

Fast, feature-rich, cross-platform terminal emulator with GPU acceleration.

## Features

- **Fast Performance**: GPU-accelerated rendering
- **Native UI**: Platform-native look (AppKit on macOS, GTK4 on Linux)
- **Cross-Platform**: Consistent experience across macOS and Linux
- **Modern Features**: Tabs, splits, ligatures, true color
- **Extensible**: Rich configuration and theming support

## Installation

### Automated Installation

Ghostty is installed automatically when using the `--ghostty` or `--full` flag:

```bash
# Install with Ghostty support
./install.sh --ghostty

# Or full installation (includes Ghostty)
./install.sh --full
```

### Manual Installation

#### macOS (Homebrew)
```bash
brew install --cask ghostty
```

#### Arch Linux
```bash
sudo pacman -S ghostty
```

#### Fedora (COPR)
```bash
sudo dnf copr enable scottames/ghostty
sudo dnf install ghostty
```

#### Ubuntu/Debian (Build from Source)
```bash
# Install dependencies
sudo apt install libgtk-4-dev libgtk4-layer-shell-dev libadwaita-1-dev gettext libxml2-utils

# Install Zig 0.13 (required)
# Follow instructions at: https://ziglang.org/download/

# Clone and build
git clone https://github.com/ghostty-org/ghostty.git
cd ghostty
zig build -p $HOME/.local -Doptimize=ReleaseFast
```

## Configuration

Configuration file: `~/.config/ghostty/config`

The configuration is automatically symlinked when running:
```bash
./scripts/utils/create-symlinks.sh
```

### Structure

```
~/.config/ghostty/
├── config              # Main configuration (symlinked from dotfiles)
├── themes/             # Theme files (symlinked from dotfiles)
│   ├── gruvbox.conf
│   ├── nord.conf
│   ├── dracula.conf
│   └── one-dark.conf
└── local.conf          # Local overrides (NOT in git)
```

## Themes

Switch themes by editing `~/.config/ghostty/config` or `~/.config/ghostty/local.conf`:

```bash
# In config or local.conf
theme = nord
```

Available themes:
- **gruvbox** (default) - Warm, retro color scheme
- **nord** - Arctic, bluish palette
- **dracula** - Dark purple theme
- **one-dark** - Atom's iconic dark theme

### Temporary Theme Override

Start Ghostty with a specific theme:
```bash
ghostty -e theme=nord
```

## Keybindings

### Default Keybindings (macOS-style, using `super` = Cmd/Win)

#### Window & Tab Management
| Keybinding | Action |
|------------|--------|
| `Cmd+N` | New window |
| `Cmd+T` | New tab |
| `Cmd+W` | Close tab/split |
| `Cmd+Q` | Quit |
| `Cmd+Shift+[` | Previous tab |
| `Cmd+Shift+]` | Next tab |
| `Cmd+1-9` | Go to tab 1-9 |

#### Splits
| Keybinding | Action |
|------------|--------|
| `Cmd+D` | Split right |
| `Cmd+Shift+D` | Split down |
| `Cmd+Shift+W` | Close split |
| `Cmd+Shift+H` | Go to left split |
| `Cmd+Shift+L` | Go to right split |
| `Cmd+Shift+K` | Go to top split |
| `Cmd+Shift+J` | Go to bottom split |

#### Text & Clipboard
| Keybinding | Action |
|------------|--------|
| `Cmd+C` | Copy |
| `Cmd+V` | Paste |
| `Cmd+F` | Quick terminal/search |
| `Cmd+K` | Clear screen |

#### Font Size
| Keybinding | Action |
|------------|--------|
| `Cmd++` | Increase font size |
| `Cmd+-` | Decrease font size |
| `Cmd+0` | Reset font size |

#### Scrollback
| Keybinding | Action |
|------------|--------|
| `Cmd+↑` | Scroll page up |
| `Cmd+↓` | Scroll page down |
| `Cmd+Home` | Scroll to top |
| `Cmd+End` | Scroll to bottom |

#### Display
| Keybinding | Action |
|------------|--------|
| `Cmd+Enter` | Toggle fullscreen |

## Customization

### Local Configuration

Create `~/.config/ghostty/local.conf` for machine-specific settings:

```bash
# Copy example template
cp ~/.config/ghostty/local.conf.example ~/.config/ghostty/local.conf

# Edit with your preferences
vim ~/.config/ghostty/local.conf
```

Example local customizations:
```bash
# Override theme
theme = dracula

# Increase font size for 4K display
font-size = 16

# Disable transparency
background-opacity = 1.0

# Use different shell
command = /usr/bin/fish
```

### Custom Keybindings

Add to `local.conf`:
```bash
# Custom split navigation (Vim-style)
keybind = ctrl+h=goto_split:left
keybind = ctrl+l=goto_split:right
keybind = ctrl+k=goto_split:top
keybind = ctrl+j=goto_split:bottom
```

### Font Configuration

The default font is **JetBrainsMono Nerd Font**. To change:

```bash
# In local.conf
font-family = "FiraCode Nerd Font"
font-size = 14
```

Install Nerd Fonts:
```bash
./scripts/install/install-fonts.sh
```

## Shell Integration

Ghostty automatically detects and enables shell integration for:
- Zsh (detects Oh My Zsh)
- Bash
- Fish

Features include:
- Command tracking
- Directory tracking
- Sudo feedback
- Custom title support

## Performance Tips

1. **Use GPU acceleration** (enabled by default)
2. **Disable transparency** if you experience lag:
   ```bash
   background-opacity = 1.0
   ```
3. **Reduce scrollback** for better memory usage:
   ```bash
   scrollback-limit = 5000
   ```
4. **Disable cursor blinking**:
   ```bash
   cursor-style-blink = false
   ```

## Troubleshooting

### Fonts not rendering correctly
1. Ensure Nerd Fonts are installed: `./scripts/install/install-fonts.sh`
2. Verify font name: `fc-list | grep "JetBrains"`
3. Reload font cache (Linux): `fc-cache -fv`

### Theme not applying
1. Check theme file exists: `ls ~/.config/ghostty/themes/`
2. Verify `theme =` line in config
3. Check for syntax errors: `ghostty --config-check`

### Keybindings not working
1. Check for conflicts with system keybindings
2. Verify syntax in config: `keybind = trigger=action`
3. Test with different modifier (e.g., `ctrl` instead of `super`)

### macOS-specific: Ghostty not opening
1. Check macOS version: Requires macOS 13+ (Ventura)
2. Grant accessibility permissions: System Settings → Privacy & Security → Accessibility

### Linux-specific: Build failures
1. Verify Zig version: Must be 0.13 or 0.14
2. Install all dependencies (see Installation section)
3. For Ubuntu 24.04/Debian 12, use: `-fno-sys=gtk4-layer-shell`

## Resources

- **Official Documentation**: https://ghostty.org/docs
- **GitHub Repository**: https://github.com/ghostty-org/ghostty
- **Issue Tracker**: https://github.com/ghostty-org/ghostty/issues

## Configuration File Locations

- **Config**: `~/.config/ghostty/config`
- **Themes**: `~/.config/ghostty/themes/`
- **Local Overrides**: `~/.config/ghostty/local.conf`
- **macOS Alternative**: `~/Library/Application Support/com.mitchellh.ghostty/config`

## Tips & Tricks

### Quick Theme Switching

Create aliases in your `~/.zshrc`:
```bash
alias ghostty-gruvbox='ghostty -e theme=gruvbox &'
alias ghostty-nord='ghostty -e theme=nord &'
alias ghostty-dracula='ghostty -e theme=dracula &'
alias ghostty-onedark='ghostty -e theme=one-dark &'
```

### Custom Window Size

Add to `local.conf`:
```bash
window-width = 140
window-height = 40
```

### Disable Confirmations

For power users who want instant closes:
```bash
confirm-close-surface = false
```

### Multiple Profiles

Create different config files and load them:
```bash
ghostty --config ~/.config/ghostty/work.conf
ghostty --config ~/.config/ghostty/personal.conf
```

## Comparison with Other Terminals

| Feature | Ghostty | Kitty | Alacritty | iTerm2 |
|---------|---------|-------|-----------|--------|
| GPU Accelerated | ✅ | ✅ | ✅ | ✅ |
| Native Tabs | ✅ | ✅ | ❌ | ✅ |
| Native Splits | ✅ | ✅ | ❌ | ✅ |
| macOS Native UI | ✅ | ❌ | ❌ | ✅ |
| Linux Native UI | ✅ (GTK4) | ❌ | ❌ | ❌ |
| Cross-Platform | ✅ | ✅ | ✅ | ❌ |
| Config Language | Simple | Config | TOML | GUI |
| Performance | Excellent | Excellent | Excellent | Good |
| Shell Integration | ✅ | ✅ | ❌ | ✅ |

## Support

For issues with this configuration:
- Check `CLAUDE.md` in the dotfiles root
- Open an issue in your dotfiles repository

For Ghostty itself:
- Official docs: https://ghostty.org/docs
- GitHub issues: https://github.com/ghostty-org/ghostty/issues
