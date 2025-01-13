return {
  { "bufferline.nvim", enabled = false },
  {
    "snacks.nvim",
    opts = {
      indent = { enabled = false },
      scroll = { enabled = false },
      words = { enabled = false },
    },
  },
  {
    "noice.nvim",
    opts = {
      lsp = {
        hover = {
          silent = true,
        },
      },
    },
  },
}
