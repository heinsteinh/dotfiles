# Kitty Terminal Configuration

Modern GPU-accelerated terminal emulator configuration with custom theming, powerful keyboard shortcuts, and optimized performance settings.

## Features

### ⚡ Performance
- **GPU Acceleration** - Hardware-accelerated rendering for smooth scrolling
- **Optimized Rendering** - Low repaint delay (8ms) and input delay (2ms)
- **Sync to Monitor** - Eliminates screen tearing
- **Ligature Support** - Beautiful programming font ligatures

### 🎨 Theming
- **Multiple Themes** - Atom Dark (default), Gruvbox, Dracula, Nord
- **Quick Theme Switching** - F1-F4 keys for instant theme changes
- **True Color Support** - 24-bit color for rich visual experience
- **Background Transparency** - Configurable opacity (default: 0.95)
- **Background Blur** - macOS-style blur effect (20px)

### 🔧 Enhanced Terminal Features
- **Large Scrollback** - 10,000 lines of history
- **Powerline Tabs** - Beautiful tab bar with activity indicators
- **Remote Control** - Allow remote control via socket
- **Smart URL Handling** - Clickable URLs with custom styling
- **Advanced Clipboard** - Copy on select, multiple clipboard support

### ⌨️ Keyboard Shortcuts
- **Window Management** - Split windows, navigate panes
- **Tab Management** - Create, close, navigate tabs
- **Font Size Control** - Dynamic font scaling
- **Search Integration** - FZF-powered scrollback search
- **Layout Switching** - Multiple window layouts

## Installation

The configuration will be automatically linked when you run the dotfiles installation:

```bash
# Full dotfiles installation includes Kitty config
./install.sh
```

Or manually create the symlink:

```bash
ln -sf ~/.dotfiles/config/kitty ~/.config/kitty
```

## Quick Start

### Basic Usage

Launch Kitty:
```bash
kitty
```

Open a specific directory:
```bash
kitty --directory ~/Projects
```

Launch with custom session:
```bash
kitty --session ~/.config/kitty/sessions/dev.session
```

### Configuration Files

- **Main config**: `~/.config/kitty/kitty.conf`
- **Themes**: `~/.config/kitty/themes/*.conf`
- **Local overrides**: `~/.config/kitty/local.conf` (optional, not in repo)
- **Sessions**: `~/.config/kitty/sessions/*.session`

## Keyboard Shortcuts

All shortcuts use `kitty_mod` which is set to `Ctrl+Shift`.

### Clipboard Operations
- `Ctrl+Shift+C` - Copy to clipboard
- `Ctrl+Shift+V` - Paste from clipboard
- `Ctrl+Shift+S` - Paste from selection
- `Shift+Insert` - Paste from selection

### Scrolling
- `Ctrl+Shift+Up/Down` - Scroll line up/down
- `Ctrl+Shift+PageUp/PageDown` - Scroll page up/down
- `Ctrl+Shift+Home/End` - Scroll to top/bottom
- `Ctrl+Shift+H` - Show scrollback in pager
- `Ctrl+Shift+/` - Show scrollback in buffer
- `Ctrl+Shift+F` - FZF search in scrollback

### Window Management
- `Ctrl+Shift+Enter` - New window
- `Ctrl+Shift+N` - New OS window
- `Ctrl+Shift+W` - Close window
- `Ctrl+Shift+]` - Next window
- `Ctrl+Shift+[` - Previous window
- `Ctrl+Shift+F` - Move window forward
- `Ctrl+Shift+B` - Move window backward
- `Ctrl+Shift+\`` - Move window to top
- `Ctrl+Shift+R` - Start resizing window
- `Ctrl+Shift+1-5` - Jump to window 1-5

### Tab Management
- `Ctrl+Shift+T` - New tab
- `Ctrl+Shift+Q` - Close tab
- `Ctrl+Shift+Right/Left` - Next/previous tab
- `Ctrl+Shift+.` - Move tab forward
- `Ctrl+Shift+,` - Move tab backward
- `Ctrl+Shift+Alt+T` - Set tab title

### Layout Management
- `Ctrl+Shift+L` - Next layout (cycles through layouts)
- `Ctrl+Shift+Alt+T` - Go to tall layout
- `Ctrl+Shift+Alt+S` - Go to stack layout

### Font Size Control
- `Ctrl+Shift+=` - Increase font size by 2.0
- `Ctrl+Shift+-` - Decrease font size by 2.0
- `Ctrl+Shift+Backspace` - Reset font size to default

### Theme Switching (Live)
- `F1` - Switch to Atom Dark theme
- `F2` - Switch to Gruvbox theme
- `F3` - Switch to Dracula theme
- `F4` - Switch to Nord theme

### Background Opacity Control
- `Ctrl+Shift+A M` - Increase opacity by 0.1
- `Ctrl+Shift+A L` - Decrease opacity by 0.1
- `Ctrl+Shift+A 1` - Set opacity to 1.0 (opaque)
- `Ctrl+Shift+A D` - Reset to default opacity

