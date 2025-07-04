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
      "williamboman/mason-lspconfig.nvim",
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
          cmd = { vim.fn.stdpath "data" .. "/mason/bin/vscode-eslint-language-server", "--stdio" },
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
            "vue",
            "svelte",
            "astro",
          },
          root_markers = {
            ".eslintrc",
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "eslint.config.js",
            "eslint.config.mjs",
            "eslint.config.cjs",
            "eslint.config.ts",
            "eslint.config.mts",
            "eslint.config.cts",
          },
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
          cmd = { vim.fn.stdpath "data" .. "/mason/bin/lua-language-server" },
          filetypes = { "lua" },
          log_level = vim.lsp.protocol.MessageType.Warning,
          root_markers = {
            ".luarc.json",
            ".luarc.jsonc",
            ".luacheckrc",
            ".stylua.toml",
            "stylua.toml",
            "selene.toml",
            "selene.yml",
          },
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
          cmd = { vim.fn.stdpath "data" .. "/mason/bin/gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_markers = { "go.work", "go.mod" },
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
          cmd = { vim.fn.stdpath "data" .. "/mason/bin/vscode-json-language-server", "--stdio" },
          filetypes = { "json", "jsonc" },
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
          cmd = { vim.fn.stdpath "data" .. "/mason/bin/tailwindcss-language-server", "--stdio" },
          -- filetypes copied and adjusted from tailwindcss-intellisense
          filetypes = {
            "aspnetcorerazor",
            "astro",
            "astro-markdown",
            "blade",
            "clojure",
            "django-html",
            "htmldjango",
            "edge",
            "eelixir",
            "elixir",
            "ejs",
            "erb",
            "eruby",
            "gohtml",
            "gohtmltmpl",
            "haml",
            "handlebars",
            "hbs",
            "html",
            "htmlangular",
            "html-eex",
            "heex",
            "jade",
            "leaf",
            "liquid",
            "markdown",
            "mdx",
            "mustache",
            "njk",
            "nunjucks",
            "php",
            "razor",
            "slim",
            "twig",
            "css",
            "less",
            "postcss",
            "sass",
            "scss",
            "stylus",
            "sugarss",
            "javascript",
            "javascriptreact",
            "reason",
            "rescript",
            "typescript",
            "typescriptreact",
            "vue",
            "svelte",
            "templ",
          },
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
          root_markers = {
            "tailwind.config.js",
            "tailwind.config.cjs",
            "tailwind.config.mjs",
            "tailwind.config.ts",
            "postcss.config.js",
            "postcss.config.cjs",
            "postcss.config.mjs",
            "postcss.config.ts",
            "package.json",
          },
        },
        vtsls = {
          cmd = { vim.fn.stdpath "data" .. "/mason/bin/vtsls", "--stdio" },
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          root_markers = { "tsconfig.json", "package.json", "jsconfig.json" },
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
      require("mason-lspconfig").setup()
      require("mason").setup()
      local mr = require "mason-registry"
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          require("lazy.core.handler.event").trigger {
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          }
        end, 100)
      end)

      vim.diagnostic.config(opts.diagnostics)

      for server, server_opts in pairs(opts.servers) do
        server_opts.capabilities = vim.tbl_deep_extend(
          "force",
          {},
          vim.lsp.protocol.make_client_capabilities(),
          -- require("blink.cmp").get_lsp_capabilities(),
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
        "stylua",
        "shfmt",
      },
    },
  },
  {
    "mason-tool-installer.nvim",
    opts = function(_, opts)
      local plugin = require("lazy.core.config").spec.plugins["mason.nvim"]
      if not plugin then
        return opts
      end
      local mason_opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local servers = vim.tbl_filter(function(v)
        return v ~= "*"
      end, vim.tbl_keys(mason_opts.servers))
      opts.ensure_installed = vim.list_extend(opts.ensure_installed, servers or {})
      return opts
    end,
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
