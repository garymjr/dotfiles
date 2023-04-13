local diagnostic_sign = require("plugins.statusline.components.diagnostic_sign")
local line_number = require("plugins.statusline.components.line_number")
local gitsigns = require("plugins.statusline.components.gitsigns")
local utils = require("heirline.utils")

return {
    hl = function()
        local Normal = utils.get_highlight("Normal")
        local Comment = utils.get_highlight("Comment")
        return { bg = Normal.bg, fg = Comment.fg }
    end,
    diagnostic_sign,
    { provider = "%=" },
    line_number,
    { provider = " " },
    gitsigns,
}
