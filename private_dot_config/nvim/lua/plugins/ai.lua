MiniDeps.add({
	source = "magicalne/nvim.ai",
	depends = { "nvim-lua/plenary.nvim" },
})

MiniDeps.add({
  source = "magicalne/nvim.ai",
  depends = { "nvim-lua/plenary.nvim" },
})

MiniDeps.later(function()
  require("ai").setup({
    debug = false,
    provider = "ollama",
    ollama = {
      model = "llama3.1"
    },
  })
end)
