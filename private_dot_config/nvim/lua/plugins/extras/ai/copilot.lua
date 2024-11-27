return {
  {
    "nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.experimental.ghost_text = false
      opts.mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = LazyVim.cmp.confirm({ select = true }),
        ["<S-CR>"] = LazyVim.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }),
        ["<C-CR>"] = function(fallback)
          cmp.abort()
          fallback()
        end,
      })
    end,
    keys = function()
      return {}
    end,
  },
  {
    "github/copilot.vim",
    event = "VeryLazy",
    version = false,
    keys = {
      {
        "<Tab>",
        'copilot#Accept("\\<CR>")',
        mode = "i",
        expr = true,
        silent = true,
        replace_keycodes = false,
        desc = "Accept copilot suggestion",
      },
      {
        "<C-i>",
        "<Plug>(copilot-accept-line)",
        mode = "i",
        silent = true,
        desc = "Accept line",
      },
      {
        "<C-j>",
        "<Plug>(copilot-next)",
        mode = "i",
        silent = true,
        desc = "Next suggestion",
      },
      {
        "<C-k>",
        "<Plug>(copilot-previous)",
        mode = "i",
        silent = true,
        desc = "Previous suggestion",
      },
      {
        "<C-l>",
        "<Plug>(copilot-suggest)",
        mode = "i",
        silent = true,
        desc = "Trigger suggestion",
      },
      {
        "<C-d>",
        "<Plug>(copilot-dismiss)",
        mode = "i",
        silent = true,
        desc = "Dismiss suggestion",
      },
    },
    config = function()
      vim.g.copilot_filetypes = {
        ["TelescopePrompt"] = false,
      }
      vim.g.copilot_assume_mapped = true
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      local Util = require("lazyvim.util")
      table.insert(opts.sections.lualine_x, 2, {
        function()
          local icon = require("lazyvim.config").icons.kinds.Copilot
          return icon
        end,
        cond = function()
          local ok, clients = pcall(vim.lsp.get_clients, { name = "copilot", bufnr = 0 })
          return ok and #clients > 0
        end,
        color = function()
          return Util.ui.fg("Special")
        end,
      })
    end,
  },
}
