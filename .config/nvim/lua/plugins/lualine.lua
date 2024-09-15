return {
    "nvim-lualine/lualine.nvim",
    dependencies = {"nvim-tree/nvim-web-devicons"},
    config = function()
        require("lualine").setup()
        sections = {
            lualine_a = {
                {
                    "filename",
                    file_status = true,
                    path = 2
                }
            }
        }
    end
}
