local get_icon = require('plugins.devicons').get_icon
local hi = require('core.utils').hilite

local M = {}

local function get_bufname()
  local head = ''
  if vim.bo.buftype == '' then
    head = vim.fn.expand('%:p:h')
    head = head:gsub(os.getenv('HOME'), '~')
    local head_parts = vim.split(head, '/')
    head = ''
    for _, part in ipairs(head_parts) do
      local piece = string.sub(part, 1, 1)
      if piece == '.' then
        piece = string.sub(part, 1, 2)
      end
      head = head .. piece .. '/'
    end
  end
  local bufname = vim.fn.expand('%:t')
  if bufname ~= '' then
    return '%#StatusLineBufName#'..head..bufname..'%*'
  end

  local filetype = vim.bo.filetype
  if filetype ~= '' then
    return '%#StatusLineBufName#'..filetype..'%*'
  end
  return ''
end

local function get_modified()
  local modified = vim.bo.modifiable and vim.bo.modified
  if modified then
    return '%#LineModified# %*'
  end
  return ''
end

local function get_readonly()
  local readonly = vim.bo.readonly
  if readonly then
    return '%#LineReadOnly# %*'
  end
  return ''
end

local function get_location()
  return '%l:%c'
end

local function get_percentage()
  return '%p%%'
end

local function get_branch()
  local status_dict = vim.b.gitsigns_status_dict or {}

  local branch = status_dict.head
  if branch ~= nil and #branch > 0 then
    return branch..' | '
  end
  return ''
end

local function get_file_icon()
  local filename = vim.fn.expand('%:t')
  local ext = vim.fn.expand('%:e')
  local icon = get_icon(filename, ext)

  hi('LineIcon', { fg = icon.color, bg = '#1F2329' })
  return '%#LineIcon#'..icon.icon..'  %*'
end

function M.active_statusline()
  local bufname = get_bufname()
  local modified = get_modified()
  local readonly = get_readonly()
  local location = get_location()
  local percentage = get_percentage()
  local branch = get_branch()  -- honestly not sure if I want this or not??
  local icon = get_file_icon()

  local status = icon..bufname..' '..modified..readonly..'%='..branch..location..' | '..percentage

  local buffer_not_empty = vim.fn.expand('%:t') ~= '' or vim.bo.filetype ~= ''
  if buffer_not_empty then
    return '  '..status .. '  '
  end
  return ' '
end

function M.inactive_statusline()
  return ' '
end

return M
