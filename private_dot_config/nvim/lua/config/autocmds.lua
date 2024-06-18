--- @param name string
local function augroup(name)
	return vim.api.nvim_create_augroup(string.format("gmjr_%s", name), { clear = true })
end

vim.api.nvim_create_autocmd("BufWritePost", {
	group = augroup("clear_snippet_session"),
	callback = function()
		if vim.snippet._session ~= nil then
			vim.snippet.stop()
		end
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup("completion"),
	callback = function(args)
		vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
	end,
})
