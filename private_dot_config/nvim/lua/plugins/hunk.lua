require("mini.deps").add({
	source = "julienvincent/hunk.nvim",
	depends = { "MunifTanjim/nui.nvim" },
})

require("mini.deps").later(function()
	require("hunk").setup()
end)
