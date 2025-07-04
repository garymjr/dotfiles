local map = vim.keymap.set

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

map({ "n", "v" }, "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map({ "n", "v" }, "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map({ "n", "v" }, "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map({ "n", "v" }, "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

map("v", "J", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "K", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

map({ "i", "n", "s" }, "<esc>", function()
  vim.cmd "noh"
  vim.snippet.stop()
  return "<esc>"
end, { expr = true, desc = "Escape and Clear hlsearch" })

map("i", ",", ",<c-g>u", {})
map("i", ".", ".<c-g>u", {})
map("i", ";", ";<c-g>u", {})

map("v", "<", "<gv", {})
map("v", ">", ">gv", {})

map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })

map("n", "<leader>ft", function()
  Snacks.terminal.toggle()
end, { desc = "Toggle terminal" })
map("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "Toggle laygit" })

map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

map("n", "<leader>m", function()
  vim.cmd "tabnew"
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  vim.bo[buf].buftype = "nofile"
  vim.api.nvim_buf_set_name(buf, "Messages")
  vim.api.nvim_set_current_buf(buf)

  vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = buf })

  local messages = vim.fn.execute "messages"
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(messages, "\n"))
  vim.cmd.normal "ggdd"
end, { desc = "Messages" })

map("n", "<leader>bd", function()
  Snacks.bufdelete.delete { buf = 0 }
end, { desc = "Symbols Outline" })
