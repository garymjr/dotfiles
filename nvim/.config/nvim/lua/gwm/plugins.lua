vim.cmd [[packadd packer.nvim]]

require('packer').startup {
  function(use)
    use { 'wbthomason/packer.nvim', opt = true }

    -- my plugins
    use '~/.config/nvim/plugins/parsec'
    use '~/.config/nvim/plugins/apprentice'
    use '~/.config/nvim/plugins/neotrix'

    -- utilities
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    -- themes
    use 'ajmwagar/vim-deus'
    use 'sainnhe/everforest'

    -- telescope
    use 'nvim-telescope/telescope.nvim'
    use 'nvim-telescope/telescope-fzy-native.nvim'

    -- treesitter
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/playground'

    -- lsp
    use 'neovim/nvim-lspconfig'
    use 'wbthomason/lsp-status.nvim'
    use { 'glepnir/lspsaga.nvim', branch = 'main' }
    use 'mfussenegger/nvim-dap'

    use 'hrsh7th/nvim-compe'
    use 'hrsh7th/vim-vsnip'

    -- tpope plugins
    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'
    use 'tpope/vim-fugitive'
    use 'tpope/vim-eunuch'

    use { 'glepnir/galaxyline.nvim', branch = 'main' }

    -- languages
    use 'sheerun/vim-polyglot'
    use { 'styled-components/vim-styled-components', branch = 'main' }

    use {
      disable = true,
      'kyazdani42/nvim-tree.lua'
    }

    -- TODO: I should really decide on colorbuddy or lush
    use 'tjdevries/colorbuddy.nvim'
    use 'tjdevries/gruvbuddy.nvim'
    use { 'rktjmp/lush.nvim', branch = 'main' }

    use 'google/vim-searchindex'
    use 'kyazdani42/nvim-web-devicons'
    use 'norcalli/nvim-colorizer.lua'
    use 'nacro90/numb.nvim'
    use { 'lewis6991/gitsigns.nvim', branch = 'main' }
  end
}
