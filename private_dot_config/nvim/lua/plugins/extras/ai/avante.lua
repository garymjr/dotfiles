return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = "make",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "echasnovski/mini.icons",
      "github/copilot.vim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
    },
    opts = {
      provider = "copilot",
      auto_suggestions_provider = "copilot",
      -- copilot = {
      --   model = "claude-3.5-sonnet",
      -- },
      behaviour = {
        auto_suggestions = false,
        auto_apply_diff_after_generation = true,
      },
    },
    config = function(_, opts)
      require("avante_lib").load()
      require("avante").setup(opts)
      vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#22242a" })
    end,
  },
}
