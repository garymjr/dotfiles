local utils = require("heirline.utils")

local colors = {
    gutter_text = utils.get_highlight("LineNr").fg,
    gutter_text_current = utils.get_highlight("Normal").fg,
}

return {
    fallthrough = false,
    hl = {
        fg = colors.gutter_text,
    },
    {
        condition = function()
            local mode = vim.api.nvim_get_mode().mode
            mode = mode:sub(1, 1)
            return mode == "i"
        end,
        provider = "%l"
    },
    {
        condition = function()
            local mode = vim.api.nvim_get_mode().mode
            mode = mode:sub(1, 1)
            return vim.v.relnum == 0
        end,
        hl = function()
            local mode = vim.api.nvim_get_mode().mode
            mode = mode:sub(1, 1)
            return { fg = colors.gutter_text_current }
        end,
        provider = "%l"
    },
    {
        condition = function()
            return vim.v.relnum > 0
        end,
        provider = "%r",
    },
}
