local hi = require('core.utils').highlight
local create_autogroup = require('core.utils').create_autogroup

local function colorscheme(name)
  create_autogroup {
    group_name = 'colors',
    definition = {{ 'ColorScheme', '*', [[lua require'modules.colors'.reload()]] }}
  }

  vim.cmd(string.format('colorscheme %s', name))
end

local function reload()
  local async
  async = vim.loop.new_async(vim.schedule_wrap(function()
    hi('TSVariable', {})
    hi('LineNr', { link = 'Comment' })
    hi('LspDiagnosticsDefaultError', { fg = '#ff6c6b' })
    hi('LspDiagnosticsDefaultWarning', { fg = '#ecbe7b' })
    hi('LspDiagnosticsDefaultInformation', { fg = '#51afef' })
    hi('LspDiagnosticsDefaultHint', { fg = '#5b6268'})

    hi('GitSignsAdd', { fg = '#98be65' })
    hi('GitSignsChange', { fg = '#ecbe7b' })
    hi('GitSignsDelete', { fg = '#ff6c6b' })
    hi('GitSignsCurrentLineBlame', { link = 'NonText' })
    async:close()
  end))
  async:send()
end

return {
  colorscheme = colorscheme,
  reload = reload
}
