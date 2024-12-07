return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      pcall(require("nvim-treesitter.install").update({ with_sync = true }))
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "bash", "css", "html", "javascript", "json", "lua", "python", "vim" },
        highlight = { enable = true },
        indent = { enable = true, disable = { "python" } },
      })
    end,
  },
}
