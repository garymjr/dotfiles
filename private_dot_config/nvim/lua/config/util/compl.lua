vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		vim.lsp.completion.enable(true, event.data.client_id, event.buf, { autotrigger = true })

		vim.keymap.set({ "i" }, "<C-n>", function()
			if vim.fn.pumvisible() ~= 0 then
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-n>", true, false, true), "n", true)
			else
				if next(vim.lsp.get_clients({ bufnr = event.buf })) then
					vim.lsp.completion.trigger()
				else
					if vim.bo.omnifunc == "" then
						vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes("<C-x><C-n>", true, false, true),
							"n",
							true
						)
					else
						vim.api.nvim_feedkeys(
							vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true),
							"n",
							true
						)
					end
				end
			end
		end, { expr = true, buffer = event.buf })

		vim.keymap.set({ "i" }, "<CR>", function()
			if vim.fn.pumvisible() ~= 0 then
				return "<C-y>"
			else
				return "<CR>"
			end
		end, { expr = true, buffer = event.buf })

		vim.keymap.set({ "i" }, "<C-u>", "<C-x><C-n>", { desc = "Buffer completions", buffer = event.buf })

		vim.keymap.set({ "i", "s" }, "<Tab>", function()
			if vim.snippet.active({ direction = 1 }) then
				vim.snippet.jump(1)
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
			end
		end, { expr = true, buffer = event.buf })

		vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
			if vim.snippet.active({ direction = -1 }) then
				vim.snippet.jump(-1)
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<S-Tab>", true, false, true), "n", true)
			end
		end, { expr = true, buffer = event.buf })

		-- Inside a snippet, use backspace to remove the placeholder.
		vim.keymap.set("s", "<BS>", "<C-o>s", { buffer = event.buf })

		vim.api.nvim_create_autocmd("CompleteChanged", {
			buffer = event.buf,
			callback = function()
				local info = vim.fn.complete_info({ "selected" })
				local completion_item = vim.tbl_get(vim.v.completed_item, "user_data", "nvim", "lsp", "completion_item")
				if nil == completion_item then
					return
				end

				local resolved_item = vim.lsp.buf_request_sync(
					event.buf,
					vim.lsp.protocol.Methods.completionItem_resolve,
					completion_item,
					500
				)

				if not resolved_item then
					return
				end

				local docs = vim.tbl_get(resolved_item[event.data.client_id], "result", "documentation", "value")
				if nil == docs then
					return
				end

				local win_data = vim.api.nvim__complete_set(info["selected"], { info = docs })
				if not win_data.winid or not vim.api.nvim_win_is_valid(win_data.winid) then
					return
				end

				vim.api.nvim_win_set_config(win_data.winid, { border = "rounded" })
				vim.treesitter.start(win_data.bufnr, "markdown")
				vim.wo[win_data.winid].conceallevel = 3

				vim.api.nvim_create_autocmd({ "TextChangedI" }, {
					buffer = event.buf,
					callback = function()
						vim.lsp.completion.trigger()
					end,
				})
			end,
		})
	end,
})
