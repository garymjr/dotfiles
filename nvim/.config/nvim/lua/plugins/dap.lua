local dap = require('dap')
local remap = require('core.utils').remap

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

M.attach_to_serenityui_remote = function()
  local config = {
    type = 'node2',
    request = 'attach',
    port = '9230',
    name = 'Server Debug',
    localRoot = '${workspaceFolder}/serenity-ui',
    remoteRoot = '/home/node/app/serenity-ui',
    sourceMaps = true,
    console = 'integratedTerminal'
  }
  require'dap'.run(config)
end

M.attach_to_serenityui = function()
  local config = {
    type = 'node2',
    request = 'attach',
    port = '9230',
    name = 'Server Debug',
    sourceMaps = true,
    console = 'integratedTerminal'
  }
  require'dap'.run(config)
end

vim.cmd [[command! MockDebug lua require'plugins.dap'.attach_to_mockapi()]]
vim.cmd [[command! SerenityRemoteDebug lua require'plugins.dap'.attach_to_serenityui_remote()]]
vim.cmd [[command! SerenityDebug lua require'plugins.dap'.attach_to_serenityui()]]

local opts = { noremap = true, silent = true }
remap('n', '<leader>db', [[<cmd>lua require('dap').toggle_breakpoint()<cr>]], opts)
remap('n', '<leader>dr', [[<cmd>lua require('dap').repl.toggle()<cr>]], opts)
remap('n', '<leader>dK', [[<cmd>lua require('dap.ui.variables').hover()<cr>]], opts)

return M

