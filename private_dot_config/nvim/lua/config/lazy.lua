local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	vim.fn.system { "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath }
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup {
	spec = {
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{ import = "plugins" },
	},
	defaults = {
		lazy = true,
		version = false,
	},
	dev = {
		path = "~/code",
	},
	install = { colorscheme = { "tokyonight", "habamax" } },
	checker = { enabled = true, notify = false },
	change_detection = { enabled = true, notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
}
