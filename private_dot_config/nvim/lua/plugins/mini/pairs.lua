require("mini.deps").later(function()
	require("mini.pairs").setup({
		modes = { insert = true, command = true, terminal = false },
		mappings = {
			['"'] = { action = "closeopen", pair = '""', neigh_pattern = '[^\\"].', register = { cr = false } },
		},
	})
end)
