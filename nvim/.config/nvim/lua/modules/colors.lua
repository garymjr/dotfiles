local hi = require('garymjr.highlight').create_highlight
local create_autogroup = require('core.utils').create_autogroup

local M = {}

M.colorscheme = function(colorscheme)
  create_autogroup {
    group_name = 'colors',
    definition = {{ 'ColorScheme', '*', [[lua require'modules.colors'.reload()]] }}
  }

  local cmd = string.format('colorscheme %s', colorscheme)
  vim.cmd(cmd)
end


M.reload = function()
  hi('StatusLine', { guifg = '#5B6268' })
end

return M
