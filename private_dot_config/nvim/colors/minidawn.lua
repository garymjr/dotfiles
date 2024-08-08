vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("gwm_minicat", { clear = true }),
	pattern = "minicat",
	callback = function() vim.api.nvim_set_hl(0, "StatusLine", { fg = "#575279", bg = "#faf4ed" }) end,
})

vim.opt.background = "light"
require("mini.hues").setup {
	background = "#faf4ed",
	foreground = "#575279",
	plugins = {
		default = true,
	},
}
