return {
  {
    "nvim-lspconfig",
    opts = function(_, opts)
      opts.inlay_hints = {
        enabled = false,
      }
    end,
  },
  {
    "snacks.nvim",
    opts = function(_, opts)
      opts.words = {
        enabled = false,
      }
    end,
  },
}
