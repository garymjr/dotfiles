local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.uv.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
	vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require("config.options")
require("config.autocmds")
require("config.keymaps")

require("mini.deps").setup({ path = { package = path_package } })

require("plugins.mini")

require("plugins.colorscheme")

require("plugins.dressing")

require("plugins.treesitter")
require("plugins.lspconfig")

require("plugins.chezmoi")
require("plugins.cmp")
require("plugins.codecompanion")
require("plugins.conform")
require("plugins.dadbod")
require("plugins.diffview")
require("plugins.harpoon")
require("plugins.hunk")
require("plugins.lint")
require("plugins.markview")
require("plugins.helpview")
require("plugins.quicker")
require("plugins.smart-splits")
