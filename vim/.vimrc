call plug#begin('~/.vim/plugged')
Plug 'mhinz/vim-startify'
Plug 'junegunn/fzf' | Plug 'junegunn/fzf.vim'
Plug 'mattn/emmet-vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'scrooloose/nerdtree' | Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'styled-components/vim-styled-components', {'branch': 'main'}
Plug 'markonm/traces.vim'

Plug 'yuezk/vim-js'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'MaxMEllon/vim-jsx-pretty'
Plug 'othree/html5.vim'
Plug 'hail2u/vim-css3-syntax'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'drewtempelmeyer/palenight.vim'
Plug 'sonph/onehalf', {'rtp': 'vim/'}
Plug 'jacoborus/tender.vim'
Plug 'joshdick/onedark.vim'
Plug 'KeitaNakamura/neodark.vim'

Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install() }}
" Plug 'neoclide/coc-pairs', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-snippets', {'do': 'yarn install'}
Plug 'neoclide/coc-eslint', {'do': 'yarn install'}
Plug 'neoclide/coc-emmet', {'do': 'yarn install'}
Plug 'neoclide/coc-json', {'do': 'yarn install'}
Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
Plug 'neoclide/coc-prettier', {'do': 'yarn install'}
Plug 'neoclide/coc-highlight', {'do': 'yarn install'}
call plug#end()

set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set belloff=all
set clipboard^=unnamed,unnamedplus
set complete-=i
set complete-=t
set completeopt=menu,menuone,noinsert,noselect
set encoding=utf-8
set expandtab
set foldmethod=indent
set foldlevelstart=99
set grepprg=rg\ --color=never
set fileformats=unix
set hidden
set history=10000
set ignorecase
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
set number
set path+=**
set ruler
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
set updatetime=300
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set wildignore+=*/node_modules/*
set wildmenu
set wildmode=list:longest,list:full

scriptencoding utf-8

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" highlight default link CocHighlightText NONE

filetype plugin indent on
colorscheme tender
let g:airline_powerline_fonts = 1
" let g:airline_theme = 'palenight'

let g:any_jump_search_prefered_engine = 'rg'

" highlight CocHighlightText guibg=#34394e

augroup AutoUpdateFiles
  autocmd!
  autocmd CursorHold,FocusGained,WinEnter * checktime
  autocmd BufEnter,BufWrite,CursorHold * syntax sync fromstart
augroup END

augroup Coc
  autocmd!
  autocmd CursorHold * silent call CocActionAsync('highlight')
augroup END

augroup RemeberLastPosition
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

augroup Css
  autocmd!
  autocmd FileType css setlocal iskeyword+=-
augroup END

augroup QuickFix
  autocmd!
  autocmd FileType qf wincmd J
augroup END

let g:startify_change_to_dir = 0

let mapleader=' '

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

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
    \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

nnoremap <silent> <tab> :Buffers<cr>
nnoremap <silent> <leader>e :NERDTreeToggle<cr>
nnoremap <silent> <leader>gf :GFiles<cr>
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader><leader> :Files<cr>
nnoremap <silent> <leader>h :Helptags<cr>
nnoremap <silent> <leader>lg :term ++close lazygit<cr>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
imap <C-l> <Plug>(coc-snippets-expand)
inoremap <silent><expr> <c-x>o coc#refresh()
