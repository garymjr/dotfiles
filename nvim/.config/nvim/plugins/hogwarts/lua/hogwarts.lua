local Color, c, Group, g, s = require('colorbuddy').setup()

vim.cmd [[ colorscheme neodark ]]
local M = {}
M.setup = function()
  vim.cmd [[ augroup Colors ]]
  vim.cmd [[ autocmd! ]]
  vim.cmd [[ autocmd ColorScheme * lua require('gwm.colors').reload() ]]
  vim.cmd [[ augroup END ]]
end
vim.cmd [[ hi TSVariable guifg='#262626' ]]

Color.new('base0', '#141413')
Color.new('base1', '#262626')
Color.new('base2', '#585858')
Color.new('base3', '#bcbcbc')
Color.new('base4', '#8599a6')
Color.new('base5', '#1e6479')
Color.new('base6', '#bc9e7f')
Color.new('base7', '#d3ebe9')

Color.new('red', '#844a4b')
Color.new('orange', '#d26937')
Color.new('yellow', '#edb443')
Color.new('magenta', '#888ca6')
Color.new('violet', '#4e5166')
Color.new('blue', '#195466')
Color.new('cyan', '#33859E')
Color.new('green', '#2aa889')

Color.new('background', '#141413')
Color.new('linenr_background', '#262626')

Group.new('TSVariable', c.base0)

-- Group.new('Normal', c.base3, c.background)

-- Group.new('Cursor', c.base1, c.base6)
-- Group.new('CursorLine', nil, c.base1)
-- Group.new('CursorColumn', g.CursorLine, g.CursorLine)

-- Group.new('LineNr', c.base2, c.linenr_background)
-- Group.new('CursorLineNr', c.base6, c.linenr_background)
-- Group.new('SignColumn', nil, c.linenr_background)
-- Group.new('ColorColumn', g.SignColumn, g.SignColumn)

-- Group.new('Visual', nil, c.base4)

-- Group.new('Comment', c.base2)
-- Group.new('String', c.base4)
-- Group.new('Number', c.base6)
-- Group.new('Statement', c.yellow)
-- Group.new('Special', c.cyan)
-- Group.new('Delimiter', c.base4)
-- Group.new('Identifier', c.yellow)
-- Group.new('Function', c.red)

-- Group.new('Constant', c.red)

-- Group.new('Underlined', c.yellow, nil, s.underline)

-- Group.new('Type', c.yellow)

-- Group.new('PreProc', c.yellow)

-- Group.new('NonText', c.blue)

-- Group.new('Conceal', c.cyan, c.background)

-- Group.new('Todo', c.base3, c.violet)

-- Group.new('VertSplit', c.blue, c.linenr_background)
-- Group.new('StatusLineNC', c.blue, c.base2)

-- Group.new('MatchParen', c.base6, c.base2)

-- Group.new('SpecialKey', c.base3)

-- Group.new('Folded', c.base6, c.blue)
-- Group.new('FoldColumn', c.base5, c.base1)

-- Group.new('Search', c.base2, c.yellow, s.reverse)

-- Group.new('Pmenu', c.base6, c.base2)
-- Group.new('PmenuSel', c.red, c.blue)
-- Group.new('PmenuSbar', nil, c.base2)
-- Group.new('PmenuThumb', nil, c.blue)

-- Group.new('ErrorMsg', c.red, c.base1)
-- Group.new('Error', c.red, c.base1)
-- Group.new('ModeMsg', c.blue)
-- Group.new('WarningMsg', c.red)

-- Group.new('StatusLine', c.base5, c.base2)
-- Group.new('WildMenu', c.red, c.cyan)

-- Group.new('Question', c.green)

-- Group.new('TabLineSel', c.base0, c.base6)
-- Group.new('TabLine', c.base6, c.base1)
-- Group.new('TabLineFill', c.base0, c.base0)

-- Group.new('DiffAdd', c.base3, c.green)
-- Group.new('DiffChange', c.base3, c.blue)
-- Group.new('DiffDelete', c.base3, c.red)
-- Group.new('DiffText', c.base3, c.cyan)

-- Group.new('Directory', c.cyan)
