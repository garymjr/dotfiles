local servers = {
  lexical = {},
  lua_ls = {
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        codeLens = {
          enable = true,
        },
        completion = {
          callSnippet = "Replace",
        },
        doc = {
          privateName = { "^_" },
        },
        hint = {
          enable = true,
          setType = false,
          paramType = true,
          paramName = "Disable",
          semicolon = "Disable",
          arrayIndex = "Disable",
        },
      },
    },
  },
  tailwindcss = {
    init_options = {
      userLanguages = {
        elixir = "html-eex",
        eelixir = "html-eex",
        heex = "html-eex",
      },
    },
  },
}

local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  {
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  }
)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("minivim_lsp_attach", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client == nil then
      return
    end

    vim.keymap.set("n", "gd", "<cmd>Pick lsp scope='definition'<cr>", { desc = "Goto Definition", buffer = event.buf })
    vim.keymap.set("n", "gr", "<cmd>Pick lsp scope='references'<cr>", { desc = "Goto Reference", buffer = event.buf })
    vim.keymap.set("n", "gI", "<cmd>Pick lsp scope='implementation'<cr>",
      { desc = "Goto Implementation", buffer = event.buf })
    vim.keymap.set("n", "gy", "<cmd>Pick lsp scope='type_definition'<cr>",
      { desc = "Goto T[y]pe Definition", buffer = event.buf })
    vim.keymap.set("n", "gD", "<cmd>Pick lsp scope='declaration'<cr>", { desc = "Goto Declaration", buffer = event.buf })
    vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help", buffer = event.buf })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action", buffer = event.buf })
    vim.keymap.set("n", "<leader>cA", function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { "source" },
          diagnostics = {},
        }
      })
    end, { desc = "Code Action", buffer = event.buf })
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename", buffer = event.buf })
  end,
})

MiniDeps.later(function()
  vim.diagnostic.config {
    underline = true,
    update_in_insert = false,
    virtual_text = {
      spacing = 4,
      source = "if_many",
      prefix = "●",
    },
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      },
    },
  }

  -- require("fidget").setup {}
  require("mason").setup()

  require("lazydev").setup {
    library = {
      { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
  }

  require("mason-lspconfig").setup {
    ensure_installed = vim.tbl_keys(servers),
    handlers = {
      function(server_name)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server_name] or {})
        require("lspconfig")[server_name].setup(server_opts)
      end
    },
  }
end)
