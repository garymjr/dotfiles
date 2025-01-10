local _, vscode = pcall(require, "vscode")

---@param mode string|table
---@param lhs string
---@param rhs string|function
---@param opts table|nil
local function map(mode, lhs, rhs, opts)
  local options = { silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

map({ "n", "v" }, "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map({ "n", "v" }, "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map({ "n", "v" }, "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map({ "n", "v" }, "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
map({ "n", "v" }, "gh", "_", { desc = "Go to Home" })
map({ "n", "v" }, "gl", "$", { desc = "Go to End" })

vim.keymap.del("n", "<A-j>")
vim.keymap.del("n", "<A-k>")
vim.keymap.del("i", "<A-j>")
vim.keymap.del("i", "<A-k>")

map("v", "J", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "K", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })


if vim.g.vscode then
  map("n", "<leader>gg", function()
    vscode.call("lazygit.openLazygit")
  end, { desc = "Open LazyGit" })

  map("n", "<leader>ft", function()
    vscode.call("workbench.action.createTerminalEditor")
  end, { desc = "Create Terminal Editor" })

  map("n", "<leader>fb", function()
    vscode.call("workbench.action.quickOpenPreviousRecentlyUsedEditor")
  end, { desc = "Open Previous Editor" })
  
  map("n", "<c-o>", function()
    vscode.call("workbench.action.previousEditorInGroup")
  end, { desc = "Previous Editor in Group" })

  map("n", "<c-i>", function()
    vscode.call("workbench.action.nextEditorInGroup")
  end, { desc = "Next Editor in Group" })
end

