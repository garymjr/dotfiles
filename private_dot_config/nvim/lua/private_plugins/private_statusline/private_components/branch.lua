local conditions = require("heirline.conditions")

return {
    condition = conditions.is_git_repo,
    {
        provider = function()
            local gitsigns = vim.b.gitsigns_status_dict
            if gitsigns then
                return gitsigns.head
            end
        end,
    },
    { provider = " | " },
}
