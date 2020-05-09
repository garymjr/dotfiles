" function! s:completion_check_backspace() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1] =~ '\s'
" endfunction

" inoremap <silent><expr> <tab>
"       \ pumvisible() ? "\<c-n>" :
"       \ <SID>completion_check_backspace() ? "\<tab>" :
"       \ completion#trigger_completion()


" Make Y like P
nnoremap Y y$

" fzf
nnoremap <silent> <tab> :Buffers<cr>
nnoremap <silent> <leader>gf :GFiles<cr>
nnoremap <silent> <leader>f :Files<cr>
nnoremap <silent> <leader>h :Helptags<cr>

" lsp
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

" Keep visual selection when shifting
vmap < <gv
vmap > >gv
