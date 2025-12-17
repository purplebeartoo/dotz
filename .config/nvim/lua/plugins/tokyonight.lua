return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      palette_overrides = {
        -- bright_blue = "#2ac3de",
        -- neutral_blue = "#7aa2f7",
      }
    })
    vim.cmd("colorscheme tokyonight-night")
  end,
}
