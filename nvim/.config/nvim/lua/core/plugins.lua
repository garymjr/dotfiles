vim.cmd [[packadd packer.nvim]]

require('packer').startup {
  function(use)
    use { 'wbthomason/packer.nvim', opt = true }

    use '~/.config/nvim/plugins/parsec'

    -- utilities
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    -- telescope
    use {
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make'
    }

    use {
      'nvim-telescope/telescope.nvim',
      config = function()
        require('telescope').load_extension('fzf')
      end
    }

    -- themes
    use 'glepnir/zephyr-nvim'
    use 'romgrk/doom-one.vim'
    use 'folke/tokyonight.nvim'
    use 'sainnhe/sonokai'
    use 'lucastrvsn/kikwis'

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
    use { 'styled-components/vim-styled-components', branch = 'main', disable = true }
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
  end
}
