if not Config.use_epo then
  MiniDeps.add({
    source = "hrsh7th/nvim-cmp",
    depends = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "kristijanhusak/vim-dadbod-completion",
    },
  })

  MiniDeps.later(function()
    local cmp = require("cmp")
    local defaults = require("cmp.config.default")()
    vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

    local sources = cmp.config.sources(
      {
        {
          name = "copilot",
          priority = 100,
        },
        { name = "nvim_lsp" },
        { name = "path" },
      },
      {
        { name = "buffer" },
      }
    )

    local has_copilot, _ = pcall(require, "copilot")
    if has_copilot then
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup()

      table.insert(sources, 1, {
        name = "copilot",
        priority = 100,
        group_index = 1,
      })
    end

    cmp.setup({
      completion = {
        completeopt = "menu,menuone,noinsert",
      },
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        -- ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = sources,
      experimental = {
        ghost_text = {
          hl_group = "CmpGhostText",
        },
      },
      sorting = defaults.sorting,
    })

    vim.keymap.set(
      "i",
      "<Tab>",
      function()
        if vim.snippet.jumpable(1) then
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
          return
        end
        return "<Tab>"
      end,
      {
        expr = true,
        silent = true,
      }
    )

    vim.keymap.set(
      "s",
      "<Tab>",
      function()
        vim.schedule(function()
          vim.snippet.jump(1)
        end)
      end
    )

    vim.keymap.set(
      { "i", "s" },
      "<S-Tab>",
      function()
        if vim.snippet.jumpable(-1) then
          vim.schedule(function()
            vim.snippet.jump(-1)
          end)
          return
        end
        return "<S-Tab>"
      end,
      {
        expr = true,
        silent = true,
      }
    )

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("gwm_dadbod_completion", { clear = true }),
      pattern = "sql,mysql,plsql",
      callback = function()
        require("cmp").setup.buffer({ sources = { { name = "vim-dadbod-completion" } } })
      end,
    })
  end)
end
