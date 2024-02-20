return {
	{
		"tpope/vim-dadbod",
		cmd = "DB",
		opts = {},
		config = function()
			vim.api.nvim_cmd({
				cmd = "DB",
				args = {
					"g:mds_dev",
					"=",
					"postgres://mds:password2@mds-postgres.cluster-ch8hux0zznqj.us-east-1.rds.amazonaws.com:5432/mds_main",
				},
			})
		end,
	},
}
