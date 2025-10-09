-- Core Neovim options
local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.showmatch = true
opt.termguicolors = true
opt.signcolumn = "yes"

-- Search
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Completion
opt.wildmenu = true
opt.wildmode = "longest:full,full"
opt.wildignore = "*.o,*.obj,*.pyc,*.class,*.git,*.svn,*.hg,*~,*.swp,*.swo,*.tmp,*.bak"

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.updatetime = 250
opt.timeoutlen = 500
opt.splitbelow = true
opt.splitright = true
opt.hidden = true

-- Files
opt.backup = true
opt.writebackup = true
opt.undofile = true
opt.swapfile = true

-- Directories
opt.backupdir = vim.fn.expand("~/.config/nvim/backup//")
opt.directory = vim.fn.expand("~/.config/nvim/swap//")
opt.undodir = vim.fn.expand("~/.config/nvim/undo//")

-- Create directories if they don't exist
local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

ensure_dir(vim.fn.expand("~/.config/nvim/backup"))
ensure_dir(vim.fn.expand("~/.config/nvim/swap"))
ensure_dir(vim.fn.expand("~/.config/nvim/undo"))

-- Indentation (C++ defaults: 4 spaces)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.autoindent = true
opt.smartindent = true

-- C++ specific
opt.cinoptions = "g0,N-s,l1,t0,(0,W4"  -- Better indentation for C++

-- Performance
opt.lazyredraw = true
opt.synmaxcol = 200  -- Don't highlight super long lines
