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

-- Keymaps
keymap = vim.api.nvim_set_keymap
keymap("i", "jj", "<Esc>", {})
keymap("n", "<leader>l", "<cmd>:Lazy<CR>", {})
keymap("n", "<leader>r", "<cmd>setlocal relativenumber!<CR>", {})
keymap("n", "<leader>s", "<cmd>setlocal spell!<CR>", {})
keymap("n", "<leader>t", "<cmd>:NvimTreeToggle<CR>", {})

vim.keymap.set("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
vim.keymap.set("n", "go", "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>")

-- Hyprland
vim.filetype.add({
  pattern = { [".*/hyprland%.conf"] = "hyprlang" },
  vim.api.nvim_command("set commentstring=#\\ %s"),
})

require("config.lazy")
