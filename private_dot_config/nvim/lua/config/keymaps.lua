-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local keymaps = {
  { "gh", "_", silent = true, mode = { "n", "v" } },
  { "gl", "$", silent = true, mode = { "n", "v" } },
  { "J", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", mode = "v" },
  { "K", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", mode = "v" },
}

local function set_keymaps(keys)
  for _, keymap in ipairs(keys) do
    local mode = keymap.mode or "n"
    local lhs = keymap[1]
    local rhs = keymap[2]
    local opts = {}
    for k, v in pairs(keymap) do
      if type(k) == "string" and k ~= "mode" then
        opts[k] = v
      end
    end
    opts.silent = opts.silent ~= false
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

vim.keymap.del("n", "<A-j>")
vim.keymap.del("n", "<A-k>")
vim.keymap.del("i", "<A-j>")
vim.keymap.del("i", "<A-k>")
vim.keymap.del("v", "<A-j>")
vim.keymap.del("v", "<A-k>")

set_keymaps(keymaps)
