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
    enabled = false,
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    dependencies = {
      {
        "LazyVim",
        opts = {
          colorscheme = "rose-pine",
        },
      },
    },
    opts = {
      variant = "moon",
    },
  },
}
