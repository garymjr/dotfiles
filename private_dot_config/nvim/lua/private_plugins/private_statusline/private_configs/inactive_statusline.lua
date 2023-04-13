local colors = require("plugins.statusline.colors")
local conditions = require("heirline.conditions")

local buffer_name = require("plugins.statusline.components.buffer_name")
local ruler = require("plugins.statusline.components.ruler")

return {
    condition = function()
        return not conditions.is_active()
    end,
    hl = { bg = colors.bg, fg = colors.fg },
    { provider = " " },
    buffer_name,
    { provider = "%=" },
    ruler,
}
