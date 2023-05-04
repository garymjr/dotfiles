return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        enabled = false,
        opts = {
            styles = {
                keywords = { italic = false },
            },
            on_highlights = function(hl, c)
                local prompt = "#2d3149"
                hl.TelescopeNormal = {
                    bg = c.bg_dark,
                    fg = c.fg_dark,
                }
                hl.TelescopeBorder = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopePromptNormal = {
                    bg = prompt,
                }
                hl.TelescopePromptBorder = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePromptTitle = {
                    bg = prompt,
                    fg = prompt,
                }
                hl.TelescopePreviewTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
                hl.TelescopeResultsTitle = {
                    bg = c.bg_dark,
                    fg = c.bg_dark,
                }
            end,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.api.nvim_command("colorscheme tokyonight")
        end,
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false,
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
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.api.nvim_command("colorscheme catppuccin")
        end,
    },
}
