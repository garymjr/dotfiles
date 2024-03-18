local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
end

require('mini.deps').setup({ path = { package = path_package } })

MiniDeps.now(function()
  vim.cmd.source(vim.fn.stdpath("config") .. "/lua/config/options.lua")
end)

MiniDeps.later(function()
  vim.cmd.source(vim.fn.stdpath("config") .. "/lua/config/keymaps.lua")
  vim.cmd.source(vim.fn.stdpath("config") .. "/lua/config/autocmds.lua")
end)
