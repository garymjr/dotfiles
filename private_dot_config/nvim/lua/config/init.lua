local M = {}

M.capabilities = {
	workspace = {
		fileOperations = {
			didRename = true,
			willRename = true,
		},
	},
}

M.formatters = {
	biome = {
		args = {
			"format",
			"--semicolons",
			"as-needed",
			"--quote-style",
			"single",
			"--indent-style",
			"space",
			"--line-width",
			"100",
			"--stdin-file-path",
			"$FILENAME",
		},
	},
	sqlfluff = {
		args = { "format", "--dialect=ansi", "-" },
	},
}

M.formatters_by_ft = {
	go = { "goimports", "gofumpt" },
	javascript = { "biome" },
	json = { "biome" },
	lua = { "stylua" },
	mysql = { "sqlfluff" },
	plsql = { "sqlfluff" },
	sql = { "sqlfluff" },
	typescript = { "biome" },
	typescriptreact = { "biome" },
}

M.grammars = {
	"bash",
	"c",
	"diff",
	"dockerfile",
	"eex",
	"elixir",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"go",
	"gomod",
	"gosum",
	"gowork",
	"heex",
	"html",
	"javascript",
	"jsdoc",
	"json",
	"json5",
	"jsonc",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"printf",
	"python",
	"query",
	"regex",
	"sql",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}

M.icons = {
	diagnostics = {
		Error = " ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	},
}

M.linters = {
	credo = {
		condition = function(ctx)
			return vim.fs.find({ ".credo.exs" }, { path = ctx.filename, upward = true })[1]
		end,
	},
}
M.linters_by_ft = {
	elixir = { "credo" },
	mysql = { "sqlfluff" },
	plsql = { "sqlfluff" },
	sql = { "sqlfluff" },
}

M.servers = {
  elixirls = {},
	gopls = {
		settings = {
			gopls = {
				gofumpt = true,
				codelenses = {
					gc_details = false,
					generate = true,
					regenerate_cgo = true,
					run_govulncheck = true,
					test = true,
					tidy = true,
					upgrade_dependency = true,
					vendor = true,
				},
				hints = {
					assignVariableTypes = true,
					compositeLiteralFields = true,
					compositeLiteralTypes = true,
					constantValues = true,
					functionTypeParameters = true,
					parameterNames = true,
					rangeVariableTypes = true,
				},
				analyses = {
					fieldalignment = true,
					nilness = true,
					unusedparams = true,
					unusedwrite = true,
					useany = true,
				},
				usePlaceholders = true,
				completeUnimported = true,
				staticcheck = true,
				directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
				semanticTokens = true,
			},
		},
	},
	jsonls = {
		on_new_config = function(new_config)
			new_config.settings.json.schemas = new_config.settings.json.schemas or {}
			vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
		end,
		settings = {
			json = {
				format = {
					enable = true,
				},
				validate = { enable = true },
			},
		},
	},
  -- disabling this for now
	-- lexical = {},
	lua_ls = {
		settings = {
			Lua = {
				workspace = {
					checkThirdParty = false,
				},
				codeLens = {
					enable = true,
				},
				completion = {
					callSnippet = "Replace",
				},
				doc = {
					privateName = { "^_" },
				},
				hint = {
					enable = true,
					setType = false,
					paramType = true,
					paramName = "Disable",
					semicolon = "Disable",
					arrayIndex = "Disable",
				},
			},
		},
	},
	tailwindcss = {
		settings = {
			tailwindCSS = {
				includeLanguages = {
					elixir = "html-eex",
					eelixir = "html-eex",
					heex = "html-eex",
				},
			},
		},
	},
	vtsls = {
		-- explicitly add default filetypes, so that we can extend
		-- them in related extras
		filetypes = {
			"javascript",
			"javascriptreact",
			"javascript.jsx",
			"typescript",
			"typescriptreact",
			"typescript.tsx",
		},
		settings = {
			complete_function_calls = true,
			vtsls = {
				enableMoveToFileCodeAction = true,
				autoUseWorkspaceTsdk = true,
				experimental = {
					completion = {
						enableServerSideFuzzyMatch = true,
					},
				},
			},
			typescript = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = {
					completeFunctionCalls = true,
				},
				inlayHints = {
					enumMemberValues = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
					parameterNames = { enabled = "literals" },
					parameterTypes = { enabled = true },
					propertyDeclarationTypes = { enabled = true },
					variableTypes = { enabled = false },
				},
			},
			javascript = {
				updateImportsOnFileMove = { enabled = "always" },
				suggest = {
					completeFunctionCalls = true,
				},
				inlayHints = {
					enumMemberValues = { enabled = true },
					functionLikeReturnTypes = { enabled = true },
					parameterNames = { enabled = "literals" },
					parameterTypes = { enabled = true },
					propertyDeclarationTypes = { enabled = true },
					variableTypes = { enabled = false },
				},
			},
		},
	},
}

M.tools = {
	"biome",
	"gofumpt",
	"goimports",
	"sqlfluff",
	"stylua",
}

return M
