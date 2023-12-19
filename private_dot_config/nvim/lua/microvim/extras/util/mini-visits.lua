return {
	{
		"echasnovski/mini.visits",
		event = { "VeryLazy", "LazyFile" },
		opts = {},
		keys = function()
			local sort_latest = require("mini.visits").gen_sort.default({ recency_weight = 1 })

			local function unsorted(path_data)
				return path_data
			end

			local function is_bookmarked(path_data)
				return path_data.labels and path_data.labels.bookmark
			end

			local function get_bookmark(index)
				local bookmarks = require("mini.visits").list_paths(nil, { filter = is_bookmarked, sort = unsorted })
				if bookmarks and bookmarks[index] then
					vim.cmd("e " .. bookmarks[index])
				end
			end

			return {
				{
					"[{",
					function()
						require("mini.visits").iterate_paths("last", vim.fn.getcwd(), { sort = sort_latest })
					end,
					desc = "Visit last",
				},
				{
					"[[",
					function()
						require("mini.visits").iterate_paths("forward", vim.fn.getcwd(), { sort = sort_latest })
					end,
					desc = "Visit previous",
				},
				{
					"]]",
					function()
						require("mini.visits").iterate_paths("backward", vim.fn.getcwd(), { sort = sort_latest })
					end,
					desc = "Visit next",
				},
				{
					"]}",
					function()
						require("mini.visits").iterate_paths("first", vim.fn.getcwd(), { sort = sort_latest })
					end,
					desc = "Visit first",
				},
				{
					"<leader>ma",
					function()
						require("mini.visits").add_label(
							"bookmark",
							vim.api.nvim_buf_get_name(0),
							require("lazyvim.util").root.get()
						)
					end,
					desc = "Add bookmark",
				},
				{
					"<leader>md",
					function()
						require("mini.visits").remove_label("bookmark", vim.api.nvim_buf_get_name(0), "")
					end,
					desc = "Remove bookmark",
				},
				{
					"<leader>mm",
					function()
						require("mini.visits").select_path(nil, { filter = is_bookmarked })
					end,
					desc = "Bookmarks menu",
				},
				{
					"<leader>mp",
					function()
						require("mini.visits").iterate_paths(
							"forward",
							"",
							{ sort = sort_latest, label = "bookmark", wrap = true }
						)
					end,
					desc = "Previous bookmark",
				},
				{
					"<leader>mn",
					function()
						require("mini.visits").iterate_paths(
							"backward",
							"",
							{ sort = sort_latest, label = "bookmark", wrap = true }
						)
					end,
					desc = "Next bookmark",
				},
				{
					"<leader>m1",
					function()
						get_bookmark(1)
					end,
					desc = "Edit bookmark 1",
				},
				{
					"<leader>m2",
					function()
						get_bookmark(2)
					end,
					desc = "Edit bookmark 2",
				},
				{
					"<leader>m3",
					function()
						get_bookmark(3)
					end,
					desc = "Edit bookmark 3",
				},
				{
					"<leader>m?",
					function()
						vim.ui.input({ prompt = "Bookmark index: " }, function(index)
							if not index then
								return
							end
							local bookmark = tonumber(index)
							get_bookmark(bookmark)
						end)
					end,
					desc = "Edit nth bookmark",
				},
			}
		end,
	},
	{
		"folke/which-key.nvim",
		optional = true,
		opts = function(_, opts)
			opts.defaults["<leader>m"] = { name = "+bookmarks" }
		end,
	},
}
