local function highlight(group, colors)
  local fg = colors.fg and 'guifg='..colors.fg or 'guifg=NONE'
  local bg = colors.bg and 'guibg='..colors.bg or 'guibg=NONE'
  local gui = colors.gui and 'gui='..colors.gui or 'gui=NONE'
  local sp = colors.sp and ' guisp='..colors.sp or ''

  if colors.link then
    vim.cmd(string.format('hi! link %s %s', group, colors.link))
    return
  end

  vim.cmd(string.format('hi %s %s %s %s%s', group, bg, fg, gui, sp))
end

local function setup_terminal()
  vim.g.terminal_color_0 = '#202a31'
  vim.g.terminal_color_1 = '#c17b8d'
  vim.g.terminal_color_2 = '#7d9761'
  vim.g.terminal_color_3 = '#b28761'
  vim.g.terminal_color_4 = '#5496bd'
  vim.g.terminal_color_5 = '#9b85bb'
  vim.g.terminal_color_6 = '#459d90'
  vim.g.terminal_color_7 = '#abb0c0'
  vim.g.terminal_color_8 = '#898f9e'
  vim.g.terminal_color_9 = '#c17b8d'
  vim.g.terminal_color_10 = '#7d9761'
  vim.g.terminal_color_11 = '#b28761'
  vim.g.terminal_color_12 = '#5496bd'
  vim.g.terminal_color_13 = '#9b85bb'
  vim.g.terminal_color_14 = '#459d90'
  vim.g.terminal_color_15 = '#c5cbdb'
end

return {
  highlight = highlight,
  setup_terminal = setup_terminal
}
