-- Defaults
local set = vim.opt

set.clipboard = "unnamedplus"
set.cursorline = true
set.expandtab = true
set.ignorecase = true
set.mouse = "a"
set.number = true
set.relativenumber = true
set.shiftwidth = 2
set.shortmess = "I"
set.smartcase = true
set.smartindent = true
set.softtabstop = 2
set.splitbelow = true
set.splitright = true
set.tabstop = 2
set.termguicolors = true
set.wrap = false

-- Leader key setup
vim.g.mapleader = "\\"

-- Keymaps
vim.keymap.set("i", "jj", "<Esc>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>l", "<cmd>:Lazy<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>r", "<cmd>setlocal relativenumber!<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>s", "<cmd>setlocal spell!<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>t", "<cmd>:NvimTreeToggle<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "go", "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>", { noremap = true, silent = true })

-- Hyprland
vim.filetype.add({
  pattern = { [".*/hyprland%.conf"] = "hyprlang" },
})

vim.api.nvim_command("autocmd FileType hyprlang setlocal commentstring=#\\ %s")

-- Initialize lazy.nvim plugin manager configuration
require("config.lazy")
