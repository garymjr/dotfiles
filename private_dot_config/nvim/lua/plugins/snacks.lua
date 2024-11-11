MiniDeps.add({ source = "folke/snacks.nvim" })

MiniDeps.now(function()
	require("snacks").setup({
		notifier = {
			enabled = false,
		},
	})
end)

MiniDeps.later(function()
	local keys = {
		{
			"n",
			"<leader>gg",
			function()
				require("snacks").lazygit()
			end,
		},
	}

	for _, k in pairs(keys) do
		local mode, lhs, rhs = k[1], k[2], k[3]
		local opts = k[4] or {}
		vim.keymap.set(mode, lhs, rhs, opts)
	end
end)

MiniDeps.later(function()
	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesActionRename",
		callback = function(event)
			Snacks.rename.on_rename_file(event.data.from, event.data.to)
		end,
	})
end)
