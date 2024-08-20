MiniDeps.add {
  enabled = false,
  source = "catppuccin/nvim",
  name = "catppuccin",
}

MiniDeps.now(function()
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

MiniDeps.add "EdenEast/nightfox.nvim"
MiniDeps.now(function()
  require("nightfox").setup {
    options = {
      styles = {
        comments = "italic",
      },
    },
  }

  vim.cmd.colorscheme "duskfox"
end)
