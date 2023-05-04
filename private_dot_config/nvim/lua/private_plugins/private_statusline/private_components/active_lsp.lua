local conditions = require("heirline.conditions")

local function get_active_clients()
	local clients = {}
	local ignored = {"null-ls", "copilot"}
	for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
        if client and not vim.tbl_contains(ignored, client.name) then
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
        if #clients == 0 then
            return ""
        end
        local client = clients[1]
        return client.name .. " |"
    end,
}
