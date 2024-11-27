return {
  { "indent-blankline.nvim", enabled = false },
  {
    "noice.nvim",
    opts = {
      routes = {
        {
          filter = {
            event = "notify",
            find = "No information available",
          },
          opts = { skip = true },
        },
      },
    },
  },
  {
    "bufferline.nvim",
    enabled = false,
    opts = {
      options = {
        custom_filter = function(buf_number)
          if vim.bo[buf_number].filetype == "codecompanion" then
            return false
          end
          return true
        end,
      },
    },
  },
}
