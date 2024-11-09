local M = {}

local MANIPULATE_PIPES_COMMAND = "manipulatePipes:serverid"

--- @param opts {buffer: number, client: vim.lsp.Client}
function M.setup(opts)
	if opts.client.name ~= "elixirls" then
		return
	end

	local function manipulate_pipe(operation)
		local position_params = vim.lsp.util.make_position_params()
		local params = {
			command = MANIPULATE_PIPES_COMMAND,
			arguments = {
				operation,
				position_params.textDocument.uri,
				position_params.position.line,
				position_params.position.character,
			},
		}

		vim.lsp.buf_request(opts.buffer, "workspace/executeCommand", params)
	end

	vim.keymap.set("n", "<leader>cp", function()
		manipulate_pipe("toPipe")
	end, { desc = "To Pipe", buffer = opts.buffer })

	vim.keymap.set("n", "<leader>cP", function()
		manipulate_pipe("fromPipe")
	end, { desc = "From Pipe", buffer = opts.buffer })
end

return M
