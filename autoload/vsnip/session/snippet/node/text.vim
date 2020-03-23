function! vsnip#session#snippet#node#text#import() abort
  return s:Text
endfunction

let s:Text = {}

"
" new.
"
function! s:Text.new(ast) abort
  return extend(deepcopy(s:Text), {
        \   'type': 'text',
        \   'value': a:ast.escaped,
        \ })
endfunction

"
" text.
"
function! s:Text.text() abort
  return self.value
endfunction