### Miscellaneous
- `Ctrl+Shift+F11` - Toggle fullscreen
- `Ctrl+Shift+U` - Unicode input
- `Ctrl+Shift+F2` - Edit config file
- `Ctrl+Shift+Escape` - Open Kitty shell
- `Ctrl+Shift+Delete` - Clear terminal (reset)
- `Ctrl+Shift+F5` - Reload configuration

## Themes

### Available Themes

| Theme       | Description                    | Activation |
|-------------|--------------------------------|------------|
| Atom Dark   | Default - Atom One Dark theme  | F1         |
| Gruvbox     | Retro groove color scheme      | F2         |
| Dracula     | Dark theme with purple accent  | F3         |
| Nord        | Arctic, north-bluish palette   | F4         |

### Switching Themes

**Quick switch (runtime):**
```bash
# Press F1, F2, F3, or F4 while Kitty is running
```

**Permanent switch:**
```bash
# Use the theme switcher
theme atom-dark
theme gruvbox
theme dracula
theme nord
```

**Manual configuration:**
Edit `~/.config/kitty/kitty.conf`:
```conf
# Change the include line
include themes/atom-dark.conf
# include themes/gruvbox.conf
# include themes/dracula.conf
# include themes/nord.conf
```

Then reload: `Ctrl+Shift+F5`

### Theme Files

All themes are located in `~/.config/kitty/themes/`:
- `atom-dark.conf` - Atom One Dark colors
- `gruvbox.conf` - Gruvbox dark colors
- `dracula.conf` - Dracula colors
- `nord.conf` - Nord colors

## Fonts

### Default Font

**MesloLGS Nerd Font Mono** - Includes powerline glyphs and icon support

```conf
font_family      MesloLGS Nerd Font Mono
bold_font        MesloLGS Nerd Font Mono Bold
italic_font      MesloLGS Nerd Font Mono Italic
bold_italic_font MesloLGS Nerd Font Mono Bold Italic
font_size 12.0
```

### Changing Fonts

**Available Nerd Fonts** (installed via dotfiles):
- FiraCode Nerd Font
- JetBrainsMono Nerd Font
- Hack Nerd Font
- SourceCodePro Nerd Font
- UbuntuMono Nerd Font

**To change font**, edit `~/.config/kitty/kitty.conf`:
```conf
font_family FiraCode Nerd Font Mono
font_size 13.0
```

Reload: `Ctrl+Shift+F5`

## Performance Tuning

### Current Settings

```conf
repaint_delay 8           # 8ms repaint delay (lower = faster)
input_delay 2             # 2ms input delay (lower = more responsive)
sync_to_monitor yes       # Eliminate screen tearing
```

### Optimization Tips

**For high-refresh monitors** (144Hz+):
```conf
repaint_delay 4
input_delay 1
```

**For slower machines**:
```conf
repaint_delay 16
input_delay 4
```

**Disable transparency** for better performance:
```conf
background_opacity 1.0
background_blur 0
```

## Advanced Features

### Remote Control

Kitty can be controlled remotely via socket:

```bash
# Enable in config (already enabled)
allow_remote_control yes

# Examples
kitty @ set-colors --all background=#000000
kitty @ set-font-size 14
kitty @ launch --type=tab
```

### Sessions

Create session files in `~/.config/kitty/sessions/`:

**Example: `dev.session`**
```
new_tab Development
cd ~/Projects
launch zsh

new_tab Logs
cd /var/log
launch tail -f syslog

new_tab Monitoring
launch htop
```

**Load session:**
```bash
kitty --session ~/.config/kitty/sessions/dev.session
```

### URL Handling

URLs are automatically detected and styled:

```conf
url_color #0087bd
url_style curly           # curly underline
open_url_modifiers kitty_mod
```

**Click URL**: `Ctrl+Shift + Click`

### Window Layouts

Available layouts:
- `tall` - One large window, others stacked vertically
- `fat` - One large window, others stacked horizontally
- `grid` - All windows in a grid
- `horizontal` - All windows side-by-side
- `vertical` - All windows stacked
- `splits` - Manual splits
- `stack` - Only one window visible at a time

Cycle layouts: `Ctrl+Shift+L`

## Customization

### Local Configuration

Create `~/.config/kitty/local.conf` for personal overrides:

```conf
# This file is not tracked by git
# Add your personal customizations here

# Example: Different font size
font_size 14.0

# Example: No transparency
background_opacity 1.0

# Example: Custom keybindings
map ctrl+alt+enter new_window_with_cwd
```

### Adding Custom Themes

1. Create theme file: `~/.config/kitty/themes/mytheme.conf`
2. Define colors (see existing themes for format)
3. Include in `kitty.conf`: `include themes/mytheme.conf`
4. Reload: `Ctrl+Shift+F5`

### Custom Keyboard Shortcuts

Add to `kitty.conf` or `local.conf`:

