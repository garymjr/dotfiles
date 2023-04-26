return {
    {
        "rebelot/kanagawa.nvim",
        lazy = false,
        enabled = true,
        opts = {
            keywordStyle = { italic = false },
            theme = "wave",
            background = {
                dark = "wave",
                light = "lotus",
            },
            overrides = function(colors)
                local theme = colors.theme
                return {
                    LineNr = { bg = colors.palette.sumiInk3 },
                    TelescopeTitle = { fg = theme.ui.special, bold = true },
                    TelescopePromptNormal = { bg = theme.ui.bg_p1 },
                    TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                    TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
                    TelescopeResultsBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_m1 },
                    TelescopePreviewNormal = { bg = theme.ui.bg_dim },
                    TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_p1 },
                    -- Pmenu = { bg = theme.ui.bg_p1 },
                    -- PmenuBorder = { fg = theme.ui.fg, bg = theme.ui.bg_p1 },
                    -- PmenuDocBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
                    Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
                    PmenuBorder = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
                    PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
                    PmenuSbar = { bg = theme.ui.bg_m1 },
                    PmenuThumb = { bg = theme.ui.bg_p2 },
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
                override = {
                    LineNr = {
                        fg = colors.gray5,
                    },
                    CursorLineNr = {
                        fg = colors.white0,
                    },
                    TelescopePreviewBorder = {
                        fg = "#2f343f",
                    },
                    TelescopePromptBorder = {
                        fg = "#2f343f",
                    },
                    TelescopeResultsBorder = {
                        fg = "#2f343f",
                    },
                    PmenuBorder = {
                        fg = "#2f343f",
                    },
                    PmenuDocBorder = {
                        fg = "#2f343f",
                    },
                },
            }
        end,
        config = function(_, opts)
            require("nordic").setup(opts)
            require("nordic").load()
        end,
	},
}
