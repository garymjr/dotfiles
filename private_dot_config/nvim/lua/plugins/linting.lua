return {
	"conform.nvim",
	opts = {
		formatters = {
			biome = {
				args = {
					"format",
					"--semicolons",
					"as-needed",
					"--quote-style",
					"single",
					"--indent-style",
					"space",
					"--line-width",
					"100",
					"--stdin-file-path",
					"$FILENAME",
				},
			},
		},
		formatters_by_ft = {
			typescript = { "biome" },
			typescriptreact = { "biome" },
			javascript = { "biome" },
			json = { "biome" },
		},
	},
}
