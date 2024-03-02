-- defaults
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= "o" then
        scopes["o"][key] = value
    end
end

local indent = 2
vim.g.mapleader = " "

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

-- keymaps
keymap = vim.api.nvim_set_keymap
keymap("i", "jj", "<Esc>", {})
keymap("n", "<leader>r", "<cmd>setlocal relativenumber!<CR>", {})
keymap("n", "<leader>s", "<cmd>setlocal spell!<CR>", {})

-- plugins
local vim = vim
local execute = vim.api.nvim_command
local fn = vim.fn

-- ensure that packer is installed
local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute "packadd packer.nvim"
end

vim.cmd("packadd packer.nvim")
local packer = require "packer"
local util = require "packer.util"
packer.init({
    package_root = util.join_paths(vim.fn.stdpath('data'), 'site', 'pack')
})

vim.filetype.add({
    pattern = { [".*/hyprland%.conf"] = "hyprlang" },
    vim.api.nvim_command('set commentstring=#%s ')
})

-- startup and add/configure plugins
packer.startup(
    function()
        local use = use
        use "lambdalisue/suda.vim"
        use 'm4xshen/autoclose.nvim'
        require("autoclose").setup({
            options = {
                disabled_filetypes = { "text", "markdown" },
            },
        })
        use { "catppuccin/nvim", as = "catppuccin" }
        require("catppuccin").setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            background = { -- :h background
                light = "latte",
                dark = "mocha",
            },
            transparent_background = false, -- disables setting the background color.
        })
        use 'NvChad/nvim-colorizer.lua'
        require 'colorizer'.setup()
        use {
            "nvim-lualine/lualine.nvim",
            requires = {"kyazdani42/nvim-web-devicons"}
        }
        require("lualine").setup {
            options = {
                theme = "catppuccin"
            },
            sections = {
                lualine_a = {'mode'},
                lualine_b = {'branch', 'diff', 'diagnostics'},
                lualine_c = {{'filename', path = 2}},
                lualine_x = {'encoding', 'fileformat', 'filetype'},
                lualine_y = {'progress'},
                lualine_z = {'location'}
            },
        }
        use {
            'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup()
            end
        }
        use {
            'nvim-treesitter/nvim-treesitter',
            run = function()
                local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
                ts_update()
            end,
        }
        require('nvim-treesitter.configs').setup {
            ensure_installed = { "bash", "css", "html", "javascript", "json", "lua", "python", "vim" },
            sync_install = false,
            auto_install = false,
            highlight = {
                enable = true,
                disable = { "bash", "css" }
            },
        }
    end
)

vim.cmd.colorscheme "catppuccin-mocha"
