require("mini.deps").now(function()
  require("catppuccin").setup {
    flavour = "mocha",
    term_colors = true,
    styles = {
      -- todo: maybe don't use italics
      -- conditionals = {}
    },
  }

  vim.cmd.colorscheme "catppuccin"
end)
