local M = {}
local api = vim.api

function M.blameVirtText()
  local ft = vim.fn.expand('%:h:t')  -- get the current file extension
  if ft == '' then  -- scratch or unknown buffer
    return
  end
  if ft == 'bin' then  -- nvim terminal window
    return
  end

  api.nvim_buf_clear_namespace(0, 2, 0, -1)

  local currentFile = vim.fn.expand('%')
  local line = api.nvim_win_get_cursor(0)
  local blame = vim.fn.system(string.format('git blame -c -L %d,%d %s', line[1], line[1], currentFile))
  local hash = vim.split(blame, '%s')[1]
  local cmd = string.format('git show %s ', hash)..'--format="%an | %ar | %s"'

  if hash == '0000000000' then  -- line change, but not committed
    text = 'Not Committed Yet'
  else
    text = vim.fn.system(cmd)
    text = vim.split(text, '\n')[1]
    if text:find('fatal') then  -- if call to git fails
      return
    end
  end

  api.nvim_buf_set_virtual_text(0, 2, line[1] - 1, {{ text, 'GitLens' }}, {})  -- set virtual text with output from git command
end

function M.clearBlameVirtText()
  api.nvim_buf_clear_namespace(0, 2, 0, -1)
end

return M
