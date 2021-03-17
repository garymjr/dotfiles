local lsp = require 'lspconfig'
local saga = require 'lspsaga'
local compe = require 'compe'
local lsp_status = require 'lsp-status'

lsp.tsserver.setup { on_attach=lsp_status.on_attach }
lsp.vimls.setup { on_attach=lsp_status.on_attach }

local function get_lua_runtime()
  local result = {}
  for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
    local lua_path = path .. "/lua/"
    if vim.fn.isdirectory(lua_path) then
      result[lua_path] = true
    end
  end

  -- This loads the `lua` files from nvim into the runtime.
  result[vim.fn.expand("$VIMRUNTIME/lua")] = true

  -- TODO: Figure out how to get these to work...
  --  Maybe we need to ship these instead of putting them in `src`?...
  result[vim.fn.expand("~/build/neovim/src/nvim/lua")] = true

  return result
end

local sumneko_root_path = os.getenv('HOME') .. '/Code/lua-language-server'
local sumneko_binary = sumneko_root_path .. '/bin/macOS/lua-language-server'
lsp.sumneko_lua.setup {
  cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' },
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT'
      },
      completion = {
        keywordSnippet = 'Disable'
      },
      diagnostics = {
        enable = true,
        globals = { 'vim', 'use' }
      },
      workspace = {
        library = get_lua_runtime(),
        maxPreload = 1000,
        preloadFileSize = 1000
      }
    }
  },
  filetypes = { 'lua' },
  on_attach=lsp_status.on_attach
}

lsp.diagnosticls.setup {
  filetypes={ 'javascript' },
  init_options = {
    linters = {
      eslint = {
        command = './node_modules/.bin/eslint',
        rootPatterns = { '.git' },
        debounce = 100,
        args = {
          '--stdin',
          '--stdin-filename',
          '%filepath',
          '--format',
          'json'
        },
        sourceName = 'eslint',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '${message} [${ruleId}]',
          security = 'severity'
        },
        securities = {
          [2] = 'error',
          [1] = 'warning',
        },
      },
    },
    filetypes = {
      javascript = 'eslint'
    }
  }
}


saga.init_lsp_saga()

compe.setup {
  enabled = true;
  autocomplete = true;
  preselect = 'enable';

  source = {
    path = true;
    buffer = true;
    nvim_lsp = true;
    nvim_lua = true;
  };
}
