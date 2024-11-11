if false then
	MiniDeps.later(function()
		require("mini.cursorword").setup()

		local hl = vim.api.nvim_get_hl(0, { name = "SnippetTabstop" })
		if hl.link then
			hl = vim.api.nvim_get_hl(0, { name = hl.link })
		end

		vim.api.nvim_set_hl(0, "MiniCursorword", { bg = hl.bg })
		vim.api.nvim_set_hl(0, "MiniCursorwordCurrent", { bg = hl.bg })
	end)
end
