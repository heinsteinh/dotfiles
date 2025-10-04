# Neovim Configuration

Modern Neovim configuration using Lua and the latest plugins, designed to match and enhance the existing Vim setup.

## Features

### 🚀 Modern Plugin Manager
- **Lazy.nvim** - Fast and feature-rich plugin manager with lazy loading

### 🎨 Enhanced UI
- **Gruvbox/Dracula/Nord** themes with true color support
- **Lualine** - Beautiful and fast statusline
- **Bufferline** - Enhanced buffer tabs
- **Alpha-nvim** - Beautiful dashboard
- **Which-key** - Interactive keybinding help

### 🔍 Enhanced Search & Navigation
- **Telescope** - Fuzzy finder for files, buffers, text, and more (FZF replacement)
- **Neo-tree** - Modern file explorer (NERDTree replacement)
- **Flash.nvim** - Advanced motion plugin (EasyMotion replacement)

### 📝 Language Support & LSP
- **Treesitter** - Advanced syntax highlighting and code understanding
- **LSP** with Mason.nvim for automatic server installation
- **nvim-cmp** - Powerful autocompletion with multiple sources
- **LuaSnip** - Snippet engine with VS Code snippet support

### 🔧 Development Tools
- **Gitsigns** - Git integration with inline blame and hunks
- **Fugitive** - Comprehensive Git wrapper
- **Comment.nvim** - Smart commenting
- **nvim-surround** - Surround text objects
- **nvim-autopairs** - Automatic bracket pairing
- **toggleterm** - Better terminal integration

### ⚡ Performance & Quality of Life
- **Indent-blankline** - Visual indentation guides
- **Markdown Preview** - Live markdown preview
- **Project.nvim** - Automatic project detection
- **nvim-notify** - Beautiful notifications

## Installation

The configuration will be automatically linked when you run the dotfiles installation:

```bash
# Full dotfiles installation includes Neovim config
./install.sh
```

Or manually create the symlink:

```bash
ln -sf ~/.dotfiles/config/nvim ~/.config/nvim
```

## Key Mappings

All key mappings use `<Space>` as the leader key, matching the Vim configuration.

### File Operations
- `<leader>w` - Save file
- `<leader>q` - Quit
- `<leader>x` - Save and quit
- `<leader>h` - Clear search highlights

### Navigation
- `<C-h/j/k/l>` - Window navigation
- `<C-h/l>` - Buffer navigation (previous/next)
- `<leader>bd` - Delete buffer

### File Explorer & Search
- `<leader>n` - Toggle Neo-tree
- `<leader>nf` - Reveal current file in Neo-tree
- `<leader>f` - Find files (Telescope)
- `<leader>b` - Find buffers
- `<leader>rg` - Live grep
- `<leader>/` - Search in current buffer

### Git Integration
- `<leader>gs` - Git status
- `<leader>gc` - Git commit
- `<leader>gp` - Git push
- `<leader>gl` - Git pull
- `<leader>gd` - Git diff
- `<leader>gb` - Git blame

### LSP (Language Server Protocol)
- `gd` - Go to definition
- `K` - Hover documentation
- `gi` - Go to implementation
- `gr` - Find references
- `<leader>rn` - Rename symbol
- `<leader>ca` - Code actions

### Motion & Editing
- `s` - Flash jump (quick navigation)
- `<A-j/k>` - Move lines up/down
- `gcc` - Comment/uncomment line
- `gc` (visual mode) - Comment/uncomment selection

## Language Servers

The following LSP servers are automatically installed:

- **Lua** - lua_ls
- **Python** - pyright
- **JavaScript/TypeScript** - tsserver
- **HTML/CSS** - html, cssls
- **JSON/YAML** - jsonls, yamlls
- **Bash** - bashls
- **C/C++** - clangd
- **Go** - gopls
- **Rust** - rust_analyzer

## File Type Settings

- **Python**: 4 spaces, auto-expansion
- **JavaScript/TypeScript/HTML/CSS/YAML**: 2 spaces
- **Markdown**: Word wrap enabled

## Differences from Vim Configuration

### Enhanced Features
1. **LSP Integration** - Native language server support
2. **Treesitter** - Better syntax highlighting and code understanding
3. **Lua Configuration** - More performant and maintainable
4. **Modern UI** - Better looking and more functional interface
5. **Telescope** - More powerful than FZF with better integration

### Plugin Replacements
- FZF → Telescope
- NERDTree → Neo-tree
- ALE → Native LSP + nvim-cmp
- EasyMotion → Flash.nvim
- vim-airline → lualine.nvim
- Various small plugins → Built-in Neovim features

## Customization

### Adding Plugins
Edit `~/.config/nvim/init.lua` and add plugins to the `require("lazy").setup({})` section:

```lua
{
  "plugin/name",
  config = function()
    -- Plugin configuration
  end,
}
```

### Changing Colorscheme
Edit the gruvbox configuration or switch to another theme:

```lua
vim.cmd("colorscheme dracula")  -- or nord, etc.
```

### Custom Keymaps
Add custom keymaps after the existing ones:

```lua
vim.keymap.set("n", "<leader>custom", ":CustomCommand<CR>", { desc = "Custom command" })
```

## Troubleshooting

### Plugin Issues
```bash
# Open Neovim and run
:Lazy update
:Lazy sync
```

### LSP Issues
```bash
# Check LSP status
:LspInfo

# Reinstall language servers
:Mason
```

### Performance Issues
```bash
# Check startup time
nvim --startuptime startup.log

# Profile Lua execution
:lua vim.notify(vim.loop.uptime())
```

## Migration from Vim

Your existing Vim configuration will continue to work. The Neovim config provides enhanced features while maintaining familiar keybindings and workflows. You can use both configurations simultaneously - Vim will use `~/.vimrc` and Neovim will use `~/.config/nvim/init.lua`.