local hi = require('core.utils').highlight
local create_autogroup = require('core.utils').create_autogroup


local function colorscheme(name)
  create_autogroup {
    group_name = 'colors',
    definition = {{ 'ColorScheme', '*', [[lua require'modules.colors'.reload()]] }}
  }
  vim.cmd(string.format('colorscheme %s', name))
end

local async
async = vim.loop.new_async(vim.schedule_wrap(function()
  hi('GitSignsAdd', { fg = '#a2baa8' })
  hi('GitSignsChange', { fg = '#eacac0' })
  hi('GitSignsDelete', { fg = '#fb5c8e' })
  hi('EndOfBuffer', { fg = '#2a2331' })
end))

local function reload()
  async:send()
end

return {
  colorscheme = colorscheme,
  reload = reload
}
