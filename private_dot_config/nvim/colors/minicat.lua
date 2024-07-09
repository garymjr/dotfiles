vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("gwm_minicat", { clear = true }),
	pattern = "minicat",
	callback = function() vim.api.nvim_set_hl(0, "StatusLine", { fg = "#cdd6f4", bg = "#1e1e2e" }) end,
})

require("mini.hues").setup {
	background = "#1e1e2e",
	foreground = "#cdd6f4",
	accent = "purple",
	plugins = {
		default = true,
	},
}
