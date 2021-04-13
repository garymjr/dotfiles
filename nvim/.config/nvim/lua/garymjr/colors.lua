local hi = require 'garymjr.utils'.hilite
local create_autogroup = require 'garymjr.utils'.create_autogroup

local M = {}

M.setup = function(config)
  create_autogroup {
    group_name = 'colors',
    definition = {{ 'ColorScheme', '*', [[lua require'garymjr.colors'.reload()]] }}
  }

  local cmd = string.format('colorscheme %s', config.colorscheme)
  vim.cmd(cmd)
end


M.reload = function()
  hi('StatusLine', { bg = '#FFF8E7', fg = '#282A37' })
end

return M
