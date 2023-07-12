local mark = require("harpoon.mark")

local function has_mark()
    local bufnr = vim.api.nvim_get_current_buf()
    local status = mark.status(bufnr)
    return status ~= ""
end

return {
    condition = has_mark,
    {
        provider = function()
            local bufnr = vim.api.nvim_get_current_buf()
            local status = mark.status(bufnr)
            return string.format("[%s]", status)
        end
    },
    { provider = " " },
}
