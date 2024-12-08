return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "bash", "css", "html", "javascript", "json", "lua", "python", "vim" },
      highlight = { enable = true },
      indent = { enable = true, disable = { "python" } },
    })
  end,
}
