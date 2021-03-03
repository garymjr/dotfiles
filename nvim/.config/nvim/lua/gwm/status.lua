local M = {}

M.current_status = function()
  local symbol = ''
  local current_function = vim.b.lsp_current_function
  if current_function and current_function ~= '' then
    local statusline = symbol .. ' (' .. current_function .. ')'
    return statusline
  else
    return ''
  end
end

M.update_status = function()
  local current_function = vim.b.lsp_current_function
  if current_function and current_function ~= '' then
    vim.api.nvim_command('call barow#update()')
  end
end

return M
