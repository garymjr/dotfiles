scriptencoding utf-8
filetype plugin indent on

syntax enable
syntax on

let mapleader=' '

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.local/share/nvim/site/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mhinz/vim-startify'
Plug 'SirVer/ultisnips'
Plug 'mcchrish/nnn.vim'

Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components', {'branch': 'main'}
Plug 'ntpeters/vim-better-whitespace'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-surround'


Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'

Plug 'ntk148v/vim-horizon'
Plug 'sainnhe/sonokai'

Plug 'psliwka/vim-smoothie'
Plug 'justinmk/vim-sneak'

Plug 'neovim/nvim-lsp'
Plug 'haorenW1025/completion-nvim'
call plug#end()

luafile ~/.config/nvim/init.lua

for f in split(glob('~/.config/nvim/config/*.vim'), '\n')
  exe 'source' f
endfor
