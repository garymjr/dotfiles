local M = {}

--- @param keys string
function M.feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "n", true)
end

--- @return boolean
function M.pumvisible()
  return tonumber(vim.fn.pumvisible()) ~= 0
end

return M
