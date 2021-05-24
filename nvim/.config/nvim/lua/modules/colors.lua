local hi = require('core.utils').highlight
local create_autogroup = require('core.utils').create_autogroup

local colors = {
  bg = '#2c2e34',
  green = '#9ed072',
  yellow = '#eacac0',
  red = '#fb5c8e',
  blue = '#76cce0'
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
  hi('SignColumn', {})
  hi('GreenSign', { fg = colors.green, bg = colors.bg })
  hi('BlueSign', { fg = colors.blue, bg = colors.bg })
  hi('RedSign', { fg = colors.red, bg = colors.bg })
end))

local function reload()
  async:send()
end

return {
  colorscheme = colorscheme,
  reload = reload
}