```conf
# Example: Quick directory shortcuts
map ctrl+shift+alt+p launch --cwd=~/Projects
map ctrl+shift+alt+d launch --cwd=~/Downloads
map ctrl+shift+alt+h launch --cwd=~
```

## Troubleshooting

### Font Issues

**Problem:** Powerline symbols not displaying
**Solution:**
```bash
# Reinstall Nerd Fonts
~/.dotfiles/scripts/install/install-fonts.sh

# Refresh font cache (Linux)
fc-cache -fv

# Verify font is installed
kitty list-fonts | grep MesloLGS
```

### Theme Not Loading

**Problem:** Theme colors incorrect
**Solution:**
```bash
# Check for errors
kitty --debug-config

# Verify theme file exists
ls ~/.config/kitty/themes/

# Check include statement
grep "^include themes/" ~/.config/kitty/kitty.conf

# Reload config
Ctrl+Shift+F5
```

### Performance Issues

**Problem:** Kitty feels sluggish
**Solution:**
```conf
# Disable transparency
background_opacity 1.0
background_blur 0

# Increase delays (trade responsiveness for CPU)
repaint_delay 16
input_delay 4

# Disable animations
window_resize_draw_strategy static
```

### Key Bindings Not Working

**Problem:** Shortcuts don't respond
**Solution:**
```bash
# Check for conflicts
kitty --debug-keyboard

# Verify kitty_mod setting
grep kitty_mod ~/.config/kitty/kitty.conf

# Test in clean config
kitty --config=/dev/null
```

### Remote Control Not Working

**Problem:** `kitty @` commands fail
**Solution:**
```conf
# Ensure remote control is enabled
allow_remote_control yes

# Use socket for more reliable control
listen_on unix:/tmp/kitty
```

## Platform-Specific Features

### macOS

```conf
macos_titlebar_color system         # Match system theme
macos_option_as_alt yes              # Use Option as Alt
macos_quit_when_last_window_closed no
macos_traditional_fullscreen no      # Use macOS fullscreen
macos_show_window_title_in all       # Show title in all windows
```

### Linux

```conf
linux_display_server auto            # X11 or Wayland auto-detection
wayland_titlebar_color system
```

## Integration with Other Tools

### Tmux

Kitty and Tmux work great together:

```bash
# Launch tmux in Kitty
kitty -e tmux new-session -A -s main
```

### Neovim/Vim

Kitty provides excellent terminal integration:

```lua
-- In Neovim, check if running in Kitty
if os.getenv('TERM') == 'xterm-kitty' then
  -- Enable additional features
end
```

### FZF

FZF integration for scrollback search (already configured):

```bash
# Press Ctrl+Shift+F to search scrollback with FZF
```

## Resources

- [Official Kitty Documentation](https://sw.kovidgoyal.net/kitty/)
- [Kitty Themes Gallery](https://github.com/dexpota/kitty-themes)
- [THEMING.md](../../THEMING.md) - Comprehensive theming guide for all CLI tools
- [Nerd Fonts](https://www.nerdfonts.com/) - Programming fonts with icons

## Tips & Tricks

### Quick Tips

1. **Copy-paste without mouse**: Select with mouse, then `Ctrl+Shift+C` to copy
2. **Search scrollback**: `Ctrl+Shift+F` opens FZF search
3. **Quick theme preview**: Press F1-F4 to try themes without committing
4. **Zoom text temporarily**: `Ctrl+Shift+=` / `Ctrl+Shift+-`
5. **Clear everything**: `Ctrl+Shift+Delete` for hard reset

### Workflow Examples

**Development workflow:**
```bash
# Tab 1: Editor
nvim project/

# Tab 2: Tests
npm run test:watch

# Tab 3: Logs
tail -f logs/app.log

# Tab 4: Server
npm run dev
```

**System administration:**
```bash
# Split windows with different contexts
# Window 1: Monitor resources (htop)
# Window 2: Watch logs (journalctl -f)
# Window 3: Run commands
# Window 4: Database client
```

## Migration from Other Terminals

### From iTerm2

Kitty offers similar features with better performance:
- Profiles → Sessions
- Hotkey window → Custom keyboard shortcuts
- Split panes → Window management
- Badges → Tab titles

### From Alacritty

Kitty provides additional features:
- Similar GPU acceleration
- More keyboard shortcuts
- Tab management
- Session support
- Better ligature support

### From Gnome Terminal / Konsole

Kitty advantages:
- Much faster rendering
- Cross-platform consistency
- Advanced customization
- Better font rendering
- Scriptable via remote control

## See Also

- [README.md](../../README.md) - Main dotfiles documentation
- [THEMING.md](../../THEMING.md) - Theme management guide
- [config/nvim/README.md](../nvim/README.md) - Neovim configuration
- [config/tmux/.tmux.conf](../tmux/.tmux.conf) - Tmux configuration
- [CLAUDE.md](../../CLAUDE.md) - Project instructions for Claude Code
