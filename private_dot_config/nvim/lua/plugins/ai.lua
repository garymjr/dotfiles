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
    debug = true,
    provider = "ollama",
    ollama = {
      model = "starcoder2",
    },
  })
end)