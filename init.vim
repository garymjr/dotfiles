" Section: Setup

unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim

let mapleader = ' '
let maplocalleader = ','

" Section: Plugins

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-commentary'
Plug 'wellle/targets.vim'
Plug 'sheerun/vim-polyglot'
Plug 'joshdick/onedark.vim'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install() }}
call plug#end()

" Section: Settings

set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set belloff=all
set clipboard^=unnamed,unnamedplus
set complete-=i
set complete-=t
set completeopt=menu,menuone,noinsert,noselect
set expandtab
set foldmethod=indent
set foldlevelstart=99
set grepprg=rg\ --color=never
set fileformats=unix
set hidden
set history=10000
set ignorecase
set inccommand=nosplit
set incsearch
set laststatus=2
set mouse=a
set nobackup
set nohlsearch
set nomodeline
set noshowcmd
set noshowmode
set noswapfile
set noundofile
set nowrap
set re=1
set ruler
set shiftwidth=2
set shortmess+=I
set shortmess+=W
set shortmess+=a
set shortmess+=c
set smartcase
set splitbelow
set splitright
set tabstop=2
set termguicolors
set timeoutlen=1000 ttimeoutlen=0
set updatetime=2000
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set wildignore+=*/node_modules/*
set wildmenu
set wildmode=list:longest,list:full

" Section: Appearance

augroup ColorScheme
  au!
  au VimEnter * call SetupDefaultItalics()
  au ColorScheme * call SetupDefaultItalics()
augroup END

colorscheme onedark

" Section: Autocmd

augroup DotVim
  autocmd!

  " Update files
  autocmd CursorHold,FocusGained,WinEnter * checktime

  " Always put quickfix on the bottom
  autocmd FileType qf wincmd J

  " Fix for css files
  autocmd FileType css setlocal iskeyword+=-
augroup END

augroup Vue
  autocmd!
  autocmd BufEnter,FocusGained,BufWrite,CursorHold *.vue syntax sync fromstart
augroup END

" Section: Functions

function! SetupDefaultItalics() abort
  hi Comment   gui=italic cterm=italic
  hi xmlAttrib gui=italic cterm=italic
endfunc

" Section: Plugins

" Set coc_filetypes to an empty array
let g:coc_filetypes = []

" Section: Mappings

" Use esc to exit insert mode in terminal
tnoremap <esc> <c-\><c-n>

" Keep visual selection when shifting
vmap < <gv
vmap > >gv

" make backspace useful in normal mode
nnoremap <backspace> <c-^>

" Make Y like P
nnoremap Y y$

" emmet
inoremap <silent> <c-e> <c-r>=emmet#expandAbbr(0, "")<cr>

" <leader>
nnoremap <silent> <tab> :GFiles<cr>
nnoremap <silent> <leader><leader> :Buffers<cr>
nnoremap <silent> <leader>b :Buffers<cr>
nnoremap <silent> <leader>c <c-w>c
nnoremap <silent> <leader>e :NERDTreeToggle<cr>
nnoremap <silent> <leader>ff :Files<cr>
nnoremap <silent> <leader>fv :e $MYVIMRC<cr>
nnoremap <silent> <leader>h :Helptags<cr>
nnoremap <silent> <leader>wh <c-w>h
nnoremap <silent> <leader>wj <c-w>j
nnoremap <silent> <leader>wk <c-w>k
nnoremap <silent> <leader>wl <c-w>l
