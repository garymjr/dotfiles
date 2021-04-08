local hi = require 'garymjr.utils'.hilite
local extract = require 'garymjr.utils'.extract_colors
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
  local colors = extract({
    'Normal',
    'NonText',
  })
  hi('SignColumn', { fg = colors.Normal.fg, bg = colors.Normal.bg })
  hi('LspDiagnosticsDefaultError', { fg = '#AF5F5F' })
  hi('LspDiagnosticsDefaultWarning', { fg = '#87875F' })
  hi('LspDiagnosticsDefaultInformation', { fg = '#5F87AF' })
  hi('LspDiagnosticsDefaultHint', { fg = '#6C6C6C' })
  hi('LspDiagnosticsSignError', { fg = '#AF5F5F' })
  hi('LspDiagnosticsSignWarning', { fg = '#87875F' })
  hi('LspDiagnosticsSignInformation', { fg = '#5F87AF' })
  hi('LspDiagnosticsSignHint', { fg = '#6C6C6C' })
  hi('GitSignsAdd', { fg = '#5F875F' })
  hi('GitSignsDelete', { fg = '#AF5F5F' })
  hi('GitSignsChange', { fg = '#87875F' })
  hi('GitSignsCurrentLineBlame', { fg = colors.NonText.fg })
end

return M
