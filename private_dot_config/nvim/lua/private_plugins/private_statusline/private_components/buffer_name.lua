local conditions = require("heirline.conditions")

return {
    init = function(self)
        self.name = vim.api.nvim_buf_get_name(0)
    end,
    {
        condition = function(self)
            return self.name == ""
        end,
        provider = "[scratch]",
    },
    {
        condition = function(self)
            return self.name ~= ""
        end,
        fallthrough = false,
        {
            condition = conditions.is_active,
            provider = function(self)
                local home = os.getenv("HOME")
                return vim.fn.fnamemodify(self.name, ":."):gsub(home, "~")
            end,
        },
        {
            provider = function(self)
                return vim.fn.fnamemodify(self.name, ":t")
            end,
        },
    },
}
