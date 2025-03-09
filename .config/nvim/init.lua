-- Defaults
local scopes = { o = vim.o, b = vim.bo, w = vim.wo }

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= "o" then
    scopes["o"][key] = value
  end
end

local indent = 2

opt("b", "expandtab", true) -- Use spaces instead of tabs
opt("b", "shiftwidth", indent) -- Size of an indent
opt("b", "smartindent", true) -- Insert indents automatically
opt("b", "tabstop", indent) -- Number of spaces tabs count for
opt("o", "clipboard", "unnamedplus") -- Set clipboard registers
opt("o", "cursorline", true) -- Show cursor line
opt("o", "ignorecase", true) -- Ignore case
opt("o", "mouse", "a") -- All modes
opt("o", "shortmess", "I") -- Disable intro message
opt("o", "smartcase", true) -- Don't ignore case with capitals
opt("o", "splitbelow", true) -- Put new windows below current
opt("o", "splitright", true) -- Put new windows right of current
opt("o", "termguicolors", true) -- True color support
opt("w", "number", true) -- Print line number
opt("w", "relativenumber", true) -- Relative line numbers
opt("w", "wrap", false) -- Disable line wrap

-- -- Keymaps
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
