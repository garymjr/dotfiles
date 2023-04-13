local utils = require("heirline.utils")

return {
    init = function(self)
        self.diagnostics = {
            errors = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR }),
            warnings = vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN }),
        }
    end,
    {
        condition = function(self)
            return #self.diagnostics.errors > 0
        end,
        hl = function()
            local hl = utils.get_highlight("DiagnosticSignError")
            return { fg = string.format("#%6x", hl.fg) }
        end,
        provider = function(self)
            return string.format("● %s", #self.diagnostics.errors)
        end,
    },
    {
        condition = function(self)
            return #self.diagnostics.errors > 0 and #self.diagnostics.warnings > 0
        end,
        provider = " ",
    },
    {
        condition = function(self)
            return #self.diagnostics.warnings > 0
        end,
        hl = function()
            local hl = utils.get_highlight("DiagnosticSignWarn")
            return { fg = string.format("#%6x", hl.fg) }
        end,
        provider = function(self)
            return string.format("● %s", #self.diagnostics.warnings)
        end,
    },
    {
        condition = function(self)
            return #self.diagnostics.errors > 0 or #self.diagnostics.warnings > 0
        end,
        provider = " | ",
    },
}
