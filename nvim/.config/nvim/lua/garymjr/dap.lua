local dap = require('dap')

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { os.getenv('HOME') .. '/.dap/vscode-node-debug2/out/src/nodeDebug.js' }
}

-- dap.configurations.javascript = {
--   {
--     type = 'node2',
--     request = 'launch',
--     program = '${workspaceFolder}/${file}',
--     cwd = vim.fn.getcwd(),
--     sourceMaps = true,
--     protocol = 'inspector',
--     console = 'integratedTerminal'
--   }
-- }

local M = {}
M.attach_to_mockapi = function()
  local config = {
    type = 'node2',
    request = 'attach',
    port = '9239',
    name = 'MockApi Debug',
    localRoot = '${workspaceFolder}/mockapi',
    remoteRoot = '/mockapi',
    console = 'integratedTerminal'
  }
  require'dap'.run(config)
end

M.attach_to_serenityui = function()
  local config = {
    type = 'node2',
    request = 'attach',
    port = '9229',
    name = 'Server Debug',
    localRoot = '${workspaceFolder}/serenity-ui',
    remoteRoot = '/home/node/app/serenity-ui',
    console = 'integratedTerminal'
  }
  require'dap'.run(config)
end

vim.cmd [[command! MockDebug lua require'garymjr.dap'.attach_to_mockapi()]]
vim.cmd [[command! SerenityDebug lua require'garymjr.dap'.attach_to_serenityui()]]

return M

