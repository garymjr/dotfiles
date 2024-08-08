require("mini.deps").later(function()
  require("ts-comments").setup()
  require("nvim-treesitter.query_predicates")
  require("nvim-treesitter.configs").setup {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = {
      "bash",
      "c",
      "diff",
      "eex",
      "elixir",
      "graphql",
      "heex",
      "html",
      "javascript",
      "jsdoc",
      "json",
      "jsonc",
      "lua",
      "luadoc",
      "luap",
      "markdown",
      "markdown_inline",
      "printf",
      "python",
      "query",
      "regex",
      "sql",
      "toml",
      "tsx",
      "typescript",
      "vim",
      "vimdoc",
      "xml",
      "yaml",
    },
  }

  require("nvim-ts-autotag").setup {
    aliases = {
      heex = "html",
    },
  }
end)
