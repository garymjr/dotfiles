local M = {}

local api = vim.api

function M.remap(mode, before, after, opts)
  api.nvim_set_keymap(mode, before, after, opts or {})
end

return M
