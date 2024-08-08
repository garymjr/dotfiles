-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- easier copying
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to Clipboard" })

-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- better start/end line
vim.keymap.set("n", "gh", "_", { silent = true, desc = "Beginning of line" })
vim.keymap.set("n", "gl", "$", { silent = true, desc = "End of line" })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<A-j>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
vim.keymap.set("n", "<A-k>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
vim.keymap.set("n", "<A-l>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
vim.keymap.set("n", "<A-h>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move Up" })

-- buffers
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
vim.keymap.set("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
vim.keymap.set("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Clear search with <esc>
vim.keymap.set({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
vim.keymap.set(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- Add undo break-points
vim.keymap.set("i", ",", ",<c-g>u")
vim.keymap.set("i", ".", ".<c-g>u")
vim.keymap.set("i", ";", ";<c-g>u")

--keywordprg
vim.keymap.set("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- commenting
vim.keymap.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
vim.keymap.set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- new file
vim.keymap.set("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

vim.keymap.set("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = vim.diagnostic.jump
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity, float = true, count = next and 1 or -1 })
  end
end
vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- quit
vim.keymap.set("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- highlights under cursor
vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
vim.keymap.set("n", "<leader>uI", "<cmd>InspectTree<cr>", { desc = "Inspect Tree" })

-- Terminal Mappings
-- TODO: decide if I want to support terminal
-- map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
-- map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to Left Window" })
-- map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to Lower Window" })
-- map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to Upper Window" })
-- map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to Right Window" })
-- map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
-- map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
vim.keymap.set("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- tabs
vim.keymap.set("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
vim.keymap.set("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
vim.keymap.set("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
vim.keymap.set("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- mini.files
vim.keymap.set("n", "<leader>fm", function()
  require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
end, { desc = "Open mini.files (Directory of Current File)" })

vim.keymap.set("n", "<leader>fM", function()
  require("mini.files").open(vim.uv.cwd(), true)
end, { desc = "Open mini.files (cwd)" })

-- conform.nvim
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  require("conform").format({ buffer = 0 })
end, { desc = "Format" })

-- mini.pick
vim.keymap.set("n", "<leader>fb", "<cmd>Pick buffers include_current=false<cr>", { desc = "Buffers" })
vim.keymap.set("n", "<leader>fc", "<cmd>Pick chezmoi<cr>", { desc = "Find Config File" })
vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Pick git_files<cr>", { desc = "Find Files (git-files)" })
vim.keymap.set("n", "<leader>fr", "<cmd>Pick oldfiles<cr>", { desc = "Recent" })
vim.keymap.set("n", '<leader>s"', "<cmd>Pick registers<cr>", { desc = "Registers" })
vim.keymap.set("n", "<leader>sb", "<cmd>Pick buf_lines<cr>", { desc = "Buffer" })
vim.keymap.set("n", "<leader>sd", "<cmd>Pick diagnostic scope='current'<cr>", { desc = "Document Diagnostics" })
vim.keymap.set("n", "<leader>sD", "<cmd>Pick diagnostic scope='all'<cr>", { desc = "Workspace Diagnostics" })
vim.keymap.set("n", "<leader>sg", "<cmd>Pick grep_live<cr>", { desc = "Grep" })
vim.keymap.set("n", "<leader>sh", "<cmd>Pick help<cr>", { desc = "Help" })
vim.keymap.set("n", "<leader>sl", "<cmd>Pick list scope='location'<cr>", { desc = "Location List" })
vim.keymap.set("n", "<leader>sR", "<cmd>Pick resume<cr>", { desc = "Resume" })
vim.keymap.set("n", "<leader>sq", "<cmd>Pick list scope='quickfix'<cr>", { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>ss", "<cmd>Pick lsp scope='document_symbol'<cr>", { desc = "Goto Symbol" })
vim.keymap.set("n", "<leader>ss", "<cmd>Pick lsp scope='workspace_symbol'<cr>", { desc = "Goto Symbol (Workspace)" })

-- dadbod
vim.keymap.set("n", "<leader>db", "<cmd>DBUIToggle<cr>", { desc = "DadBod", silent = true })

-- navigator
vim.keymap.set({ "n", "t" }, "<c-h>", "<cmd>NavigatorLeft<cr>", { silent = true })
vim.keymap.set({ "n", "t" }, "<c-j>", "<cmd>NavigatorDown<cr>", { silent = true })
vim.keymap.set({ "n", "t" }, "<c-k>", "<cmd>NavigatorUp<cr>", { silent = true })
vim.keymap.set({ "n", "t" }, "<c-l>", "<cmd>NavigatorLeft<cr>", { silent = true })
