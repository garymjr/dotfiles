local execute = vim.api.nvim_command
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://github.com/wbthomason/packer.nvim', install_path})
  execute 'packadd packer.nvim'
end

vim.cmd [[packadd packer.nvim]]

require('packer').startup {
  function(use)
    use { 'wbthomason/packer.nvim', opt = true }

    -- utilities
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
      }
    }

    -- themes
    use 'glepnir/zephyr-nvim'
    use 'romgrk/doom-one.vim'
    use 'folke/tokyonight.nvim'
    use 'sainnhe/sonokai'
    use 'owozsh/amora'
    use 'bluz71/vim-nightfly-guicolors'

    -- treesitter
    use 'nvim-treesitter/playground'
    use 'nvim-treesitter/nvim-treesitter'

    -- lsp
    use 'neovim/nvim-lspconfig'
    use 'wbthomason/lsp-status.nvim'
    use 'folke/lsp-trouble.nvim'

    -- dap
    use 'mfussenegger/nvim-dap'

    -- completion
    use 'hrsh7th/nvim-compe'

    -- snippets
    use 'hrsh7th/vim-vsnip'

    -- tpope plugins
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-eunuch'

    -- languages
    use { 'styled-components/vim-styled-components', branch = 'main' }
    use 'jxnblk/vim-mdx-js'

    -- git
    use { 'lewis6991/gitsigns.nvim', branch = 'main' }

    -- misc
    use 'google/vim-searchindex'
    use {
      'kyazdani42/nvim-web-devicons',
      config = function()
        require('nvim-web-devicons').setup({
          default = true
        })
      end
    }
    use {
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end
    }
    use 'mhartington/formatter.nvim'
    use 'tamago324/lir.nvim'
    use 'akinsho/nvim-toggleterm.lua'
    use 'glepnir/dashboard-nvim'
    use { 'glepnir/galaxyline.nvim', branch = 'main' }
    use 'rhysd/git-messenger.vim'
    use {
      'folke/todo-comments.nvim',
      config = function()
        require('todo-comments').setup({})
      end
    }
  end
}
