local M = {}

--- @param opts {buffer: number, client: vim.lsp.Client}
function M.setup(opts)
  if opts.client.name ~= "elixirls" then
    return
  end

	vim.keymap.set("n", "<leader>cp", function()
		local position_params = vim.lsp.util.make_position_params()
		local params = {
			command = "manipulatePipes:serverid",
			arguments = {
				"toPipe",
				position_params.textDocument.uri,
				position_params.position.line,
				position_params.position.character,
			},
		}

		vim.lsp.buf_request(0, "workspace/executeCommand", params)
	end, { desc = "To Pipe", buffer = opts.buffer })

	vim.keymap.set("n", "<leader>cP", function()
		local position_params = vim.lsp.util.make_position_params()
		local params = {
			command = "manipulatePipes:serverid",
			arguments = {
				"fromPipe",
				position_params.textDocument.uri,
				position_params.position.line,
				position_params.position.character,
			},
		}

		vim.lsp.buf_request(0, "workspace/executeCommand", params)
	end, { desc = "From Pipe", buffer = opts.buffer })
end

return M
