MiniDeps.add({
	source = "garymjr/compl.nvim",
	checkout = "fix-snippets",
})

MiniDeps.later(function()
	require("compl").setup()
	vim.keymap.set("i", "<cr>", function()
		if vim.fn.pumvisible() ~= 0 then
			local item_selected = vim.fn.complete_info()["selected"] ~= -1
			return (item_selected and vim.api.nvim_replace_termcodes("<c-y>", true, true, true))
				or vim.api.nvim_replace_termcodes("<c-y><cr>", true, true, true)
		else
			return vim.api.nvim_replace_termcodes("<cr>", true, true, true)
		end
	end, { expr = true })
	vim.keymap.set({ "i", "s" }, "<c-n>", function()
		if vim.fn.pumvisible() ~= 0 then
			return vim.api.nvim_replace_termcodes("<c-n>", true, true, true)
		else
			if next(vim.lsp.get_clients({ bufnr = 0 })) then
				vim.lsp.completion.trigger()
			else
				return vim.api.nvim_replace_termcodes("<c-x><c-n>", true, true, true)
			end
		end
	end, { expr = true })
end)
