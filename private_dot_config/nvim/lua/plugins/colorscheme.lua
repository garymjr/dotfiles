return {
  {
    "olivercederborg/poimandres.nvim",
    enabled = false,
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require("poimandres").setup(opts)

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "poimandres",
        callback = function()
          vim.api.nvim_set_hl(0, "LspReferenceText", { fg = "#e4f0fb", bg = "#506477" })
          vim.api.nvim_set_hl(0, "MiniStatuslineModeInsert", { fg = "#1b1e28", bg = "#5de4c7" })
          vim.api.nvim_set_hl(0, "RenderMarkdownCode", { bg = "#313547" })
          vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { bg = "#969abd" })
        end,
      })

      vim.cmd.colorscheme "poimandres"
    end,
  },
  {
    "Mitch1000/backpack.nvim",
    priority = 1000,
    opts = {},
    config = function(_, opts)
      require("backpack").setup(opts)

      vim.cmd.colorscheme "backpack"
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    enabled = false,
    priority = 1000,
    opts = {
      flavour = "mocha",
      background = {
        dark = "mocha",
      },
      term_colors = true,
      styles = {
        comments = { "italic" },
        conditionals = {},
        loops = {},
        functions = {},
        keywords = {},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
      },
      color_overrides = {},
      custom_highlights = {},
      default_integrations = true,
      integrations = {
        cmp = false,
        blink_cmp = {
          style = "bordered",
        },
        gitsigns = false,
        nvimtree = false,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme "catppuccin"
    end,
  },
}
