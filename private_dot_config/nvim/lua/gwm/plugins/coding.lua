return {
	{
		"mini.comment",
		opts = function(_, opts)
			local options = opts.options or {}
			options.custom_commentstring = nil
			opts.options = options
			return options
		end,
	},
}
