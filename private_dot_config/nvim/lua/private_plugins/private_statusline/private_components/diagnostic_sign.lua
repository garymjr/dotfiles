local utils = require("heirline.utils")

return {
    init = function(self)
        local buf = vim.api.nvim_get_current_buf()
        self.signs = vim.fn.sign_getplaced(buf, {
            group = "*",
            lnum = vim.v.lnum,
        })[1].signs
    end,
    {
        condition = function(self)
            for _, sign in ipairs(self.signs) do
                if vim.startswith(sign.name, "DiagnosticSign") then
                    return true
                end
            end
            return false
        end,
        hl = function(self)
            local hl = utils.get_highlight(self.signs[1].name)
            return { fg = string.format("#%6x", hl.fg) }
        end,
        provider = " ",
    },
    {
        condition = function(self)
            for _, sign in ipairs(self.signs) do
                if vim.startswith(sign.name, "DiagnosticSign") then
                    return false
                end
            end
            return true
        end,
        provider = " ",
    },
}
