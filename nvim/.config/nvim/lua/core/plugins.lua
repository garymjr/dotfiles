vim.cmd [[packadd packer.nvim]]

require('packer').startup {
  function(use)
    use { 'wbthomason/packer.nvim', opt = true }

    -- fzf
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'

    -- utilities
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    -- themes
    use 'ajmwagar/vim-deus'
    use 'glepnir/zephyr-nvim'
    use 'owozsh/amora'
    use 'romgrk/doom-one.vim'
    use 'nightsense/cosmic_latte'
    use 'romainl/Apprentice'
    use 'srcery-colors/srcery-vim'

    -- treesitter
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/playground'

    -- lsp
    use 'neovim/nvim-lspconfig'
    use 'wbthomason/lsp-status.nvim'
    use { 'glepnir/lspsaga.nvim', branch = 'main' }

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
    use 'kyazdani42/nvim-web-devicons'
    use 'norcalli/nvim-colorizer.lua'
    use 'mhartington/formatter.nvim'
    use 'justinmk/vim-dirvish'
  end
}
