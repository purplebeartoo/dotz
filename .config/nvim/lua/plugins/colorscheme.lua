return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        lazy = false,
        opts = {
            flavour = "mocha",
            styles = {
                -- Style to be applied to different syntax groups
                comments = {"italic"}, -- Value is any valid attr-list value `:help attr-list`
                conditionals = {"italic"}
            }
        },
        init = function()
            vim.cmd.colorscheme("catppuccin")
        end
    }
}
