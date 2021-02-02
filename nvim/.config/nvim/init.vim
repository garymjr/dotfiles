if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let mapleader = ' '

filetype plugin indent on

" call plug#begin('~/.local/share/nvim/site/plugged')
" Plug 'junegunn/fzf'
" Plug 'junegunn/fzf.vim'
" Plug 'bluz71/vim-nightfly-guicolors'
" Plug 'adrian5/oceanic-next-vim'
" Plug 'voldikss/vim-floaterm'
" call plug#end()

set autoindent
set autoread
set backspace=indent,eol,start
set belloff=all
set clipboard^=unnamed,unnamedplus
set complete-=i
set complete-=t
set completeopt=menuone,noinsert,noselect
set encoding=utf-8
set expandtab
set foldmethod=indent
set foldlevelstart=99
set grepprg=rg\ --color=never
set guifont=Dank\ Mono:h18
set fileformats=unix
set hidden
set history=1000
set ignorecase
set inccommand=nosplit
set incsearch
set laststatus=2
set mouse=a
set nobackup
set nohlsearch
set nomodeline
set nonumber
set noshowcmd
set noshowmode
set noswapfile
set noundofile
set nowrap
set path+=**
" set re=2
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

lua require('init')

augroup sync_colors
  autocmd!
  autocmd BufEnter,BufWrite * syntax sync fromstart
augroup END

augroup quickfix_on_bottom
  autocmd!
  autocmd FileType qf wincmd J
augroup END

augroup neovim_terminal
  autocmd!
  autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

augroup insert_cursorline
  autocmd!
  autocmd InsertEnter,WinLeave,BufLeave * setlocal nocursorline
  autocmd InsertLeave,WinEnter,BufEnter * setlocal cursorline
augroup END

augroup vimrc
  autocmd!
  autocmd VimEnter * ++once ++nested set bg=dark
  autocmd BufWritePost $MYVIMRC so $MYVIMRC
augroup END

let g:oceanic_for_polyglot = 1
let g:oceanic_italic_comments = 1

let g:floaterm_wintitle = v:false
let g:floaterm_autoclose = v:true

inoremap <silent><expr> <c-j> pumvisible() ? "\<c-n>" : "\<c-j>"
inoremap <silent><expr> <c-k> pumvisible() ? "\<c-p>" : "\<c-k>"

command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

command! -bang -nargs=? -complete=dir GFiles
    \ call fzf#vim#gitfiles(<q-args>, fzf#vim#with_preview(), <bang>0)

" command! Lazygit FloatermNew --height=0.9 --width=0.9 lazygit
command! GitBranch FloatermNew --height=0.9 --width=0.9 gitin branch
nnoremap <leader>gb :GitBranch<cr>

command! GitStatus FloatermNew --height=0.9 --width=0.9 gitin status
nnoremap <leader>gs :GitStatus<cr>


let g:chadtree_settings = {
      \ 'theme.text_colour_set': 'nerdtree_syntax_dark',
      \ }

colorscheme zenburn

vmap < <gv
vmap > >gv

" Make Y like P
nnoremap Y y$

" fzf
" nnoremap <silent> <leader>f :Files<cr>
" nnoremap <silent> <leader>h :Helptags<cr>
" nnoremap <silent> <tab> :Buffers<cr>

" Telescope
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <tab> <cmd>lua require('telescope.builtin').buffers()<cr>

nnoremap <silent> <leader>e :CHADopen<cr>
nnoremap <silent> gp :%!npx prettier --stdin-filepath %<cr>

" movement
nnoremap <c-h> <c-w>h
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-l> <c-w>l
nnoremap <backspace> <c-w>p

" use escape in terminal
tnoremap <esc> <c-\><c-n>

nnoremap <silent> gh <cmd>lua require('lspsaga.provider').lsp_finder()<cr>
nnoremap <silent><leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<cr>
nnoremap <silent> gd <cmd>lua require'lspsaga.provider'.preview_definition()<cr>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<cr>

imap <expr> <tab> vsnip#available(1) ? '<Plug>(vsnip-expand-or-jump)' : '<Tab>'
imap <expr> <s-tab> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<S-Tab>'

inoremap <expr> <c-j> pumvisible() ? '<c-n>' : '<c-j>'
inoremap <expr> <c-k> pumvisible() ? '<c-p>' : '<c-k>'
