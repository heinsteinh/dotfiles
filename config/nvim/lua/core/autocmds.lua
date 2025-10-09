-- Auto commands
local augroup = vim.api.nvim_create_augroup("user_cmds", { clear = true })

-- Remove trailing whitespace on save
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  desc = "Remove trailing whitespace on save",
  callback = function()
    vim.cmd([[%s/\s\+$//e]])
  end,
})

-- Restore cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore cursor position",
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Highlight current line only in active window
vim.api.nvim_create_autocmd("WinEnter", {
  group = augroup,
  desc = "Highlight current line in active window",
  callback = function()
    vim.opt_local.cursorline = true
  end,
})

vim.api.nvim_create_autocmd("WinLeave", {
  group = augroup,
  desc = "Remove cursorline in inactive window",
  callback = function()
    vim.opt_local.cursorline = false
  end,
})

-- ============================================================================
-- File Type Specific Settings
-- ============================================================================

-- C/C++ (4 spaces, specific formatting)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "c", "cpp", "h", "hpp" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.commentstring = "// %s"
  end,
})

-- CMake (4 spaces)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "cmake",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- YAML (2 spaces for k8s manifests)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "yaml",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- Dockerfile (4 spaces)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "dockerfile",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- JSON (2 spaces)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "json",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

-- Bash (4 spaces)
vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = { "sh", "bash", "zsh" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})
