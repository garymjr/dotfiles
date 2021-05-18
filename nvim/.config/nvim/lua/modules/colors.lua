local hi = require('core.utils').highlight
local create_autogroup = require('core.utils').create_autogroup

local colors = {
  bg = '#2a2331',
  green = '#a2baa8',
  yellow = '#eacac0',
  red = '#fb5c8e'
}

local function colorscheme(name)
  create_autogroup {
    group_name = 'colors',
    definition = {{ 'ColorScheme', '*', [[lua require'modules.colors'.reload()]] }}
  }

  vim.cmd(string.format('colorscheme %s', name))
end

local async
async = vim.loop.new_async(vim.schedule_wrap(function()
  hi('EndOfBuffer', { fg = colors.bg })
  hi('GitSignsAdd', { fg = colors.green })
  hi('GitSignsChange', { fg = colors.yellow })
  hi('GitSignsDelete', { fg = colors.red })
end))

local function reload()
  async:send()
end

return {
  colorscheme = colorscheme,
  reload = reload
}
