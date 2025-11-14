# Okular Configuration - Vim-like Keybindings

Okular is configured with Vim-inspired keybindings for efficient PDF navigation and viewing, seamlessly integrated into the dotfiles workflow.

## Installation

Okular is automatically installed on Arch Linux via the setup script:

```bash
./scripts/setup/setup-arch.sh --full
```

Or install manually:

```bash
sudo pacman -S okular
```

## Configuration Files

- **`okularrc`** - Main configuration (view settings, rendering options)
- **`part.rc`** - Document viewer keybindings (XML format)
- **`shell.rc`** - Application window keybindings (XML format)

These files are symlinked to:
- `~/.config/okularrc`
- `~/.local/share/kxmlgui5/okular/part.rc`
- `~/.local/share/kxmlgui5/okular/shell.rc`

## Vim-like Keybindings

### Navigation (Vim Motions)

| Key | Action | Description |
|-----|--------|-------------|
| `j` | Scroll down | Move down (like Vim) |
| `k` | Scroll up | Move up (like Vim) |
| `h` | Previous page | Go to previous page |
| `l` | Next page | Go to next page |
| `gg` | First page | Jump to first page (Vim-style) |
| `Shift+G` | Last page | Jump to last page (Vim-style) |
| `Ctrl+d` | Half page down | Scroll half page down |
| `Ctrl+u` | Half page up | Scroll half page up |
| `Ctrl+f` | Page forward | Full page forward |
| `Ctrl+b` | Page backward | Full page backward |

### Document Operations

| Key | Action | Description |
|-----|--------|-------------|
| `o` | Open file | Open PDF document |
| `q` | Close | Close current document |
| `Shift+Q` | Quit | Quit Okular |
| `R` | Reload | Reload current document |
| `:` | Go to page | Command mode - enter page number |
| `Ctrl+G` | Go to page | Alternative go-to-page dialog |

### Search

| Key | Action | Description |
|-----|--------|-------------|
| `/` | Find | Search in document (Vim-style) |
| `n` | Next match | Jump to next search result |
| `Shift+N` | Previous match | Jump to previous search result |
| `Ctrl+F` | Find | Alternative search shortcut |

### View & Zoom

| Key | Action | Description |
|-----|--------|-------------|
| `+` / `=` | Zoom in | Increase zoom level |
| `-` | Zoom out | Decrease zoom level |
| `w` | Fit to width | Fit page to window width |
| `p` | Fit to page | Fit entire page in window |
| `f` | Fullscreen | Toggle fullscreen mode |
| `F5` | Presentation | Start presentation mode |
| `c` | Continuous mode | Toggle continuous scrolling |

### Rotation

| Key | Action | Description |
|-----|--------|-------------|
| `r` | Rotate clockwise | Rotate page 90° clockwise |
| `Shift+R` | Rotate counter-clockwise | Rotate page 90° counter-clockwise |

### Mouse Modes

| Key | Action | Description |
|-----|--------|-------------|
| `d` | Drag mode | Pan/drag to navigate |
| `z` | Zoom mode | Click to zoom area |
| `v` | Visual select | Select rectangular area |
| `t` | Text select | Select text for copying |

### Bookmarks & Panels

| Key | Action | Description |
|-----|--------|-------------|
| `m` | Add bookmark | Bookmark current page |
| `'` | Show bookmarks | Display bookmark list |
| `F9` / `b` | Toggle sidebar | Show/hide left panel |
| `F8` | Toggle bottombar | Show/hide bottom bar |

### Printing & Export

| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+P` | Print | Print document |
| `Ctrl+Shift+P` | Print preview | Preview before printing |
| `Ctrl+S` | Save as | Export/save document |

## Features Enabled

- **Continuous scrolling** - Smooth page transitions
- **Smooth scrolling** - Smooth pixel-based scrolling
- **Watch file** - Auto-reload on external changes (great for LaTeX workflows)
- **Show OSD** - On-screen display for page numbers
- **Annotation tools** - Yellow/green highlighters, notes, underlines
- **Fit to width** - Default zoom mode for better readability

## Integration with Ranger

Okular is prioritized as the default PDF viewer in Ranger. When you open a PDF in Ranger, it will use Okular automatically.

## Shell Aliases

Convenient aliases are available in Zsh:

```bash
pdf <file>       # Open PDF with Okular
pdfv <file>      # Open PDF in presentation mode (fullscreen)
```

## Customization

### Local Overrides

To add personal settings without modifying tracked files:

1. Settings via GUI are stored in `~/.config/okularrc`
2. Custom keybindings can be added through: **Settings → Configure Keyboard Shortcuts**

### Disable Vim Keybindings

If you prefer standard keybindings:

```bash
# Remove the custom keybinding files
rm ~/.local/share/kxmlgui5/okular/part.rc
rm ~/.local/share/kxmlgui5/okular/shell.rc

# Okular will use default KDE shortcuts
```

## Tips for Vim Users

1. **Navigation feels native** - `hjkl` works as expected, `gg`/`G` for jumping
2. **Search workflow** - `/` to search, `n`/`N` to navigate results (exactly like Vim)
3. **Command mode** - `:` brings up "Go to Page" dialog
4. **Visual mode** - `v` for selecting regions (similar to Vim visual mode)
5. **Quick quit** - `q` closes document, `Shift+Q` quits application

## Troubleshooting

### Keybindings Not Working

1. Ensure config files are symlinked correctly:
   ```bash
   ls -la ~/.local/share/kxmlgui5/okular/
   ```

2. Re-run symlink script:
   ```bash
   ./scripts/utils/create-symlinks.sh
   ```

3. Restart Okular completely (close all windows)

### Reset to Defaults

```bash
# Backup current settings
cp ~/.config/okularrc ~/.config/okularrc.backup

# Remove custom configs
rm ~/.config/okularrc
rm ~/.local/share/kxmlgui5/okular/*.rc

# Okular will recreate defaults on next launch
```

### LaTeX Workflow Integration

Okular excels with LaTeX due to automatic reload:

```bash
# Forward search from Vim/Neovim to Okular (with synctex)
okular --unique document.pdf#src:123document.tex

# In your .vimrc for LaTeX:
" nnoremap <leader>v :!okular --unique %:r.pdf#src:%l%:p &<CR>
```

## Further Reading

- [Okular Handbook](https://docs.kde.org/stable5/en/okular/okular/)
- [KDE Documentation](https://docs.kde.org/)
- [Okular Homepage](https://okular.kde.org/)

## Contributing

Found a useful keybinding or configuration? Feel free to:
1. Test it thoroughly
2. Add it to the config files
3. Document it in this README
4. Submit a PR!
