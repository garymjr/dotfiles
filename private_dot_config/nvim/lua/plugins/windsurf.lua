return {
  {
    "Exafunction/windsurf.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      enable_cmp_source = false,
      virtual_text = {
        enabled = true,
        manual = false,
      },
    },
    config = function(_, opts)
      require("codeium").setup(opts)
    end,
  },
}
