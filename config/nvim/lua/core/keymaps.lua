-- Key mappings
local keymap = vim.keymap.set

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- General Mappings
-- ============================================================================
keymap("n", "<leader>w", ":w<CR>", { desc = "Save file" })
keymap("n", "<leader>q", ":q<CR>", { desc = "Quit" })
keymap("n", "<leader>x", ":x<CR>", { desc = "Save and quit" })
keymap("n", "<leader>h", ":noh<CR>", { desc = "Clear highlights" })
keymap("n", "<Esc><Esc>", ":nohlsearch<CR>", { desc = "Clear search" })

-- Buffer navigation
keymap("n", "<C-h>", ":bprevious<CR>", { desc = "Previous buffer" })
keymap("n", "<C-l>", ":bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Window navigation
keymap("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })

-- Move lines up/down
keymap("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
keymap("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
keymap("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
keymap("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- ============================================================================
-- File Explorer (Neo-tree)
-- ============================================================================
keymap("n", "<leader>n", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })
keymap("n", "<leader>nf", ":Neotree reveal<CR>", { desc = "Reveal in Neo-tree" })

-- ============================================================================
-- Telescope (Fuzzy Finder)
-- ============================================================================
keymap("n", "<leader>f", ":Telescope find_files<CR>", { desc = "Find files" })
keymap("n", "<leader>b", ":Telescope buffers<CR>", { desc = "Find buffers" })
keymap("n", "<leader>rg", ":Telescope live_grep<CR>", { desc = "Live grep" })
keymap("n", "<leader>gg", ":Telescope git_files<CR>", { desc = "Git files" })
keymap("n", "<leader>/", ":Telescope current_buffer_fuzzy_find<CR>", { desc = "Search in buffer" })

-- ============================================================================
-- LSP Mappings (Set in lsp.lua after LSP attaches)
-- ============================================================================
-- gd          - Go to definition
-- K           - Hover documentation
-- gi          - Go to implementation
-- gr          - References
-- <leader>rn  - Rename
-- <leader>ca  - Code action
-- [d / ]d     - Diagnostic navigation

-- ============================================================================
-- C++ Specific (Set in cpp.lua when clangd attaches)
-- ============================================================================
-- <leader>ch  - Switch header/source
-- <leader>ci  - Toggle inlay hints
-- <leader>co  - Symbol outline
-- <leader>cf  - Format with clang-format

-- ============================================================================
-- CMake (Set in cpp.lua after cmake-tools loads)
-- ============================================================================
-- <leader>cb  - CMake build
-- <leader>cr  - CMake run
-- <leader>ct  - CMake select target
-- <leader>cd  - CMake select build type
-- <leader>cg  - CMake generate
-- <leader>cc  - CMake clean

-- ============================================================================
-- Git (Gitsigns)
-- ============================================================================
keymap("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "Stage hunk" })
keymap("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", { desc = "Undo stage hunk" })
keymap("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
keymap("n", "<leader>gh", ":Gitsigns blame_line<CR>", { desc = "Blame line" })
keymap("n", "<leader>gd", ":Gitsigns diffthis<CR>", { desc = "Diff this" })
keymap("n", "[c", ":Gitsigns prev_hunk<CR>", { desc = "Previous hunk" })
keymap("n", "]c", ":Gitsigns next_hunk<CR>", { desc = "Next hunk" })

-- ============================================================================
-- Quick Edit Config
-- ============================================================================
keymap("n", "<leader>ev", ":edit ~/.config/nvim/init.lua<CR>", { desc = "Edit init.lua" })
keymap("n", "<leader>sv", ":source ~/.config/nvim/init.lua<CR>", { desc = "Source init.lua" })
