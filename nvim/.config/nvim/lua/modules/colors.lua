local hi = require('core.utils').highlight
local create_autogroup = require('core.utils').create_autogroup

local colors = {
  bg = '#32302f',
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

  vim.cmd(string.format([[colorscheme %s]], name))
end

local async
async = vim.loop.new_async(vim.schedule_wrap(function()
  hi('EndOfBuffer', { fg = colors.bg })
  hi('SignColumn', {})
end))

local function reload()
  async:send()
end

return {
  colorscheme = colorscheme,
  reload = reload
}
