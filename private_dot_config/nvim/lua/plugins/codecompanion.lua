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
				adapter = "copilot",
				tools = {
					opts = {
						auto_sumit_errors = true,
					},
				},
			},
		},
		-- prompt_library = {
		-- 	["Code workflow"] = {
		-- 		strategy = "workflow",
		-- 		description = "Use a workflow to guide an LLM in writing code",
		-- 		opts = {
		-- 			index = 4,
		-- 			is_default = true,
		-- 			short_name = "workflow",
		-- 		},
		-- 		prompts = {
		-- 			{
		-- 				-- We can group prompts together to make a workflow
		-- 				-- This is the first prompt in the workflow
		-- 				{
		-- 					role = constants.SYSTEM_ROLE,
		-- 					content = function(context)
		-- 						return string.format(
		-- 							"You carefully provide accurate, factual, thoughtful, nuanced answers, and are brilliant at reasoning. If you think there might not be a correct answer, you say so. Always spend a few sentences explaining background context, assumptions, and step-by-step thinking BEFORE you try to answer a question. Don't be verbose in your answers, but do provide details and examples where it might help the explanation. You are an expert software engineer for the %s language",
		-- 							context.filetype
		-- 						)
		-- 					end,
		-- 					opts = {
		-- 						visible = false,
		-- 					},
		-- 				},
		-- 				{
		-- 					role = constants.USER_ROLE,
		-- 					content = "I want you to ",
		-- 					opts = {
		-- 						auto_submit = false,
		-- 					},
		-- 				},
		-- 			},
		-- 			-- This is the second group of prompts
		-- 			{
		-- 				{
		-- 					role = constants.USER_ROLE,
		-- 					content = "Great. Now let's consider your code. I'd like you to check it carefully for correctness, style, and efficiency, and give constructive criticism for how to improve it.",
		-- 					opts = {
		-- 						auto_submit = false,
		-- 					},
		-- 				},
		-- 			},
		-- 			-- This is the final group of prompts
		-- 			{
		-- 				{
		-- 					role = constants.USER_ROLE,
		-- 					content = "Thanks. Now let's revise the code based on the feedback, without additional explanations.",
		-- 					opts = {
		-- 						auto_submit = false,
		-- 					},
		-- 				},
		-- 			},
		-- 		},
		-- 	},
		-- },
	})

	vim.keymap.set("n", "<leader>aa", "<cmd>CodeCompanionChat<cr>", { silent = true })
	vim.keymap.set("n", "<leader>am", "<cmd>CodeCompanionActions<cr>", { silent = true })

	local function inline_prompt()
		local mode = vim.fn.mode()
		if mode == "v" or mode == "V" then
			vim.ui.input({ prompt = " : " }, function(input)
				if input then
					vim.cmd(string.format("'<,'>CodeCompanion %s", input))
				end
			end)
		else
			vim.ui.input({ prompt = " : " }, function(input)
				if input then
					vim.cmd("CodeCompanion " .. input)
				end
			end)
		end
	end

	vim.keymap.set({ "n", "v" }, "<c-cr>", inline_prompt)
	vim.keymap.set({ "n", "v" }, "<leader>ai", inline_prompt)
	vim.keymap.set({ "n", "v" }, "ga", "<cmd>CodeCompanionAdd<cr>")
end)
