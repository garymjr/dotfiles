local M = {}

M.create_highlight = function(group_name, hl_pairs)
  local options = {}
  for k, v in pairs(hl_pairs) do
    table.insert(options, string.format('%s=%s', k, v))
  end
  vim.cmd(string.format('hi %s ', group_name)..table.concat(options, ' '))
end

M.create_highlight_link = function(group_name, link_to, force)
  vim.cmd(string.format('hi%s link %s %s', force and '!' or '', group_name, link_to))
end

return M
