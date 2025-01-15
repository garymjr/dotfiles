return {
  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format()
        end,
        mode = { "n", "v" },
        desc = "Format",
      },
      {
        "<leader>cF",
        function()
          require("conform").format({ formatters = { "injected" }, timeout_ms = 3000 })
        end,
        mode = { "n", "v" },
        desc = "Format Injected Langs",
      },
    },
    opts = {
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      formatters = {
        injected = { options = { ignore_errors = true } },
      },
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = { "prettierd" },
      },
    },
  },
}
