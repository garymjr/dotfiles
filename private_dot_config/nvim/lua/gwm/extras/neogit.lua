return {
	"NeogitOrg/neogit",
	keys = {
		{
			"<leader>gs",
			function()
				require("neogit").open({ kind = "split" })
			end,
			silent = true,
			desc = "status",
		},
	},
	opts = {
		git_services = {
			["gitlab.frg.tech"] = "https://gitlab.frg.tech/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
		},
		commit_popup = {
			kind = "floating",
		},
	},
	config = function(_, opts)
		require("neogit").setup(opts)
	end,
}
