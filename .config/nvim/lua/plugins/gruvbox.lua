return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    require("gruvbox").setup({
      palette_overrides = {
        bright_blue = "#458588",
        neutral_blue = "#83a598",
      }
    })
    vim.cmd("colorscheme gruvbox")
  end,
}
