return {
    condition = function()
        return vim.bo.modified or vim.bo.readonly
    end,
    { provider = " " },
    { provider = "%m%r%h" },
    { provider = " " },
}
