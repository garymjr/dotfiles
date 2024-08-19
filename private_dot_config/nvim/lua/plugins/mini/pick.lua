require("mini.deps").later(function()
	require("mini.pick").setup({
		mappings = {
			choose_marked = "<m-q>",
			delete_left = "",
			scroll_down = "<c-d>",
			scroll_up = "<c-u>",
			toggle_info = "<s-tab>",
			toggle_preview = "<tab>",
		},
	})

	vim.keymap.set("n", "<leader>:", "<cmd>Pick history<cr>", { desc = "Command History", silent = true })
	vim.keymap.set("n", "<leader><space>", "<cmd>Pick files<cr>", { desc = "Find Files (Root Dir)", silent = true })
	vim.keymap.set(
		"n",
		"<leader>fb",
		"<cmd>Pick buffers include_current=false<cr>",
		{ desc = "Buffers", silent = true }
	)
	vim.keymap.set("n", "<leader>fc", "<cmd>Pick chezmoi<cr>", { desc = "Find Config File", silent = true })
	vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "Find Files (Root Dir)", silent = true })
	vim.keymap.set("n", "<leader>fF", "<cmd>Pick files<cr>", { desc = "Find Files (cwd)", silent = true })
	vim.keymap.set("n", "<leader>fr", "<cmd>Pick oldfiles<cr>", { desc = "Recent", silent = true })
	vim.keymap.set("n", "<leader>fv", "<cmd>Pick visit_paths<cr>", { desc = "Visits", silent = true })
	vim.keymap.set("n", '<leader>s"', "<cmd>Pick registers<cr>", { desc = "Registers", silent = true })
	vim.keymap.set("n", "<leader>sb", "<cmd>Pick buf_lines<cr>", { desc = "Buffer", silent = true })
	vim.keymap.set("n", "<leader>sc", "<cmd>Pick history<cr>", { desc = "Command History", silent = true })
	vim.keymap.set("n", "<leader>sC", "<cmd>Pick commands<cr>", { desc = "Commands", silent = true })
	vim.keymap.set(
		"n",
		"<leader>sd",
		"<cmd>Pick diagnostic scope='current'<cr>",
		{ desc = "Document Diagnostics", silent = true }
	)
	vim.keymap.set("n", "<leader>sD", "<cmd>Pick diagnostic<cr>", { desc = "Workspace Diagnostics", silent = true })
	vim.keymap.set("n", "<leader>sg", "<cmd>Pick grep_live<cr>", { desc = "Grep (Root Dir)", silent = true })
	-- { "<leader>sG", LazyVim.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
	vim.keymap.set("n", "<leader>sh", "<cmd>Pick help<cr>", { desc = "Help Pages", silent = true })
	vim.keymap.set("n", "<leader>sl", "<cmd>Pick list scope='location'<cr>", { desc = "Location List", silent = true })
	vim.keymap.set("n", "<leader>sm", "<cmd>Pick marks<cr>", { desc = "Jump to Mark", silent = true })
	vim.keymap.set("n", "<leader>sR", "<cmd>Pick resume<cr>", { desc = "Resume", silent = true })
	vim.keymap.set("n", "<leader>sq", "<cmd>Pick list scope='quickfix'<cr>", { desc = "Quickfix List", silent = true })
	vim.keymap.set("n", "<leader>sw", "<cmd>Pick grep<cr>", { desc = "Word", silent = true })

	vim.keymap.set(
		"n",
		"<leader>ss",
		"<cmd>Pick lsp scope='document_symbol'<cr>",
		{ desc = "Goto Symbol", silent = true }
	)
	vim.keymap.set(
		"n",
		"<leader>sS",
		"<cmd>Pick list scope='workspace_symbol'",
		{ desc = "Goto Symbol (Workspace)", silent = true }
	)
end)
