return {
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    opts = {
      bracketed = {},
      git = {},
      statusline = {},
      snippets = {},
      surround = {
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr",
          update_n_lines = "gsn",
        },
      },
    },
    config = function(_, opts)
      for _, key in ipairs(vim.tbl_keys(opts)) do
        require("mini." .. key).setup(opts[key])
      end
    end,
  },
  {
    "mini.nvim",
    opts = {
      diff = {
        view = {
          style = "sign",
          signs = {
            add = "▎",
            change = "▎",
            delete = "",
          },
        },
      },
    },
  },
  {
    "mini.nvim",
    opts = function(_, opts)
      local miniclue = require "mini.clue"

      opts.clue = {
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },
        clues = {
          miniclue.gen_clues.builtin_completion(),
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
          { mode = "n", keys = "<leader>a", desc = "ai" },
          { mode = "v", keys = "<leader>a", desc = "ai" },
        },
      }
    end,
  },
  {
    "mini.nvim",
    opts = function(_, opts)
      local gen_loader = require("mini.snippets").gen_loader
      opts.snippets = {
        gen_loader.from_lang(),
      }
    end,
  },
}
