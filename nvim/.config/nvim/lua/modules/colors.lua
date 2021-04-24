local hi = require('garymjr.highlight').create_highlight
local hilink = require('garymjr.highlight').create_highlight_link
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
  -- hi('StatusLine', { guifg = '#5B6268' })
  -- hi('SignColumn', { guibg = '#1E1D1A' })
  hi('LspDiagnosticsDefaultError', { guifg = '#af5f5f' })
  hi('LspDiagnosticsDefaultWarning', { guifg = '#af8700' })
  hi('LspDiagnosticsDefaultInformation', { guifg = '#5f87af' })
  hi('LspDiagnosticsDefaultHint', { guifg = '#5f5f87' })

  hi('GitSignsAdd', { guifg = '#87af87' })
  hi('GitSignsChange', { guifg = '#d7af5f' })
  hi('GitSignsDelete', { guifg = '#d7875f' })
  hilink('CursorLineNr', 'Normal', true)
  hilink('GitSignsCurrentLineBlame', 'NonText', true)
end

return M
