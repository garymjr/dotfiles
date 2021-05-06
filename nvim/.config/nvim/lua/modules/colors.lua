-- local hi = require('core.utils').highlight
-- local create_autogroup = require('core.utils').create_autogroup

-- create_autogroup {
--   group_name = 'colors',
--   definition = {{ 'ColorScheme', '*', [[lua require'modules.colors'.reload()]] }}
-- }

vim.cmd('colorscheme kikwis')

-- local colors = {
--   red = '#ec7279',
--   yellow = '#deb974',
--   cyan = '#5dbbc1',
--   green = '#a0c980'
-- }

local async
async = vim.loop.new_async(vim.schedule_wrap(function()
--   -- hi('TSVariable', {})
--   -- hi('LineNr', { link = 'Comment' })
  -- hi('LspDiagnosticsDefaultError', { fg = colors.red })
  -- hi('LspDiagnosticsDefaultWarning', { fg = colors.yellow })
  -- hi('LspDiagnosticsDefaultInformation', { fg = colors.cyan })
  -- hi('LspDiagnosticsDefaultHint', { fg = colors.green })

  -- hi('LspDiagnosticsVirtualTextError', { fg = '#ea6962' })
  -- hi('LspDiagnosticsVirtualTextWarning', { fg = '#d8a657' })
  -- hi('LspDiagnosticsVirtualTextInformation', { fg = '#7daea3' })
  -- hi('LspDiagnosticsVirtualTextHint', { fg = '#a9b665' })

--   -- hi('GitSignsAdd', { fg = '#98be65' })
--   -- hi('GitSignsChange', { fg = '#ecbe7b' })
--   -- hi('GitSignsDelete', { fg = '#ff6c6b' })
--   -- hi('GitSignsCurrentLineBlame', { link = 'NonText' })
--   -- hi('StatusLine', { fg = '#242a32', bg = '#ebdbb2' })
  async:close()
end))

local function reload()
  async:send()
end

return {
  reload = reload
}
