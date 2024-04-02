MiniDeps.add({
  source = "nvim-treesitter/nvim-treesitter",
  hooks = {
    post_checkout = function() vim.cmd("TSUpdate") end,
  },
})

MiniDeps.add("nvim-treesitter/nvim-treesitter-context")

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
      "graphql",
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
      "templ",
      "toml",
      "tsx",
      "typescript",
      "vimdoc",
      "yaml",
    },
  })
end)

MiniDeps.later(function()
  require("treesitter-context").setup({
    enable = true,
    max_lines = 1,
  })
end)
