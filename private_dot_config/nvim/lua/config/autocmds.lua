local function augroup(name)
	vim.api.nvim_create_augroup("gwm_" .. name, { clear = true })
end
