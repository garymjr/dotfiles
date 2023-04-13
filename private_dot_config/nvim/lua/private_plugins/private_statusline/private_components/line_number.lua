local colors = require("plugins.statusline.colors")

return {
    fallthrough = false,
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
            return { fg = colors.accent }
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
