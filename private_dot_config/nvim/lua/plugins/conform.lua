require("mini.deps").add {
  source = "stevearc/conform.nvim",
  depends = {
    "williamboman/mason.nvim",
  },
}

require("mini.deps").later(function()
  require("conform").setup {
    default_format_opts = {
      timeout_ms = 3000,
      async = false,
      quiet = false,
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      lua = { "stylua" },
    },
  }

  vim.keymap.set(
    "n",
    "<leader>cf",
    function() require("conform").format { bufnr = 0 } end,
    { desc = "[C]ode [F]ormat" }
  )
end)
