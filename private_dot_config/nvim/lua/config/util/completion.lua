local Util = require("config.util")

local M = {}

--- @param opts {buffer: number, client: vim.lsp.Client, group: number}
function M.setup(opts)
	local client = opts.client
	local buffer = opts.buffer
  local group = opts.group

	if client.supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
		vim.lsp.completion.enable(true, client.id, buffer, { autotrigger = true })

		-- I'm not sure I like this? But I'm going to leave it for now
		vim.api.nvim_create_autocmd({ "InsertCharPre" }, {
			group = group,
			buffer = buffer,
			callback = function()
				vim.lsp.completion.trigger()
			end,
		})

		vim.api.nvim_create_autocmd("CompleteChanged", {
      group = group,
			buffer = buffer,
			callback = function()
				local info = vim.fn.complete_info({ "selected" })
				local completionItem = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
				if completionItem == nil then
					return
				end

				client.request(vim.lsp.protocol.Methods.completionItem_resolve, completionItem, function(_, result)
					if  result == nil or result.documentation == nil then
						return
					end

					local winData = vim.api.nvim__complete_set(info["selected"], { info = result.documentation.value })

					if not vim.api.nvim_win_is_valid(winData.winid) then
						return
					end

					vim.api.nvim_win_set_config(winData.winid, {})
					vim.treesitter.start(winData.bufnr, "markdown")
					vim.wo[winData.winid].conceallevel = 3
				end, buffer)
			end,
		})

		-- Use enter to accept completions.
		vim.keymap.set("i", "<cr>", function()
			return Util.pumvisible() and "<C-y>" or "<cr>"
		end, { expr = true })

		-- Use slash to dismiss the completion menu.
		vim.keymap.set("i", "/", function()
			return Util.pumvisible() and "<C-e>" or "/"
		end, { expr = true })

		-- Use <C-n> to navigate to the next completion or:
		-- - Trigger LSP completion.
		-- - If there's no one, fallback to vanilla omnifunc.
		vim.keymap.set("i", "<C-n>", function()
			if Util.pumvisible() then
				Util.feedkeys("<C-n>")
			else
				if next(vim.lsp.get_clients({ bufnr = 0 })) then
					vim.lsp.completion.trigger()
				else
					if vim.bo.omnifunc == "" then
						Util.feedkeys("<C-x><C-n>")
					else
						Util.feedkeys("<C-x><C-o>")
					end
				end
			end
		end, { desc = "Trigger/select next completion" })

		-- Buffer completions.
		vim.keymap.set("i", "<C-u>", "<C-x><C-n>", { desc = "Buffer completions" })

		-- Use <Tab> to accept a Copilot suggestion, navigate between snippet tabstops,
		-- or select the next completion.
		-- Do something similar with <S-Tab>.
		vim.keymap.set({ "i", "s" }, "<Tab>", function()
			if vim.snippet.active({ direction = 1 }) then
				vim.snippet.jump(1)
			else
				Util.feedkeys("<Tab>")
			end
		end, { expr = true })

		vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
			if vim.snippet.active({ direction = -1 }) then
				vim.snippet.jump(-1)
			else
				Util.feedkeys("<S-Tab>")
			end
		end, { expr = true })

		-- Inside a snippet, use backspace to remove the placeholder.
		vim.keymap.set("s", "<BS>", "<C-o>s")
	end
end

return M
