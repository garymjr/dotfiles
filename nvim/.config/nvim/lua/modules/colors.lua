local hi = require('core.utils').highlight
local create_autogroup = require('core.utils').create_autogroup

local function colorscheme(name)
  create_autogroup {
    group_name = 'colors',
    definition = {{ 'ColorScheme', '*', [[lua require'modules.colors'.reload()]] }}
  }

  vim.g.gruvbox_material_background  = 'hard'
  vim.g.gruvbox_material_transparent_background = 1
  vim.cmd(string.format('colorscheme %s', name))
end

local function reload()
  local async
  async = vim.loop.new_async(vim.schedule_wrap(function()
    -- hi('TSVariable', {})
    -- hi('LineNr', { link = 'Comment' })
    hi('LspDiagnosticsDefaultError', { fg = '#ea6962' })
    hi('LspDiagnosticsDefaultWarning', { fg = '#d8a657' })
    hi('LspDiagnosticsDefaultInformation', { fg = '#7daea3' })
    hi('LspDiagnosticsDefaultHint', { fg = '#a9b665' })

    hi('LspDiagnosticsVirtualTextError', { fg = '#ea6962' })
    hi('LspDiagnosticsVirtualTextWarning', { fg = '#d8a657' })
    hi('LspDiagnosticsVirtualTextInformation', { fg = '#7daea3' })
    hi('LspDiagnosticsVirtualTextHint', { fg = '#a9b665' })

    -- hi('GitSignsAdd', { fg = '#98be65' })
    -- hi('GitSignsChange', { fg = '#ecbe7b' })
    -- hi('GitSignsDelete', { fg = '#ff6c6b' })
    -- hi('GitSignsCurrentLineBlame', { link = 'NonText' })
    -- hi('StatusLine', { fg = '#242a32', bg = '#ebdbb2' })
    async:close()
  end))
  async:send()
end

return {
  colorscheme = colorscheme,
  reload = reload
}
