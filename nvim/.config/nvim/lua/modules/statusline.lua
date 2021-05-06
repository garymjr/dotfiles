local create_autogroup = require('core.utils').create_autogroup

local function get_bufname()
  local head = ''
  -- if vim.bo.buftype == '' then
  --   head = vim.fn.expand('%:p:h')
  --   head = head:gsub(os.getenv('HOME'), '~')
  --   local head_parts = vim.split(head, '/')
  --   head = ''
  --   for _, part in ipairs(head_parts) do
  --     local piece = string.sub(part, 1, 1)
  --     if piece == '.' then
  --       piece = string.sub(part, 1, 2)
  --     end
  --     head = head .. piece .. '/'
  --   end
  -- end
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
  if vim.bo.buftype == '' then
    local dir = vim.fn.expand('%:p:h')
    local cmd = string.format([[echo fugitive#Head('%s')]], dir)
    local branch = vim.api.nvim_exec(cmd, true)
    if branch and branch ~= '' then
      return string.format('%s | ', branch)
    end
  end
  return ''
end

local function active_statusline()
  local async
  async = vim.loop.new_async(vim.schedule_wrap(function()
    local bufname = get_bufname()
    local filetype = get_filetype()
    local modified = get_modified()
    local readonly = get_readonly()
    local branch = get_branch()
    local location = get_location()
    local percentage = get_percentage()

    local buffer_not_empty = vim.fn.expand('%:t') ~= '' or vim.bo.filetype ~= ''
    if buffer_not_empty then
      local status = ' '..bufname..filetype..modified..readonly..'%=%<'..branch..location..' '..percentage..' '
      vim.wo.statusline = status
    else
      vim.wo.statusline = ' '
    end
    async:close()
  end))
  async:send()
end

local function inactive_statusline()
  vim.wo.statusline = ' '
end

local function setup()
  create_autogroup {
    group_name = 'StatusLine',
    definition = {
      {'BufEnter,WinEnter,BufReadPost,BufWritePost,VimResized,TermOpen,InsertLeave', '*', [[lua require('modules.statusline').active_statusline()]]},
      {'WinLeave', '*', [[lua require('modules.statusline').inactive_statusline()]]}
    }
  }
end

return {
  active_statusline = active_statusline,
  inactive_statusline = inactive_statusline,
  setup = setup
}
