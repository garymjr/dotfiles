MiniDeps.add({
  source = "yetone/avante.nvim",
  depends = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "zbirenbaum/copilot.lua",
  },
})

MiniDeps.now(function()
  require("avante_lib").load()
end)

MiniDeps.later(function()
  require("copilot").setup()
end)

MiniDeps.later(function()
  require("avante").setup({
    -- debug = true,
    provider = "copilot",
    auto_suggestions_provider = "copilot",
    behaviour = {
      auto_suggestions = true,
      auto_apply_diff_after_generation = true,
    },
  })
end)
