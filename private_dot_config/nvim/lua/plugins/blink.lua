return {
	{
		"saghen/blink.cmp",
		version = "*",
		opts_extend = {
			"sources.completion.enabled_providers",
			"sources.default",
		},
		dependencies = {
			"rafamadriz/friendly-snippets",
		},
		event = "InsertEnter",
		opts = {
			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "mono",
			},
			completion = {
				accept = {
					auto_brackets = {
						enabled = true,
					},
				},
				list = {
					selection = { preselect = false },
				},
				menu = {
					draw = {
						treesitter = { "lsp" },
					},
				},
				documentation = {
					auto_show = true,
					auto_show_delay_ms = 200,
				},
				ghost_text = {
					enabled = false,
				},
			},
			-- cmdline = {
			-- 	sources = {},
			-- },
			sources = {
				default = { "lsp", "path", "snippets", "buffer", "lazydev" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},
			keymap = { preset = "enter" },
		},
	},
	{
		"saghen/blink.compat",
		optional = true,
		opts = {},
		version = "*",
	},
}
