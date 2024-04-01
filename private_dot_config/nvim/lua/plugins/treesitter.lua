MiniDeps.add({
  source = "nvim-treesitter/nvim-treesitter",
  hooks = {
    post_checkout = function() vim.cmd("TSUpdate") end,
  },
})

MiniDeps.later(function()
  require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "csv",
      "diff",
      "go",
      "gomod",
      "gowork",
      "gosum",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "json5",
      "jsonc",
      "lua",
      "markdown",
      "markdown_inline",
      "query",
      "regex",
      "sql",
      "toml",
      "tsx",
      "typescript",
      "vimdoc",
      "yaml",
    },
  })
end)
