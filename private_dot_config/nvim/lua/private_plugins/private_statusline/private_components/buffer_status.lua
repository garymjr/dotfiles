return {
    {
        condition = function()
            return vim.bo.modified or vim.bo.readonly
        end,
        provider = "%m%r%h",
    },
}
