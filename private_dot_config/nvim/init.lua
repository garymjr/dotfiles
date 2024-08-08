local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.uv.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

require('mini.deps').setup({ path = { package = path_package } })

local add = MiniDeps.add

add({
  source = "nvim-treesitter/nvim-treesitter",
  depends = { "folke/ts-comments.nvim", "windwp/nvim-ts-autotag" },
  hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
})

add({
  source = "neovim/nvim-lspconfig",
  depends = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
})

add({
  source = "folke/lazydev.nvim",
  depends = { "Bilal2453/luvit-meta" },
})

add("j-hui/fidget.nvim")

add("stevearc/conform.nvim")

add("mfussenegger/nvim-lint")

add({
  source = "xvzc/chezmoi.nvim",
  depends = { "nvim-lua/plenary.nvim" },
})

add({
  source = "catppuccin/nvim",
  name = "catppuccin",
})

add({
  source = "julienvincent/hunk.nvim",
  depends = { "MunifTanjim/nui.nvim" },
})

add({
  source = "kristijanhusak/vim-dadbod-ui",
  depends = { "tpope/vim-dadbod" },
})

add("numToStr/Navigator.nvim")
