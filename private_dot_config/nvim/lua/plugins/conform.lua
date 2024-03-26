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
          "100",
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
  })

  vim.keymap.set("n", "<leader>cf", function()
    require("conform").format({ lsp_fallback = true })
  end, { silent = true, desc = "Format" })
end)
