local H = {}

function H.opts(name)
  local plugin = H.get_plugin(name)
  if not plugin then
    return {}
  end
  local Plugin = require("lazy.core.plugin")
  return Plugin.values(plugin, "opts", false)
end

function H.get_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

H.action = setmetatable({}, {
  __index = function(_, action)
    return function()
      vim.lsp.buf.code_action({
        apply = true,
        context = {
          only = { action },
          diagnostics = {},
        },
      })
    end
  end,
})

function H.apply_keymaps(bufnr)
  if vim.bo[bufnr].filetype == "codecompanion" then
    return
  end

  local map = function(mode, lhs, rhs, opts)
    local options = vim.tbl_deep_extend("force", { silent = true, buffer = bufnr }, opts or {})
    vim.keymap.set(mode, lhs, rhs, options)
  end

  map("n", "<leader>cl", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
  map("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
  map("n", "gr", vim.lsp.buf.references, { desc = "References", nowait = true })
  map("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
  map("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto Type Definition" })
  map("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
  map("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  map("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
  map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename" })
  map("n", "<leader>cA", H.action.source, { desc = "Source Action" })
end

return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
      "mason.nvim",
      { "williamboman/mason-lspconfig.nvim", config = function() end },
    },
    opts = function()
      local ret = {
        diagnostics = {
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
        },
        capabilities = {
          workspace = {
            fileOperations = {
              didRename = true,
              willRename = true,
            },
          },
        },
        servers = {
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
        },
      }
      return ret
    end,
    config = function(_, opts)
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("pde_lsp", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if not client then
            return
          end

          if client.name ~= "GitHub Copilot" then
            H.apply_keymaps(args.buf)
          end
        end,
      })

      local servers = opts.servers
      local has_blink, blink = pcall(require, "blink.cmp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_blink and blink.get_lsp_capabilities() or {},
        opts.capabilities or {}
      )

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})
        if server_opts.enabled == false then
          return
        end

        require("lspconfig")[server].setup(server_opts)
      end

      local have_mason, mlsp = pcall(require, "mason-lspconfig")

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.enabled ~= false then
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        ---@diagnostic disable-next-line: missing-fields
        mlsp.setup({
          ensure_installed = vim.tbl_deep_extend(
            "force",
            ensure_installed,
            H.opts("mason-lspconfig.nvim").ensure_installed or {}
          ),
          handlers = { setup },
        })
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },
}
