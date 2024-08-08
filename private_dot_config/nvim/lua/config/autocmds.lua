--- @param name string
local function augroup(name)
	return vim.api.nvim_create_augroup(string.format("gmjr_%s", name), { clear = true })
end

vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup "clear_snippet_session",
	callback = function()
		if vim.snippet._session ~= nil then
			vim.snippet.stop()
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = augroup "mini_files",
	pattern = "minifiles",
	callback = function(event)
		vim.keymap.set("n", "<cr>", function()
			require("mini.files").go_in { close_on_file = true }
		end, { buffer = event.buf })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql", "mysql", "plsql" },
	callback = function()
		local has_cmp, cmp = pcall(require, "cmp")
		if has_cmp then
			cmp.setup.buffer { sources = { { name = "vim-dadbod-completion" } } }
		end
	end,
})
