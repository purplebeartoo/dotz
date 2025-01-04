return {
  "Mofiqul/dracula.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local dracula = require("dracula")
    vim.cmd.colorscheme("dracula")
  end,
}
