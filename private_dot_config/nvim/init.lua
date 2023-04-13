require("config.options")
require("config.builtins")
require("config.lazy")

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require("config.mappings")
        require("config.autocmds")
    end,
})
-- require("gwm.plugins")
