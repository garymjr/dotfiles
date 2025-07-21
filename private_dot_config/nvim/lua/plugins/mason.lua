local H = {}

function H.on_attach(client, bufnr)
  local ignored_filetypes = { "codecompanion", "copilot-chat" }
  if vim.tbl_contains(ignored_filetypes, vim.bo[bufnr].filetype) or not client then
    return
  end

  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr, desc = "Go to Definition" })
end

return {
  {
    "williamboman/mason.nvim",
    event = "VeryLazy",
    dependencies = {
      "b0o/SchemaStore.nvim",
      "neovim/nvim-lspconfig",
      "Saghen/blink.cmp",
    },
    cmd = "Mason",
    keys = {
      { "<leader>cm", "<cmd>Mason<cr>", { desc = "Mason" } },
    },
    build = ":MasonUpdate",
    opts = {
      capabilities = {
        workspace = {
          fileOperations = {
            didRename = true,
            willRename = true,
          },
        },
      },
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
      },
      servers = {
        ["*"] = {
          on_attach = H.on_attach,
        },
        elixirls = {
          cmd = { vim.fn.stdpath "data" .. "/mason/bin/elixir-ls" },
          filetypes = { "elixir", "eelixir", "heex", "surface" },
          root_markers = { "mix.exs" },
          single_file_support = true,
        },
        eslint = {
          settings = {
            codeAction = {
              disableRuleComment = {
                enable = true,
                location = "separateLine",
              },
              showDocumentation = {
                enable = true,
              },
            },
            codeActionOnSave = {
              enable = false,
              mode = "all",
            },
            experimental = {
              useFlatConfig = true,
            },
            format = false,
            nodePath = "",
            onIgnoredFiles = "off",
            packageManager = nil,
            problems = {
              shortenToSingleLine = false,
            },
            quiet = false,
            rulesCustomizations = {},
            run = "onType",
            useESLintClass = false,
            validate = "on",
            workingDirectories = { mode = "auto" },
          },
        },
        lua_ls = {
          log_level = vim.lsp.protocol.MessageType.Warning,
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
            },
          },
          single_file_support = true,
        },
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
          single_file_support = true,
        },
        jsonls = {
          init_options = {
            provideFormatter = true,
          },
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
          single_file_support = true,
        },
        tailwindcss = {
          on_new_config = function(new_config)
            if not new_config.settings then
              new_config.settings = {}
            end
            if not new_config.settings.editor then
              new_config.settings.editor = {}
            end
            if not new_config.settings.editor.tabSize then
              -- set tab size for hover
              new_config.settings.editor.tabSize = vim.lsp.util.get_effective_tabstop()
            end
          end,
          settings = {
            tailwindCSS = {
              validate = true,
              lint = {
                cssConflict = "warning",
                invalidApply = "error",
                invalidScreen = "error",
                invalidVariant = "error",
                invalidConfigPath = "error",
                invalidTailwindDirective = "error",
                recommendedVariantOrder = "warning",
              },
              classAttributes = {
                "class",
                "className",
                "class:list",
                "classList",
                "ngClass",
              },
              includeLanguages = {
                elixir = "html-eex",
                eelixir = "html-eex",
                eruby = "erb",
                heex = "html-eex",
                templ = "html",
                htmlangular = "html",
              },
            },
          },
        },
        vtsls = {
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
            },
          },
          single_file_support = true,
        },
      },
    },
    config = function(_, opts)
      require("mason").setup()

      vim.diagnostic.config(opts.diagnostics)

      for server, server_opts in pairs(opts.servers) do
        server_opts.capabilities = vim.tbl_deep_extend(
          "force",
          {},
          vim.lsp.protocol.make_client_capabilities(),
          require("blink.cmp").get_lsp_capabilities(),
          opts.capabilities or {},
          server_opts.capabilities or {}
        )

        vim.lsp.config(server, server_opts)

        if server ~= "*" then
          vim.lsp.enable(server)
        end
      end
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    lazy = false,
    priority = 1000,
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "elixir-ls",
        "eslint-lsp",
        "gopls",
        "json-lsp",
        "lua-language-server",
        "shfmt",
        "stylua",
        "tailwindcss-language-server",
        "vtsls",
        "stylua",
        "shfmt",
      },
    },
  },
  {
    "mason.nvim",
    init = function()
      ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
      local progress = vim.defaulttable()
      vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
          if not client or type(value) ~= "table" then
            return
          end
          local p = progress[client.id]

          for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
              p[i] = {
                token = ev.data.params.token,
                msg = ("%3d%% %s%s"):format(
                  value.kind == "end" and 100 or value.percentage or 100,
                  value.title or "",
                  value.message and (" **%s**"):format(value.message) or ""
                ),
                done = value.kind == "end",
              }
              break
            end
          end

          local msg = {} ---@type string[]
          progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
          end, p)

          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          ---@diagnostic disable-next-line: param-type-mismatch
          vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
              notif.icon = #progress[client.id] == 0 and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
    end,
  },
}
