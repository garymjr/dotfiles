if false then
	MiniDeps.add({
		enabled = false,
		source = "catppuccin/nvim",
		name = "catppuccin",
	})

	MiniDeps.now(function()
		require("catppuccin").setup({
			flavour = "macchiato",
			integrations = {
				mason = true,
				markdown = true,
				mini = true,
				native_lsp = {
					enabled = true,
					underlines = {
						errors = { "undercurl" },
						hints = { "undercurl" },
						warnings = { "undercurl" },
						information = { "undercurl" },
					},
				},
				semantic_tokens = true,
				treesitter = true,
				treesitter_context = true,
			},
		})

		vim.cmd.colorscheme("catppuccin")
	end)
end

MiniDeps.add({ source = "olivercederborg/poimandres.nvim" })
MiniDeps.now(function()
	require("poimandres").setup()
	vim.cmd.colorscheme("poimandres")
end)
