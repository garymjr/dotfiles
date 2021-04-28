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
    return head..bufname
  end

  local filetype = vim.bo.filetype
  if filetype ~= '' then
    return filetype
  end
  return ''
end

local function get_modified()
  local modified = vim.bo.modifiable and vim.bo.modified
  if modified then
    return ' '
  end
  return ''
end

local function get_readonly()
  local readonly = vim.bo.readonly
  if readonly then
    return ' '
  end
  return ''
end

local function get_location()
  return '%l:%c'
end

local function get_percentage()
  return '%p%%'
end

local function get_filetype()
  local ft = vim.bo.ft
  local bt = vim.bo.buftype
  if ft and ft ~= '' then
    return ' ['..ft..']'
  elseif bt and bt ~= '' then
    return ' ['..bt..']'
  end
  return ''
end

local function get_branch()
  local branch = vim.api.nvim_exec('echo fugitive#Head()', true)
  if branch then
    return string.format('%s | ', branch)
  end
  return ''
end

function M.active_statusline()
  local bufname = get_bufname()
  local modified = get_modified()
  local readonly = get_readonly()
  local location = get_location()
  local percentage = get_percentage()
  local filetype = get_filetype()
  local branch = get_branch()

  local status = bufname..filetype..' '..modified..readonly..'%=%<'..branch..location..' | '..percentage

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
