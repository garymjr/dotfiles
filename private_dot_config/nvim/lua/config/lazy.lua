local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
	spec = {
		-- add LazyVim and import its plugins
		{ "LazyVim/LazyVim", import = "lazyvim.plugins" },
		-- { import = "lazyvim.plugins.extras.coding.copilot" },
		-- { import = "lazyvim.plugins.extras.util.project" },
		{ import = "lazyvim.plugins.extras.coding.native_snippets" },
		-- { import = "lazyvim.plugins.extras.linting.eslint" },
		{ import = "lazyvim.plugins.extras.lang.typescript" },
		{ import = "lazyvim.plugins.extras.lang.json" },
		{ import = "lazyvim.plugins.extras.lang.go" },
		-- { import = "microvim.plugins.lsp" },
		-- { import = "microvim.extras.editor.mini-pick" },
		{ import = "microvim.extras.util.mini-visits" },
		-- { import = "microvim.extras.ui.mini-clue" },
		-- { import = "microvim.extras.coding.mini-completion" },
		{ import = "gwm.extras.neogit" },
		{ import = "gwm.extras.oil" },
		-- { import = "gwm.extras.copilot" },
		-- { import = "gwm.extras.chatgpt" },
		{ import = "gwm.extras.diffview" },
		-- import/override with your plugins
		{ import = "plugins" },
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		lazy = false,
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = false, -- always use the latest git commit
		-- version = "*", -- try installing the latest stable version for plugins that support semver
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
			-- disable some rtp plugins
			disabled_plugins = {
				"gzip",
				-- "matchit",
				-- "matchparen",
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

vim.api.nvim_create_autocmd("User", {
	group = group,
	pattern = "VeryLazy",
	callback = function()
		require("config.autocmds")
		require("config.keymaps")

		-- Util.format.setup()
		-- Util.news.setup()
		-- Util.root.setup()
	end,
})
