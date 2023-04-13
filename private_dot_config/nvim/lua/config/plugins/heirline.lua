local M = {
    "rebelot/heirline.nvim",
    dependencies = {
        "rose-pine/neovim",
        "ThePrimeagen/harpoon",
    },
}

function M.init()
    local utils = require("heirline.utils")

    local space = { provider = " " }

    local align = { provider = "%=" }

    local truncate = { provider = "%<" }

    local buffer_name = {
        {
            condition = function()
                local buf = vim.api.nvim_buf_get_name(0)
                return buf == ""
            end,
            provider = "[No Name]"
        },
        {
            condition = function()
                local buf = vim.api.nvim_buf_get_name(0)
                return buf ~= ""
            end,
            provider = function()
                local buf = vim.api.nvim_buf_get_name(0)
                local name = vim.fn.fnamemodify(buf, ":t")
                return name
            end,
        },
    }

    local buffer_status = {
        condition = function()
            return vim.bo.buftype ~= "prompt"
        end,
        {
            condition = function()
                return vim.bo.readonly
            end,
            provider = "[RO]",
        },
        {
            condition = function()
                return not vim.bo.modifiable
            end,
            provider = "[-]",
        },
        {
            condition = function()
                return vim.bo.modified
            end,
            provider = "[+]",
        },
        {
            condition = function()
                return vim.bo.readonly or vim.bo.modified or not vim.bo.modifiable
            end,
            space,
        },
    }

    local harpoon_status = {
        {
            condition = function()
                return require("harpoon.mark").status(0) == ""
            end,
            provider = function()
                return "[U]"
            end,
        },
        {
            condition = function()
                return require("harpoon.mark").status(0) ~= ""
            end,
            provider = function()
                return "[" .. require("harpoon.mark").status(0) .. "]"
            end,
        },
    }

    local git_branch = {
        condition = function()
            return vim.b.gitsigns_status_dict
        end,
        provider = function()
            return " " .. vim.b.gitsigns_status_dict.head
        end,
    }

    local ruler = { provider = "%l:%c" }

    local line_number = {
        {
            condition = function()
                local mode = vim.api.nvim_get_mode().mode
                mode = mode:sub(1, 1)
                if mode == "i" then
                    return false
                end
                return vim.v.relnum > 0
            end,
            provider = "%r",
        },
        {
            condition = function()
                local mode = vim.api.nvim_get_mode().mode
                mode = mode:sub(1, 1)
                if mode == "i" then
                    return false
                end
                return vim.v.relnum == 0
            end,
            provider = "%l",
        },
        {
            condition = function()
                local mode = vim.api.nvim_get_mode().mode
                mode = mode:sub(1, 1)
                if mode == "i" then
                    return true
                end
                return false
            end,
            provider = "%l",
        },
    }

    local diagnostic = {
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
            provider = " ",
            hl = function(self)
                local hl = utils.get_highlight(self.signs[1].name)
                return { fg = string.format("#%6x", hl.fg) }
            end,
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
            space,
        }
    }

    local gitsigns = {
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
            space,
        }
    }

    local statusline = {
        hl = { fg = "#908caa", bg = "#393552" },
        space,
        vi_mode,
        space,
        space,
        buffer_name,
        truncate,
        space,
        buffer_status,
        harpoon_status,
        align,
        git_branch,
        space,
        ruler,
        space,
    }

    local statuscolumn = {
        diagnostic,
        align,
        line_number,
        space,
        gitsigns,
    }

    require("heirline").setup({ statusline = statusline, statuscolumn = statuscolumn })
end

return M
