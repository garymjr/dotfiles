local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	spec = {
		-- add LazyVim and import its plugins
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		{ "lazy.nvim", version = false },
		{ "LazyVim", version = false },
		{ import = "lazyvim.plugins.extras.coding.native_snippets" },
		{ import = "lazyvim.plugins.extras.util.project" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		-- { import = "lazyvim.plugins.extras.linting.eslint" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.lang.go" },
		{ import = "lazyvim.plugins.extras.coding.copilot" },
		-- disable plugins first
		{ import = "gwm.plugins.disabled" },
		-- overrides
		{ import = "gwm.plugins.coding" },
		{ import = "gwm.plugins.colorscheme" },
		{ import = "gwm.plugins.editor" },
		{ import = "gwm.plugins.linting" },
		{ import = "gwm.extras.oil" },
		{ import = "gwm.extras.copilot" },
		{ import = "gwm.extras.diffview" },
		{ import = "gwm.extras.fidget" },
		{ import = "gwm.extras.lsp" },
		{ import = "gwm.extras.dadbod" },
		{ import = "gwm.plugins.treesitter" },
	},
	defaults = {
		lazy = true,
		version = false, -- always use the latest git commit
	},
	dev = {
		path = "~/code",
		fallback = false,
	},
	install = { colorscheme = { "catppuccin" } },
	checker = {
		enabled = true,
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"swapmouse",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
