local Color, c, Group, g, s = require('colorbuddy').setup()

vim.cmd [[ colorscheme candid ]]

local M = {}

M.setup = function()
  vim.cmd [[ augroup Colors ]]
  vim.cmd [[ autocmd! ]]
  vim.cmd [[ autocmd ColorScheme * lua require('gwm.colors').reload() ]]
  vim.cmd [[ augroup END ]]
end


M.reload = function()
  -- Color.new('error', '#DC657D')
  -- Color.new('warning', '#D4B261')
  -- Color.new('info', '#72C7D1')
  -- Color.new('hint', '#444444');

  -- Group.new('Comment', g.Comment, g.Comment, s.italic)
  -- Group.new('LspDiagnosticsDefaultHint', c.hint)
  -- Group.new('LspDiagnosticsDefaultError', c.error)
  -- Group.new('LspDiagnosticsDefaultWarning', c.warning)
  -- Group.new('LspDiagnosticsDefaultInformation', c.info)
  -- Group.new('LspDiagnosticsDefaultHint', c.hint)
end

return M
