local lspconfig = require 'lspconfig'
local lsp_status = require 'lsp-status'

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
lspconfig.sumneko_lua.setup {
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
