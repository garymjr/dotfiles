local hilite = require 'gwm.utils'.hilite
local create_autogroup = require 'gwm.utils'.create_autogroup

local M = {}

M.setup = function()
  create_autogroup {
    group_name = 'colors',
    definition = {{ 'ColorScheme', 'deus', [[ lua require'gwm.colors'.reload() ]] }}
  }

  vim.cmd [[ colorscheme deus ]]
end


M.reload = function()
  hilite('LspDiagnosticsDefaultError', { fg = '#fb4934' })
  hilite('LspDiagnosticsUnderlineError', { gui = 'underline', sp = '#fb4934' })
  hilite('LspDiagnosticsDefaultWarning', { fg = '#fabd2f' })
  hilite('LspDiagnosticsUnderlineWarning', { gui = 'underline', sp = '#fabd2f' })
  hilite('LspDiagnosticsDefaultInformation', { fg = '#8ec07c' })
  hilite('LspDiagnosticsDefaultHint', { fg = '#665c54' })
  hilite('SignColumn', { bg = '#2C323B' })
  hilite('GitSignsAdd', { fg = '#98C379' })
  hilite('GitSignsChange', { fg = '#fabd2f' })
  hilite('GitSignsDelete', { fg = '#fb4934' })
end

return M
