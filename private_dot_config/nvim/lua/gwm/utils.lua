local M = {}

function M.source_plugins(root_dir)
  local handle = vim.uv.fs_scandir(root_dir)
  while handle do
    local name, t = vim.uv.fs_scandir_next(handle)
    if name == nil then
      return
    end

    if t == "directory" then
      M.source_plugins(string.format("%s/%s", root_dir, name))
    end

    if t == "file" and name:match("%.lua$") then
      vim.cmd.source(string.format("%s/%s", root_dir, name))
    end
  end
end

return M
