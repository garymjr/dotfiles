MiniDeps.add("stevearc/quicker.nvim")
MiniDeps.later(function()
	require("quicker").setup()
end)
