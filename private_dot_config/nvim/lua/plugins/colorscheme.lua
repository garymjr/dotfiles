return {
  { "tokyonight.nvim", enabled = false },
  { "catppuccin/nvim", enabled = false },
  {
    "rose-pine/neovim",
    enabled = false,
    lazy = false,
    priority = 1000,
    name = "rose-pine",
    opts = {
      variant = "moon",
      dark_variant = "moon",
    },
    config = function(_, opts)
      require("rose-pine").setup(opts)
    end,
  },
  {
    "olivercederborg/poimandres.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      highlight_groups = {
        MatchParen = { fg = "#506477" },
      },
    },
  },
  {
    "LazyVim",
    opts = {
      colorscheme = function()
        vim.cmd.colorscheme("poimandres")
      end,
    },
  },
}
