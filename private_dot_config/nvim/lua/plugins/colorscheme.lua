require("mini.deps").add {
  enabled = false,
  source = "catppuccin/nvim",
  name = "catppuccin",
}

require("mini.deps").now(function()
  if false then
    require("catppuccin").setup {
      integrations = {
        mason = true,
        markdown = true,
        mini = true,
        native_lsp = {
          enabled = true,
          underlines = {
            errors = { "undercurl" },
            hints = { "undercurl" },
            warnings = { "undercurl" },
            information = { "undercurl" },
          },
        },
        semantic_tokens = true,
        treesitter = true,
        treesitter_context = true,
      },
    }

    vim.cmd.colorscheme "catppuccin"
  end
end)

require("mini.deps").add "EdenEast/nightfox.nvim"
require("mini.deps").now(function()
  require("nightfox").setup {
    options = {
      styles = {
        comments = "italic",
      },
    },
  }

  vim.cmd.colorscheme "duskfox"
end)
