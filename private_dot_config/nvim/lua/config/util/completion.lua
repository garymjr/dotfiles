local Util = require("config.util")

local M = {}

-- Constants for commonly used values
local LSP = vim.lsp.protocol.Methods
local api = vim.api

-- Cache frequently accessed functions
local pumvisible = Util.pumvisible
local feedkeys = Util.feedkeys

--- @param opts {buffer: number, client: vim.lsp.Client}
function M.setup(opts)
	local client, buffer = opts.client, opts.buffer

	if not client.supports_method(LSP.textDocument_completion) then
		return
	end

	-- Enable LSP completion
	vim.lsp.completion.enable(true, client.id, buffer, { autotrigger = true })

	-- Handle completion documentation
	local function setup_preview_window(winid, bufnr)
		if api.nvim_win_is_valid(winid) then
			api.nvim_win_set_config(winid, {})
			vim.treesitter.start(bufnr, "markdown")
			vim.wo[winid].conceallevel = 3
		end
	end

	-- CompleteChanged autocmd for documentation
	api.nvim_create_autocmd("CompleteChanged", {
		group = api.nvim_create_augroup("minivim_complete_changed", { clear = true }),
		buffer = buffer,
		callback = function()
			local info = vim.fn.complete_info({ "selected" })
			local completionItem = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")

			if not completionItem then
				return
			end

			client.request(LSP.completionItem_resolve, completionItem, function(_, result)
				if not result or not result.documentation then
					setup_preview_window(info.preview_winid, info.preview_bufnr)
					return
				end

				local winData = api.nvim__complete_set(info["selected"], { info = result.documentation.value })
				setup_preview_window(winData.winid, winData.bufnr)
			end, buffer)
		end,
	})

	-- Keymaps for completion interaction
	local keymaps = {
		-- Accept completion with Enter
		{
			mode = "i",
			lhs = "<cr>",
			rhs = function()
				return pumvisible() and "<C-y>" or "<cr>"
			end,
			opts = { expr = true },
		},

		-- Dismiss completion menu with slash
		{
			mode = "i",
			lhs = "/",
			rhs = function()
				return pumvisible() and "<C-e>" or "/"
			end,
			opts = { expr = true },
		},

		-- Smart completion navigation with C-n
		{
			mode = "i",
			lhs = "<C-n>",
			rhs = function()
				if pumvisible() then
					feedkeys("<C-n>")
				else
					if next(vim.lsp.get_clients({ bufnr = buffer })) then
						vim.lsp.completion.trigger()
					else
						feedkeys(vim.bo.omnifunc == "" and "<C-x><C-n>" or "<C-x><C-o>")
					end
				end
			end,
			opts = { desc = "Trigger/select next completion" },
		},

		-- Buffer completions
		{ mode = "i", lhs = "<C-u>", rhs = "<C-x><C-n>", opts = { desc = "Buffer completions" } },

		-- Snippet navigation
		{
			mode = { "i", "s" },
			lhs = "<Tab>",
			rhs = function()
				if vim.snippet.active({ direction = 1 }) then
					vim.snippet.jump(1)
				else
					feedkeys("<Tab>")
				end
			end,
			opts = { expr = true },
		},

		{
			mode = { "i", "s" },
			lhs = "<S-Tab>",
			rhs = function()
				if vim.snippet.active({ direction = -1 }) then
					vim.snippet.jump(-1)
				else
					feedkeys("<S-Tab>")
				end
			end,
			opts = { expr = true },
		},

		-- Snippet placeholder removal
		{ mode = "s", lhs = "<BS>", rhs = "<C-o>s" },
	}

	-- Apply all keymaps
	for _, map in ipairs(keymaps) do
		vim.keymap.set(map.mode, map.lhs, map.rhs, map.opts)
	end
end

return M
