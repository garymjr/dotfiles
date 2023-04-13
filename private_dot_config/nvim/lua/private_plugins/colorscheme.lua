return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        enabled = false,
        opts = {
            keywordStyle = { italic = false },
            overrides = function(colors)
                return {
                    LineNr = { bg = colors.palette.sumiInk0 },
                }
            end,
        },
        config = function(_, opts)
            require("kanagawa").setup(opts)
            vim.api.nvim_command("colorscheme kanagawa")
        end,
    },
	{
		"AlexvZyl/nordic.nvim",
		lazy = false,
        enabled = false,
		opts = function()
            local colors = require("nordic.colors")

            return {
                -- italic_comments = false,
                override = {
                    LineNr = {
                        fg = colors.gray5,
                    },
                    CursorLineNr = {
                        fg = colors.white0,
                    },
                },
            }
        end,
        config = function(_, opts)
            require("nordic").setup(opts)
            require("nordic").load()
        end,
	},
    {
        "ellisonleao/gruvbox.nvim",
        lazy = false,
        opts = {
            undercurl = true,
            underline = false,
            italic = {
                strings = false,
                comments = true,
                operators = false,
                folds = false,
            },
        },
        config = function(_, opts)
            require("gruvbox").setup(opts)
            vim.api.nvim_command("colorscheme gruvbox")
        end,
    },
}
