local M = {}

local function get_bufname()
  local bufname = vim.fn.expand('%:t')
  if bufname ~= '' then
    return '%#StatusLineBufName#'..bufname..'%*'
  end

  local filetype = vim.bo.filetype
  if filetype ~= '' then
    return '%#StatusLineBufName#'..filetype..'%*'
  end
  return ''
end

local function get_filetype()
  local filetype = vim.bo.filetype
  if filetype and filetype ~= '' then
    return '%#LineFileType#['..filetype..']%*'
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
  local branch = vim.api.nvim_exec('echo fugitive#head()', true)
  if branch ~= '' then
    return branch..' | '
  end
  return ''
end

function M.active_statusline()
  local bufname = get_bufname()
  local filetype = get_filetype()
  local modified = get_modified()
  local readonly = get_readonly()
  local location = get_location()
  local percentage = get_percentage()
  local branch = get_branch()  -- honestly not sure if I want this or not??

  local status = bufname..' '..filetype..' '..modified..readonly..'%='..branch..location..' | '..percentage

  local buffer_not_empty = vim.fn.expand('%:t') ~= '' or vim.bo.filetype ~= ''
  if buffer_not_empty then
    return '  ' .. status .. '  '
  end
  return ' '
end

function M.inactive_statusline()
  return ' '
end

return M
