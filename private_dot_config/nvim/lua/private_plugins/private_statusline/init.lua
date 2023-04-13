return {
    "rebelot/heirline.nvim",
    event = "VeryLazy",
    opts = function()
        local active_statusline = require("plugins.statusline.configs.active_statusline")
        local inactive_statusline = require("plugins.statusline.configs.inactive_statusline")
        local statuscolumn = require("plugins.statusline.configs.statuscolumn")

        return {
            statusline = {
                active_statusline,
                inactive_statusline,
            },
            statuscolumn = statuscolumn,
        }
    end,
}
