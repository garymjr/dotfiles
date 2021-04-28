local M = {}

local api = vim.api

function M.remap(mode, before, after, opts)
  api.nvim_set_keymap(mode, before, after, opts or {})
end

function M.create_autogroup(config)
  local group_name = config.group_name
  local definition = config.definition
  vim.cmd('augroup ' .. group_name)
  vim.cmd [[autocmd!]]
  for _, def in ipairs(definition) do
    local command = table.concat(vim.tbl_flatten { 'autocmd ', def }, ' ')
    vim.cmd(command)
  end
  vim.cmd [[augroup END]]
end

function M.highlight(group, colors)
  local fg = colors.fg and 'guifg='..colors.fg or 'guifg=NONE'
  local bg = colors.bg and 'guibg='..colors.bg or 'guibg=NONE'
  local gui = colors.style and 'gui='..colors.style or 'gui=NONE'
  local sp = colors.sp and ' guisp='..colors.sp or ''

  if colors.link then
    vim.cmd(string.format('hi! link %s %s', group, colors.link))
    return
  end

  vim.cmd(string.format('hi %s %s %s %s%s', group, bg, fg, gui, sp))
end

function M.get_highlight_group()
  local group = api.nvim_exec([[ echo synIDattr(synID(line('.'), col('.'), 1), 'name') ]], true)
  local base_group = api.nvim_exec([[ echo synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name') ]], true)

  local content = {'Group: ' .. group, 'BaseGroup: ' .. base_group}
  local opts = {
    relative = 'cursor',
    width = 25,
    height = 2,
    style = 'minimal',
    col = 0,
    row = 1
  }

  local bufnr = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(bufnr, 0, -1, true, content)
  api.nvim_buf_set_option(bufnr, 'modifiable', false)
  api.nvim_buf_set_option(bufnr, 'bufhidden', 'wipe')
  api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
  api.nvim_open_win(bufnr, true, opts)
end

function M.set_option(key, value)
  local scope = api.nvim_get_option_info(key).scope
  if type(value) == 'table' then
    value = table.concat(value, ',')
  end

  if scope == 'win' then
    vim.wo[key] = value
  elseif scope == 'buf' then
    vim.bo[key] = value
  end
  vim.o[key] = value
end

function M.extract_colors(groups)
  local colors = {}

  local highlights = vim.api.nvim__get_hl_defs(0)
  for _, group in ipairs(groups) do
    colors[group] = {}
    if highlights[group].foreground then
      colors[group].fg = string.format('#%06x', highlights[group].foreground)
    end

    if highlights[group].background then
      colors[group].bg = string.format('#%06x', highlights[group].background)
    end
  end
  return colors
end

function M.yarn_helper(...)
  local args = {...}
  local cmd = string.format('term yarn %s', table.concat(args, ' '))
  vim.cmd(cmd)
end

vim.cmd [[command! -nargs=+ Yarn lua require('core.utils').yarn_helper(<f-args>)]]

function M.yarn_workspace_helper(...)
  local args = {...}
  local cmd = string.format('term yarn workspace %s', table.concat(args, ' '))
  vim.cmd(cmd)
end

vim.cmd [[command! -nargs=+ Workspace lua require('core.utils').yarn_workspace_helper(<f-args>)]]

function M.docker_helper(...)
  local args = {...}
  local cmd = string.format('term docker %s', table.concat(args, ' '))
  vim.cmd(cmd)
end

vim.cmd [[command! -nargs=+ Docker lua require('core.utils').docker_helper(<f-args>)]]

return M
