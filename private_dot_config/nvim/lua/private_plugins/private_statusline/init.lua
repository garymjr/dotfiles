return {
    "rebelot/heirline.nvim",
    dependencies = {
        "ThePrimeagen/harpoon",
        "ribru17/bamboo.nvim",
    },
    event = "VeryLazy",
    opts = function()
        local active_statusline = require("plugins.statusline.configs.active_statusline")
        local inactive_statusline = require("plugins.statusline.configs.inactive_statusline")
        local statuscolumn = require("plugins.statusline.configs.statuscolumn")
        local utils = require("heirline.utils")
        local conditions = require("heirline.conditions")

        local statusline = {
            static = {
                colors = {
                    active = {
                        bg = utils.get_highlight("StatusLine").bg,
                        fg = utils.get_highlight("StatusLine").fg,
                    },
                    inactive = {
                        bg = utils.get_highlight("StatusLineNC").bg,
                        fg = utils.get_highlight("StatusLineNC").fg,
                    },
                },
            },
            {
                condition = conditions.is_active,
                hl = function(self)
                    return {
                        bg = string.format("#%6x", self.colors.active.bg),
                        fg = string.format("#%6x", self.colors.active.fg),
                    }
                end,
                active_statusline,
            },
            {
                condition = function() return not conditions.is_active() end,
                hl = function(self)
                    return {
                        bg = string.format("#%6x", self.colors.inactive.bg),
                        fg = string.format("#%6x", self.colors.inactive.fg),
                    }
                end,
                inactive_statusline,
            },
        }

        return {
            statusline = statusline,
            statuscolumn = statuscolumn,
        }
    end,
}
