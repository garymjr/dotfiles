vim.opt.background = "dark"
vim.opt.backup = false
vim.opt.colorcolumn = "80"
vim.opt.complete = {".", "w", "b", "u"}
vim.opt.completeopt = {"menu", "menuone", "noselect"}
vim.opt.expandtab = true
vim.opt.fileformats = "unix"
vim.opt.grepprg = "rg --vimgrep --no-heading --smart-case"
vim.opt.guicursor = ""
vim.opt.hidden = true
vim.opt.hlsearch = false
vim.opt.ignorecase = true
vim.opt.inccommand = "nosplit"
vim.opt.laststatus = 2
vim.opt.modeline = false
vim.opt.mouse = "nv"
vim.opt.mousemodel = "extend"
vim.opt.number = true
vim.opt.path = vim.opt.path + {"**"}
vim.opt.relativenumber = true
vim.opt.scrolloff = 3
vim.opt.sessionoptions:remove("folds")
vim.opt.sessionoptions:append("localoptions")
vim.opt.shiftwidth = 4
vim.opt.shortmess = vim.opt.shortmess + "A" + "I" + "W" + "a" + "c"
vim.opt.showcmd = false
vim.opt.showmode = true
vim.opt.sidescrolloff = 3
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.swapfile = false
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.ttimeoutlen = 0
vim.opt.updatetime = 1000
vim.opt.undofile = true
vim.opt.wildignore = {
  "*/tmp/*",
  "*.so",
  "*.swp",
  "*.zip",
  "*.pyc",
  "*.db",
  "*.sqlite",
  "*.o",
  "*.obj",
  ".git",
  "*.rbc",
  "__pycache__",
  "node_modules/**",
  "**/node_modules/**"
}
vim.opt.wildmode = "longest:full"
vim.opt.wildoptions = "pum"
vim.opt.wrap = false

vim.g.mapleader = " "
