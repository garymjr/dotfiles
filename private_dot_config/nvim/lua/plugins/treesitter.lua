require("mini.deps").add {
  source = "nvim-treesitter/nvim-treesitter",
  depends = {
    "windwp/nvim-ts-autotag",
    "folke/ts-comments.nvim",
  },
  hooks = {
    post_checkout = function() vim.cmd "TSUpdate" end,
  },
}

require("mini.deps").now(function() require "nvim-treesitter.query_predicates" end)

require("mini.deps").later(function()
  require("ts-comments").setup()
end)

require("mini.deps").later(
  function()
    require("nvim-treesitter.configs").setup {
      highlight = { enable = true },
      indent = { enable = true },
      ensure_installed = require("config").grammars,
      textobjects = {
        move = {
          enable = true,
          goto_next_start = {
            ["]f"] = "@function.outer",
            ["]c"] = "@class.outer",
            ["]a"] = "@parameter.inner",
          },
          goto_next_end = {
            ["]F"] = "@function.outer",
            ["]C"] = "@class.outer",
            ["]A"] = "@parameter.inner",
          },
          goto_previous_start = {
            ["[f"] = "@function.outer",
            ["[c"] = "@class.outer",
            ["[a"] = "@parameter.inner",
          },
          goto_previous_end = {
            ["[F"] = "@function.outer",
            ["[C"] = "@class.outer",
            ["[A"] = "@parameter.inner",
          },
        },
      },
    }
  end
)

require("mini.deps").later(
  function()
    require("nvim-ts-autotag").setup {
      aliases = {
        heex = "html",
      },
    }
  end
)
