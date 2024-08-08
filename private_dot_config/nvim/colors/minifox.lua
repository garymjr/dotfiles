vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("gwm_minicat", { clear = true }),
	pattern = "minicat",
	callback = function() vim.api.nvim_set_hl(0, "StatusLine", { fg = "#cdcecf", bg = "#192330" }) end,
})

vim.opt.background = "dark"
require("mini.hues").setup {
	background = "#192330",
	foreground = "#cdcecf",
	plugins = {
		default = true,
	},
}
