local lsp = require 'lspconfig'
local saga = require 'lspsaga'
local compe = require 'compe'
local lsp_status = require 'lsp-status'

local function eslint_config_exists()
  local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)

  if not vim.tbl_isempty(eslintrc) then
    return true
  end

  if vim.fn.filereadable("package.json") then
    if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
      return true
    end
  end

  return false
end

local eslint = {
  lintCommand = "eslint_d -f unix --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = {"%f:%l:%c: %m"},
  -- formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
  -- formatStdin = true
}

lsp.tsserver.setup {
  on_attach=lsp_status.on_attach,
  cmd = { 'typescript-language-server', '--stdio', '--tsserver-path='..os.getenv('HOME')..'/.nvm/versions/node/v14.15.1/bin/tsserver' }
}

lsp.svelte.setup {}

lsp.vimls.setup { on_attach=lsp_status.on_attach }

lsp.efm.setup {
  on_attach = function(client)
    client.resolved_capabilities.document_formatting = true
    client.resolved_capabilities.goto_definition = false
  end,
  root_dir = function()
    if not eslint_config_exists() then
      print('oops, i dun messed up')
      return nil
    end
    return vim.fn.getcwd()
  end,
  settings = {
    languages = {
      javascript = {eslint},
      javascriptreact = {eslint},
      ["javascript.jsx"] = {eslint},
      typescript = {eslint},
      ["typescript.tsx"] = {eslint},
      typescriptreact = {eslint}
    }
  },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescript.tsx",
    "typescriptreact"
  }
}

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

-- lsp.diagnosticls.setup {
--   filetypes={ 'javascript' },
--   init_options = {
--     linters = {
--       eslint = {
--         command = 'eslint_d',
--         rootPatterns = { '.git' },
--         debounce = 100,
--         args = {
--           '--stdin',
--           '--stdin-filename',
--           '%filepath',
--           '--format',
--           'json'
--         },
--         sourceName = 'eslint',
--         parseJson = {
--           errorsRoot = '[0].messages',
--           line = 'line',
--           column = 'column',
--           endLine = 'endLine',
--           endColumn = 'endColumn',
--           message = '${message} [${ruleId}]',
--           security = 'severity'
--         },
--         securities = {
--           [2] = 'error',
--           [1] = 'warning',
--         },
--       },
--     },
--     filetypes = {
--       javascript = 'eslint'
--     }
--   }
-- }


saga.init_lsp_saga {
  code_action_prompt = {
    enable = false
  }
}

compe.setup {
  enabled = true,
  autocomplete = true,
  debug = true,
  preselect = 'enable',
  documentation = true,

  source = {
    path = true,
    buffer = true,
    nvim_lsp = true,
    nvim_lua = true,
    treesitter = true
  };
}

vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}
