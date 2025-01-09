return {
  {
    "catppuccin",
    dependencies = {
      {
        "LazyVim",
        opts = {
          colorscheme = "catppuccin",
        },
      },
    },
    opts = {
      flavour = "mocha",
    },
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "moon",
    },
  },
  {
    "LazyVim",
    opts = {
      colorscheme = "rose-pine",
    },
  },
}
