if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

filetype plugin indent on

call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'

Plug 'justinmk/vim-sneak'

Plug 'bluz71/vim-nightfly-guicolors'
Plug 'bluz71/vim-moonfly-statusline'

Plug 'adrian5/oceanic-next-vim'

Plug 'sheerun/vim-polyglot'
Plug 'styled-components/vim-styled-components', {'branch': 'main'}
Plug 'ntpeters/vim-better-whitespace'
Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
call plug#end()

set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set belloff=all
set clipboard^=unnamed,unnamedplus
set complete-=i
set complete-=t
set completeopt=menuone,noinsert,noselect
set encoding=utf-8
set expandtab
set fileformats=unix
set hidden
set history=1000
set ignorecase
set incsearch
set laststatus=2
set mouse=a
set nobackup
set nomodeline
set noshowcmd
set noshowmode
set noswapfile
set noundofile
set nowrap
set number
set path+=**
set re=2
set ruler
set scrolloff=3 sidescrolloff=3
set shiftwidth=2
set shortmess+=I
set shortmess+=W
set shortmess+=a
set shortmess+=c
set signcolumn=no
set smartcase
set splitbelow
set splitright
set tabstop=2
set termguicolors
set timeoutlen=1000 ttimeoutlen=0
set updatetime=1000
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set wildignore+=*/node_modules/*
set wildmenu
set wildmode=list:longest,list:full

augroup quickfix_on_bottom
  autocmd!
  autocmd FileType qf wincmd J
augroup END

augroup insert_cursorline
  autocmd!
  autocmd InsertEnter * :setlocal nocursorline
  autocmd InsertLeave * :setlocal cursorline
augroup END

augroup vimrc
  autocmd!
  autocmd BufWritePost $MYVIMRC :so $MYVIMRC
augroup END

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

colorscheme nightfly

inoremap <silent><expr> <c-j> pumvisible() ? "\<c-n>" : "\<c-j>"
inoremap <silent><expr> <c-k> pumvisible() ? "\<c-p>" : "\<c-k>"

vmap < <gv
vmap > >gv
nnoremap < V<gv
nnoremap > V>gv

nnoremap Y y$

let mapleader = ' '
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>h :Helptags<cr>
nnoremap <silent> <leader>e :CocCommand exporer<cr>

nnoremap <silent> <tab> :Buffers<cr>
nnoremap <backspace> <c-^>
nnoremap <silent> gp :CocCommand prettier.formatFile<cr>

nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l

tnoremap <esc> <c-\><c-n>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction
