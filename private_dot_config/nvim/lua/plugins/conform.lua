MiniDeps.add("stevearc/conform.nvim")

MiniDeps.later(function()
  require("conform").setup({
    formatters = {
      biome = {
        args = {
          "format",
          "--semicolons",
          "as-needed",
          "--quote-style",
          "single",
          "--indent-style",
          "space",
          "--line-width",
          "120",
          "--stdin-file-path",
          "$FILENAME",
        },
      },
    },
    formatters_by_ft = {
      typescript = { "biome" },
      typescriptreact = { "biome" },
      javascript = { "biome" },
      json = { "biome" },
      go = { "goimports", "gofumpt" },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  })
end)
