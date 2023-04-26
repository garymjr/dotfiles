local utils = require("heirline.utils")

local Normal = utils.get_highlight("Normal")
local Boolean = utils.get_highlight("Boolean")
local StatusLine = utils.get_highlight("StatusLine")
local Function = utils.get_highlight("Function")
local DiagnosticOk = utils.get_highlight("DiagnosticOk")
local Operator = utils.get_highlight("Operator")
local Keyword = utils.get_highlight("Keyword")
local Constant = utils.get_highlight("Constant")

return {
    fg = Normal.fg,
    bg = StatusLine.bg,
    inactive_bg = Normal.bg,
    accent = Boolean.fg,
    bright = Normal.fg,
    normal = Function.fg,
    insert = DiagnosticOk.fg,
    command = Operator.fg,
    visual = Keyword.fg,
    replace = Constant.fg,
    ruler = DiagnosticOk.fg,
}
