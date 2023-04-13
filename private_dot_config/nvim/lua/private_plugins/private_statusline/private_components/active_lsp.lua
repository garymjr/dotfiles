local conditions = require("heirline.conditions")

local function get_active_clients()
	local clients = {}
	local deferred = {}
	for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
		if client.name == "null-ls" then
			table.insert(deferred, client)
		elseif client.name == "copilot" then
			table.insert(deferred, client)
		else
			table.insert(clients, client)
		end
	end

	if #deferred > 0 then
		for _, client in ipairs(deferred) do
			table.insert(clients, client)
		end
	end
	return clients
end

return {
    condition = conditions.lsp_attached,
    update = {"LspAttach", "LspDetach"},
    provider = function()
        local clients = get_active_clients()
        local client = clients[1]
        return client.name .. " |"
    end,
}
