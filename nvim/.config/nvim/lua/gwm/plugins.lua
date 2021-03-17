vim.cmd [[packadd packer.nvim]]

require('packer').startup {
  function(use)
    use { 'wbthomason/packer.nvim', opt = true }

    -- my plugins
    use '~/.config/nvim/plugins/onedark'
    use '~/.config/nvim/plugins/onehalf'
    use '~/.config/nvim/plugins/ocean'

    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'

    use {
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-telescope/telescope-fzy-native.nvim',
        'nvim-telescope/telescope-fzf-writer.nvim'
      }
    }

    use 'neovim/nvim-lspconfig'
    use 'wbthomason/lsp-status.nvim'
    use { 'glepnir/lspsaga.nvim', branch = 'main' }

    use {
      'hrsh7th/nvim-compe'
    }

    use {
      disable = true,
      'hrsh7th/vim-vsnip',
      requires = {
        'hrsh7th/vim-vsnip-integ'
      }
    }

    use 'tpope/vim-commentary'
    use 'tpope/vim-surround'

    use 'justinmk/vim-sneak'

    use { 'glepnir/galaxyline.nvim', branch = 'main' }

    use 'sheerun/vim-polyglot'

    use { 'styled-components/vim-styled-components', branch = 'main' }

    use 'kyazdani42/nvim-tree.lua'

    use 'tjdevries/colorbuddy.nvim'
    use 'tjdevries/gruvbuddy.nvim'
    use 'Th3Whit3Wolf/onebuddy'

    use { 'rktjmp/lush.nvim', branch = 'main' }
    use { 'npxbr/gruvbox.nvim', branch = 'main' }

    use 'google/vim-searchindex'
    use 'norcalli/snippets.nvim'
    use 'norcalli/ui.nvim'

    use 'kyazdani42/nvim-web-devicons'

    use 'nvim-treesitter/nvim-treesitter'
    use 'norcalli/nvim-colorizer.lua'
  end
}
