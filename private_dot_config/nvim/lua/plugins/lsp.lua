local function setup_keymaps(bufnr)
  vim.keymap.set("n", "<leader>cl", "<cmd>LspInfo<cr>", { silent = true, desc = "LspInfo" })
  vim.keymap.set(
    "n",
    "gd",
    vim.lsp.buf.definition,
    { silent = true, buffer = bufnr, desc = "Goto definition" }
  )
  vim.keymap.set(
    "n",
    "gD",
    vim.lsp.buf.declaration,
    { silent = true, buffer = bufnr, desc = "Goto declaration" }
  )
  vim.keymap.set(
    "n",
    "gI",
    vim.lsp.buf.implementation,
    { silent = true, buffer = bufnr, desc = "Goto implementation" }
  )
  vim.keymap.set(
    "n",
    "gr",
    vim.lsp.buf.references,
    { silent = true, buffer = bufnr, desc = "Find references" }
  )
  vim.keymap.set(
    "n",
    "gy",
    vim.lsp.buf.type_definition,
    { silent = true, buffer = bufnr, desc = "Goto type definition" }
  )
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { silent = true, buffer = bufnr })
  vim.keymap.set(
    "n",
    "gK",
    vim.lsp.buf.signature_help,
    { silent = true, buffer = bufnr, desc = "Signature help" }
  )
  vim.keymap.set(
    "n",
    "<leader>ca",
    vim.lsp.buf.code_action,
    { silent = true, buffer = bufnr, desc = "Code action" }
  )
  vim.keymap.set("n", "<leader>cA", function()
    vim.lsp.buf.code_action({ context = { only = { "source" } } })
  end, { silent = true, buffer = bufnr, desc = "Source action" })
  vim.keymap.set(
    "n",
    "<leader>cr",
    vim.lsp.buf.rename,
    { silent = true, buffer = bufnr, desc = "Rename" }
  )
end

MiniDeps.add("williamboman/mason.nvim")

MiniDeps.later(function()
  require("mason").setup()
end)

MiniDeps.add({
  source = "neovim/nvim-lspconfig",
  depends = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
})

MiniDeps.later(function()
  local servers = {
    lua_ls = {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
            path = vim.split(package.path, ";"),
          },
          diagnostics = {
            globals = { "vim" },
            disable = { "need-check-nil" },
            workspaceDelay = -1,
          },
          workspace = {
            checkThirdParty = false,
            library = {
              unpack(vim.api.nvim_get_runtime_file('', true)),
            },
          },
          telemetry = {
            enable = false,
          },
        },
      },
    },
    gopls = {
      on_attach = function(client)
        if not client.server_capabilities.semanticTokensProvider then
          local semantic = client.config.capabilities.textDocument.semanticTokens
          client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = {
              tokenTypes = semantic.tokenTypes,
              tokenModifiers = semantic.tokenModifiers,
            },
            range = true,
          }
        end
      end,
      settings = {
        gopls = {
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
          analyses = {
            fieldalignment = true,
            nilness = true,
            unusedparams = true,
            unusedwrite = true,
            useany = true,
          },
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
          semanticTokens = true,
        },
      },
    },
    tsserver = {
      settings = {
        completions = {
          completeFunctionCalls = true,
        },
      },
    },
  }

  vim.diagnostic.config({
    signs = {
      priorty = 9999,
      severity = {
        min = vim.diagnostic.severity.WARN,
        max = vim.diagnostic.severity.ERROR,
      },
    },
    virtual_text = {
      severity = {
        min = vim.diagnostic.severity.WARN,
        max = vim.diagnostic.severity.ERROR,
      },
    },
    update_in_insert = false,
  })

  require("neodev").setup()

  require("mason-lspconfig").setup({
    handlers = {
      function(server_name)
        local server = servers[server_name] or {}
        server.capabilities = vim.tbl_deep_extend(
          "force",
          {},
          vim.lsp.protocol.make_client_capabilities(),
          require("cmp_nvim_lsp").default_capabilities() or {}
        )
        local on_attach = server.on_attach
        server.on_attach = function(client, bufnr)
          setup_keymaps(bufnr)
          if on_attach then
            on_attach(client, bufnr)
          end
        end

        require("lspconfig")[server_name].setup(server)
      end,
    },
  })
end)
