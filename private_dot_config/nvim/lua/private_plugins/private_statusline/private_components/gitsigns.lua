local utils = require("heirline.utils")

return {
    init = function(self)
        local buf = vim.api.nvim_get_current_buf()
        self.signs = vim.fn.sign_getplaced(buf, {
            group = "gitsigns_vimfn_signs_",
            lnum = vim.v.lnum,
        })[1].signs
    end,
    {
        fallthrough = false,
        {
            condition = function(self)
                return #self.signs > 0 and self.signs[1].name == "GitSignsDelete"
            end,
            provider = "▁",
            hl = function(self)
                local hl = utils.get_highlight(self.signs[1].name)
                return { fg = string.format("#%6x", hl.fg) }
            end,
        },
        {
            condition = function(self)
                return #self.signs > 0 and self.signs[1].name == "GitSignsTopdelete"
            end,
            provider = "▔",
            hl = function(self)
                local hl = utils.get_highlight(self.signs[1].name)
                return { fg = string.format("#%6x", hl.fg) }
            end,
        },
        {
            condition = function(self)
                return #self.signs > 0
            end,
            provider = "┃",
            hl = function(self)
                local hl = utils.get_highlight(self.signs[1].name)
                return { fg = string.format("#%6x", hl.fg) }
            end,
        },
    },
    {
        condition = function(self)
            return #self.signs == 0
        end,
        provider = " ",
    }
}
