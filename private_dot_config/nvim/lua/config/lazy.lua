local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
  })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
    spec = {
        -- { import = "config.plugins" },
        { import = "plugins" },
    },
    install = { colorscheme = {"nordic"} },
    defaults = { lazy = true },
    checker = { enabled = true, notify = false },
    performace = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchparen",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
