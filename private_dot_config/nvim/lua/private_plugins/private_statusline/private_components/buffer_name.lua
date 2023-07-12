return {
    init = function(self)
        self.name = vim.api.nvim_buf_get_name(0)
    end,
    {
        condition = function(self)
            return self.name == ""
        end,
        provider = "[No Name]",
    },
    {
        condition = function(self)
            return self.name ~= ""
        end,
        {
            provider = function(self)
                local home = os.getenv("HOME")
                return vim.fn.fnamemodify(self.name, ":."):gsub(home, "~")
            end,
        },
    },
}
