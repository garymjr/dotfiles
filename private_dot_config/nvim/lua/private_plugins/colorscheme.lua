return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
        priority = 1000,
        enabled = false,
        opts = {
            flavor = "mocha",
            term_colors = true,
            no_italic = true,
            syles = {
                comments = { "italic" },
            },
            integrations = {
                mini = true,
                fidget = true,
                telescope = true,
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.api.nvim_command("colorscheme catppuccin")
        end,
    },
    {
        "tjdevries/colorbuddy.nvim",
        lazy = false,
        priority = 1000,
        enabled = false,
        config = function()
            require("gm.hackerbuddy")
        end,
    },
    {
        "ribru17/bamboo.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.api.nvim_command("colorscheme bamboo")
        end,
    },
}
