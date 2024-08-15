local M = {}

--- @param opts {client: vim.lsp.Client}
function M.setup(opts)
  if opts.client.name ~= "gopls" then
    return
  end

  local client = opts.client
	if not client.server_capabilities.semanticTokensProvider then
		local semantic = client.config.capabilities.textDocument.semanticTokens
		if not semantic then
			return
		end
		client.server_capabilities.semanticTokensProvider = {
			full = true,
			legend = {
				tokenTypes = semantic.tokenTypes,
				tokenModifiers = semantic.tokenModifiers,
			},
			range = true,
		}
	end
end

return M
