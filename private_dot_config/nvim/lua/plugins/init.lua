return {
  { "folke/lazy.nvim", lazy = false, version = false },
  {
    "folke/snacks.nvim",
    lazy = false,
    opts = {
      input = { enabled = true },
      notifier = { enabled = true },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      statuscolumn = { enabled = true },
    },
    config = function(_, opts)
      require("snacks").setup(opts)
    end,
  },
}
