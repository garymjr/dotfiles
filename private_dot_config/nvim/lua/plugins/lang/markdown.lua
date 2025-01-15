vim.filetype.add({
	extension = { mdx = "markdown.mdx" },
})

return {
	{
		"conform.nvim",
		optional = true,
		opts = {
			formatters = {
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
					end,
				},
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						local diag = vim.tbl_filter(function(d)
							return d.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))
						return #diag > 0
					end,
				},
			},
			formatters_by_ft = {
				["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
				["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
			},
		},
	},
	{
		"mason.nvim",
		optional = true,
		opts = { ensure_installed = { "markdownlint-cli2", "markdown-toc" } },
	},
	{
		"nvim-lint",
		optional = true,
		opts = {
			linters_by_ft = {
				markdown = { "markdownlint-cli2" },
			},
		},
	},
	{
		"nvim-lspconfig",
		optional = true,
		opts = {
			servers = {
				marksman = {},
			},
		},
	},
	{
		"OXY2DEV/markview.nvim",
		branch = "dev",
		ft = { "markdown", "norg", "rmd", "org" },
		opts = {
			preview = {
				icon_provider = "mini",
			},
		},
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = false,
		opts = {
			code = {
				sign = false,
				width = "block",
				right_pad = 1,
			},
			heading = {
				sign = false,
				icons = {},
			},
		},
		ft = { "markdown", "norg", "rmd", "org" },
		config = function(_, opts)
			require("render-markdown").setup(opts)
			Snacks.toggle({
				name = "Render Markdown",
				get = function()
					return require("render-markdown.state").enabled
				end,
				set = function(enabled)
					local m = require("render-markdown")
					if enabled then
						m.enable()
					else
						m.disable()
					end
				end,
			}):map("<leader>um")
		end,
	},
}
