MiniDeps.add({
	source = "olimorris/codecompanion.nvim",
	depends = {
		"nvim-lua/plenary.nvim",
	},
})

MiniDeps.later(function()
	local constants = {
		LLM_ROLE = "llm",
		USER_ROLE = "user",
		SYSTEM_ROLE = "system",
	}

	require("codecompanion").setup({
		adapters = {
			copilot = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "claude-3.5-sonnet",
						},
					},
				})
			end,
		},
		display = {
			chat = {
				window = {
					layout = "vertical",
				},
			},
			diff = {
				close_chat_at = 500,
				provider = "mini_diff",
			},
		},
		strategies = {
			chat = {
				adapter = "copilot",
				roles = { llm = "  CodeCompanion" },
				slash_commands = {
					file = {
						opts = {
							provider = "mini_pick",
						},
					},
					help = {
						opts = {
							provider = "mini_pick",
						},
					},
				},
			},
			inline = {
				adapter = "copilot",
			},
			agent = {
      ["dev"] = {
        description = "Developer - Can edit code and modify files",
        system_prompt = "If the user doesn't specify a path, use their current working directory.",
        tools = {
          "editor",
          "files",
        },
      },
				adapter = "copilot",
				tools = {
					opts = {
						auto_sumit_errors = true,
					},
				},
			},
		},
	})

	vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionChat<cr>", { silent = true })
	vim.keymap.set("n", "<leader>am", "<cmd>CodeCompanionActions<cr>", { silent = true })

	local function inline_prompt()
		local mode = vim.fn.mode()
		local is_visual_mode = mode == "v" or mode == "V"
		local range = is_visual_mode and "'<,'>" or ""

		vim.ui.input({ prompt = "  => " }, function(input)
			if input then
				local command = string.format("%sCodeCompanion %s", range, input)
				vim.cmd(command)
			end
		end)
	end

	vim.keymap.set({ "n", "v" }, "<c-cr>", inline_prompt)
	vim.keymap.set({ "n", "v" }, "<leader>ai", inline_prompt)
	-- vim.keymap.set({ "n", "v" }, "ga", "<cmd>CodeCompanionAdd<cr>")
end)
