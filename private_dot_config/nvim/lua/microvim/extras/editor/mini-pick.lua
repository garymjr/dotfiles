return {
	{ "nvim-telescope/telescope.nvim", enabled = false },
	{
		"echasnovski/mini.pick",
		dependencies = {
			{ "echasnovski/mini.extra", opts = {} },
		},
		cmd = { "Pick" },
		keys = {
			{
				"<leader>,",
				"<cmd>Pick buffers include_current=false<cr>",
				desc = "Switch Buffer",
			},
			{ "<leader>/", "<cmd>Pick grep_live<cr>", desc = "Grep (root dir)" },
			{ "<leader>:", "<cmd>Pick history<cr>", desc = "Command History" },
			{
				"<leader><space>",
				function()
					local root = require("lazyvim.util.root").get()
					if vim.uv.fs_stat(root .. "/.git") then
						require("mini.extra").pickers.git_files(nil, {
							source = {
								cwd = root,
							},
						})
					else
						require("mini.pick").builtin.files(nil, {
							source = {
								cwd = root,
							},
						})
					end
				end,
				desc = "Find Files (root dir)",
			},
			{ "<leader>fb", "<cmd>Pick buffers<cr>", desc = "Buffers" },
			{
				"<leader>fc",
				function()
					require("mini.pick").builtin.files(nil, {
						source = {
							cwd = vim.fn.stdpath("config"),
						},
					})
				end,
				desc = "Find Config File",
			},
			{
				"<leader>ff",
				function()
					local root = require("lazyvim.util.root").get()
					if vim.uv.fs_stat(root .. "/.git") then
						require("mini.extra").pickers.git_files(nil, {
							source = {
								cwd = root,
							},
						})
					else
						require("mini.pick").builtin.files(nil, {
							source = {
								cwd = root,
							},
						})
					end
				end,
				desc = "Find Files (root dir)",
			},
			{
				"<leader>fF",
				function()
					require("mini.pick").builtin.files(nil, {
						source = {
							cwd = vim.uv.cwd(),
						},
					})
				end,
				desc = "Find Files (cwd)",
			},
			{ "<leader>fr", "<cmd>Pick oldfiles<cr>", desc = "Recent" },
			{
				"<leader>fR",
				function()
					require("mini.extra").pickers.oldfiles(nil, {
						source = {
							cwd = vim.uv.cwd(),
						},
					})
				end,
				desc = "Recent (cwd)",
			},
			{ "<leader>gc", "<cmd>Pick git_commits<CR>", desc = "Commits" },
			{ '<leader>s"', "<cmd>Pick registers<cr>", desc = "Registers" },
			{ "<leader>sb", "<cmd>Pick buf_lines<cr>", desc = "Buffer" },
			{ "<leader>sC", "<cmd>Pick commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>Pick diagnostic scope='current'<cr>", desc = "Document diagnostics" },
			{ "<leader>sD", "<cmd>Pick diagnostic scope='all'<cr>", desc = "Workspace diagnostics" },
			{
				"<leader>sg",
				function()
					require("mini.pick").builtin.grep_live(nil, {
						source = {
							cwd = require("lazyvim.util.root").get(),
						},
					})
				end,
				desc = "Grep (root dir)",
			},
			{
				"<leader>sG",
				function()
					require("mini.pick").builtin.grep_live(nil, {
						source = {
							cwd = vim.uv.cwd(),
						},
					})
				end,
				desc = "Grep (cwd)",
			},
			{ "<leader>sh", "<cmd>Pick help<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>Pick hl_groups<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sk", "<cmd>Pick keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sm", "<cmd>Pick marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Pick options<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>Pick resume<cr>", desc = "Resume" },
			{
				"<leader>sw",
				function()
					require("mini.pick").builtin.grep(nil, {
						source = {
							cwd = require("lazyvim.util.root").get(),
						},
					})
				end,
				desc = "Word (root dir)",
			},
			{
				"<leader>sW",
				function()
					require("mini.pick").builtin.grep(nil, {
						source = {
							cwd = vim.uv.cwd(),
						},
					})
				end,
				desc = "Word (cwd)",
			},
			{ "<leader>ss", "<cmd>Pick lsp scope='document_symbol'<cr>", desc = "Goto Symbol" },
			{ "<leader>sS", "<cmd>Pick lsp scope='workspace_symbol'<cr>", desc = "Goto Symbol (Workspace)" },
		},
		opts = function(_, opts)
			local win_config = function()
				local height = math.floor(0.8 * vim.o.lines)
				local width = math.floor(0.8 * vim.o.columns)
				return {
					anchor = "NW",
					height = height,
					width = width,
					row = math.floor(0.5 * (vim.o.lines - height)),
					col = math.floor(0.5 * (vim.o.columns - width)),
				}
			end
			opts.window = { config = win_config }
			opts.mappings = {
				choose_marked = "<M-q>",
				scroll_down = "<C-d>",
				scroll_up = "<C-u>",
				mark = "<C-x>",
			}
		end,
	},
	{
		"neovim/nvim-lspconfig",
		init = function()
			local keys = require("lazyvim.plugins.lsp.keymaps").get()
			keys[#keys + 1] =
				{ "gd", "<cmd>Pick lsp scope='definition'<cr>", desc = "Goto Definition", has = "definition" }
			keys[#keys + 1] = { "gr", "<cmd>Pick lsp scope='references'<cr>", desc = "References" }
			keys[#keys + 1] = { "gI", "<cmd>Pick lsp scope='implementation'<cr>", desc = "Goto Implementation" }
			keys[#keys + 1] = { "gy", "<cmd>Pick lsp scope='type_definition'<cr>", desc = "Goto T[y]pe Definition" }
		end,
	},
	{
		"nvimdev/dashboard-nvim",
		opts = function(_, opts)
			local center = opts.config.center
			center[1].action = "Pick files"
			center[3].action = "Pick oldfiles"
			center[4].action = "Pick grep_live"
			center[5].action =
				[[lua require("mini.pick").builtin.files(nil, { source = { cwd = vim.fn.stdpath("config") } }) ]]
		end,
	},
}
