local M = {}

-- used to store terminal buffers
local terminals = {}

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

function M.create_term_buf(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    relative = "editor",
  }, opts or {})

  vim.cmd.tabnew()
  vim.fn.termopen(cmd)
  local buffer = vim.api.nvim_get_current_buf()
  vim.bo[buffer].buflisted = false
  vim.bo[buffer].ft = "gwmterm"
  local win = vim.api.nvim_get_current_win()
  vim.wo[win].number = false
  vim.wo[win].relativenumber = false
  vim.cmd.startinsert()

  return {
    buf = buffer,
    win = win,
  }
end

function M.float_term(cmd, opts)
  opts = vim.tbl_deep_extend("force", {
    width = 0.9,
    height = 0.9,
  }, opts or {})

  local termkey = vim.inspect({ cmd = cmd, cwd = opts.cwd, env = opts.env, count = vim.v.count1 })

  if terminals[termkey] and vim.api.nvim_buf_is_valid(terminals[termkey].buf) then
    terminals[termkey]:toggle()
  else
    terminals[termkey] = require("gwm.utils").create_term_buf(cmd, opts)
    local buf = terminals[termkey].buf
    if opts.esc_esc == false then
      vim.keymap.set("t", "<esc>", "<esc>", { buffer = buf, nowait = true })
    end
    if opts.ctrl_hjkl == false then
      vim.keymap.set("t", "<c-h>", "<c-h>", { buffer = buf, nowait = true })
      vim.keymap.set("t", "<c-j>", "<c-j>", { buffer = buf, nowait = true })
      vim.keymap.set("t", "<c-k>", "<c-k>", { buffer = buf, nowait = true })
      vim.keymap.set("t", "<c-l>", "<c-l>", { buffer = buf, nowait = true })
    end

    vim.api.nvim_create_autocmd("BufEnter", {
      buffer = buf,
      callback = function()
        vim.cmd.startinsert()
      end,
    })
  end

  return terminals[termkey]
end

return M
