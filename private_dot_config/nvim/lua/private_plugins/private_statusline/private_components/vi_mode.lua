local conditions = require("heirline.conditions")

local mode_map = setmetatable({
    ["n"] = "NORMAL",
    ["no"] = "NORMAL",
    ["nov"] = "NORMAL",
    ["noV"] = "NORMAL",
    ["no"] = "NORMAL",
    ["niI"] = "NORMAL",
    ["niR"] = "NORMAL",
    ["niV"] = "NORMAL",
    ["v"] = "VISUAL",
    ["V"] = "VISUAL",
    [""] = "VISUAL",
    ["i"] = "INSERT",
    ["ic"] = "INSERT",
    ["ix"] = "INSERT",
    ["R"] = "REPLACE",
    ["Rc"] = "REPLACE",
    ["Rv"] = "REPLACE",
    ["Rx"] = "REPLACE",
    ["c"] = "COMMAND",
    ["cv"] = "COMMAND",
    ["ce"] = "COMMAND",
    ["r"] = "REPLACE",
    ["rm"] = "REPLACE",
    ["r?"] = "REPLACE",
    ["!"] = "REPLACE",
}, {
    __index = function(t, mode)
            if vim.tbl_contains(t, mode) then
                return t[mode]
            end
            return "NORMAL"
    end,
})

local function get_vi_mode(mode, colors)
    local text = mode_map[mode]
    local key = text:sub(1, 1) .. text:sub(2):lower()
    local hl = colors[key:lower()]
    return text, hl
end

return {
    {
        condition = function()
            return not conditions.is_active()
        end,
        hl = function(self)
            return {
                bg = self.colors.vi_mode.inactive.bg,
                fg = self.colors.vi_mode.inactive.fg,
            }
        end,
        provider = function(self)
            local mode = vim.api.nvim_get_mode().mode
            local text = get_vi_mode(mode, self.colors.vi_mode)
            return " " .. text .. " "
        end,
    },
    {
        condition = conditions.is_active,
        hl = function(self)
            local mode = vim.api.nvim_get_mode().mode
            local _, hl = get_vi_mode(mode, self.colors.vi_mode)
            return {
                bg = hl.bg,
                fg = hl.fg,
            }
        end,
        provider = function(self)
            local mode = vim.api.nvim_get_mode().mode
            local text = get_vi_mode(mode, self.colors.vi_mode)
            return " " .. text .. " "
        end,
    },
}
