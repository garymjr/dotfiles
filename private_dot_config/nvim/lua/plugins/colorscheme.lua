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
      flavour = "macchiato",
    },
  },
  {
    "rose-pine/neovim",
    enabled = false,
    dependencies = {
      {
        "LazyVim",
        opts = {
          colorscheme = "rose-pine",
        },
      },
    },
    name = "rose-pine",
    lazy = false,
    priority = 1000,
    opts = {
      variant = "moon",
    },
  },
}
