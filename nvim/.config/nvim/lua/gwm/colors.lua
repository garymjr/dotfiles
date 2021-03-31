local hi = require 'gwm.utils'.hilite
local create_autogroup = require 'gwm.utils'.create_autogroup

local M = {}

M.setup = function()
  create_autogroup {
    group_name = 'colors',
    definition = {{ 'ColorScheme', '*', [[ lua require'gwm.colors'.reload() ]] }}
  }

  -- vim.g.everforest_background = 'soft'
  vim.cmd [[ colorscheme everforest  ]]
end


M.reload = function()
  hi('SignColumn', { bg = '#2f383e' })
  hi('RedSign', { fg = '#e67e80' })
  hi('OrangeSign', { fg = '#e69875' })
  hi('YellowSign', { fg = '#dbbc7f' })
  hi('GreenSign', { fg = '#a7c080' })
  hi('AquaSign', { fg = '#83c092' })
  hi('BlueSign', { fg = '#7fbbb3' })
  hi('PurpleSign', { fg = '#d699b6' })
  hi('TSWarning', { fg = '#dbbc7f'})
end

return M
