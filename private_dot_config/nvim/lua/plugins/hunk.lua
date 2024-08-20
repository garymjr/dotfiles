MiniDeps.add({
	source = "julienvincent/hunk.nvim",
	depends = { "MunifTanjim/nui.nvim" },
})

MiniDeps.later(function()
	require("hunk").setup()
end)
