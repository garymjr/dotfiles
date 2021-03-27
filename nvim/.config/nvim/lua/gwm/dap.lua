local dap = require('dap')

dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = { os.getenv('HOME') .. '/.dap/vscode-node-debug2/out/src/nodeDebug.js' }
}

dap.configurations.javascript = {
  {
    type = 'node2',
    request = 'launch',
    program = '${workspaceFolder}/${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal'
  }
}

local M = {}
M.run_cnva_ssr_debug = function()
  local config = {
    type = 'node2',
    request = 'launch',
    name = 'Server Debug',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    program = '${workspaceFolder}/build/server.js',
    skipFiles = { '<node_internals>/**' },
    console = 'integratedTerminal',
    continueOnAttach = true
  }
  require'dap'.run(config)
end

vim.api.nvim_set_keymap('n', '<leader>csdb', [[ :lua require'gwm.dap'.run_cnva_ssr_debug()<cr> ]], { noremap = true })

return M

