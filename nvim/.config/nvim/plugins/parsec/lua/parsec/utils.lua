local function highlight(group, colors)
  local fg = colors.fg or 'NONE'
  local bg = colors.bg or 'NONE'
  local style = colors.style or 'NONE'

  if colors.link then
    vim.cmd(string.format('hi! link %s %s', group, colors.link))
    return
  end

  vim.cmd(string.format('hi %s guifg=%s guibg=%s gui=%s', group, fg, bg, style))
end

return { highlight = highlight }
