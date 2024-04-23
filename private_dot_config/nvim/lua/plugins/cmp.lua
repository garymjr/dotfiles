if not Config.use_epo then
  MiniDeps.add({
    source = "hrsh7th/nvim-cmp",
    depends = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "kristijanhusak/vim-dadbod-completion",
      "onsails/lspkind.nvim",
    },
  })

  local function get_lsp_completion_context(completion, source)
    local ok, source_name = pcall(function()
      return source.source.client.config.name
    end)

    if not ok then
      return nil
    end

    -- uncomment to find additional info
    -- print(vim.inspect(completion))

    if source_name == "tsserver" then
      return completion.detail
    elseif source_name == "pyright" and completion.labelDetails ~= nil then
      return completion.labelDetails.description
    elseif source_name == "gopls" and completion.additionalTextEdits ~= nil then
      return completion.detail
    end
  end

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

    local lspkind = require("lspkind")
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
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = lspkind.cmp_format({
          mode = "symbol",
          ellipsis_char = "…",
          before = function(entry, item)
            local abbr_width_max = 15
            local menu_width_max = 20

            local cmp_ctx = get_lsp_completion_context(entry.completion_item, entry.source)
            if cmp_ctx ~= nil and cmp_ctx ~= "" then
              item.menu = cmp_ctx
            else
              item.menu = ""
            end

            local abbr_width = string.len(item.abbr)
            if abbr_width < abbr_width_max then
              local padding = string.rep(' ', abbr_width_max - abbr_width)
              item.abbr = item.abbr .. padding
            end

            local menu_width = string.len(item.menu)
            if menu_width > menu_width_max then
              item.menu = vim.fn.strcharpart(item.menu, 0, menu_width_max - 1)
              item.menu = item.menu .. "…"
            else
              local padding = string.rep(' ', menu_width_max - menu_width)
              if menu_width > 0 then
                item.menu = padding .. item.menu
              end
            end

            return item
          end,
        }),
      },
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

for k, v in pairs({
  CmpItemAbbrMatch      = "Number",
  CmpItemMenu           = "NonText",
  CmpItemAbbrMatchFuzzy = "CmpItemAbbrMatch",
  CmpItemKindInterface  = "CmpItemKindVariable",
  CmpItemKindText       = "CmpItemKindVariable",
  CmpItemKindMethod     = "CmpItemKindFunction",
  CmpItemKindProperty   = "CmpItemKindKeyword",
  CmpItemKindUnit       = "CmpItemKindKeyword",
}) do
  vim.api.nvim_set_hl(0, k, { link = v })
end
