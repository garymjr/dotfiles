local colors = require("plugins.statusline.colors")
local conditions = require("heirline.conditions")

local buffer_name = require("plugins.statusline.components.buffer_name")
local buffer_status = require("plugins.statusline.components.buffer_status")
local ruler = require("plugins.statusline.components.ruler")
local active_lsp = require("plugins.statusline.components.active_lsp")
local branch = require("plugins.statusline.components.branch")
local diagnostics = require("plugins.statusline.components.diagnostics")

return {
    condition = conditions.is_active,
    hl = { bg = colors.bg, fg = colors.fg },
    { provider = "  " },
    buffer_name,
    { provider = "%< " },
    buffer_status,
    { provider = " %=" },
     -- provides conditional separators
    diagnostics,
    branch,
    active_lsp,
    { provider = " " },
    ruler,
}
