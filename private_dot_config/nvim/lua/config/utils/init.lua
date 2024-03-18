local M = {}

function M.register_plugins(dir)
  if not dir then
    return
  end

  local handle = vim.uv.fs_scandir(dir)
  while handle do
    local name, t = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end

    if t == "directory" then
      M.register_plugins(dir .. "/" .. name)
    end

    if t == "file" and name:match("%.lua") then
      local mod = vim.fn.fnamemodify(dir .. "/" .. name, ":.")
      if mod then
        vim.cmd.source(mod)
      end
    end
  end
end

function M.map(mode, lhs, rhs, opts)
  opts = vim.tbl_deep_extend("force", {}, opts or {}, { silent = true })
  vim.keymap.set(mode, lhs, rhs, opts)
end

Utils = M
