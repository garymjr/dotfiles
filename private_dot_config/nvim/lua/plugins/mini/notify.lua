require("mini.deps").now(function()
	require("mini.notify").setup()
	local notify = require("mini.notify").make_notify()

	---@diagnostic disable-next-line: duplicate-set-field
	vim.notify = function(msg, level)
		if level == nil then
			return
		end

		notify(msg, level)
	end
end)
