" You probably always want to set this in your vim file
set background=dark
let g:colors_name = 'cosmic_latte'

" By setting our module to nil, we clear lua's cache,
" which means the require ahead will *always* occur.
"
" This isn't strictly required but it can be a useful trick if you are
" incrementally editing your confit a lot and want to be sure your themes
" changes are being picked up without restarting neovim.
"
" Note if you're working in on your theme and have lush.ify'd the buffer,
" your changes will be applied with our without the following line.
lua package.loaded['cosmic_latte.theme'] = nil

" include our theme file and pass it to lush to apply
lua require('lush')(require('cosmic_latte.theme'))

let g:terminal_color_0 = '#202a31'
let g:terminal_color_1 = '#c17b8d'
let g:terminal_color_2 = '#7d9761'
let g:terminal_color_3 = '#b28761'
let g:terminal_color_4 = '#5496bd'
let g:terminal_color_5 = '#9b85bb'
let g:terminal_color_6 = '#459d90'
let g:terminal_color_7 = '#abb0c0'
let g:terminal_color_8 = '#898f9e'
let g:terminal_color_9 = '#c17b8d'
let g:terminal_color_10 = '#7d9761'
let g:terminal_color_11 = '#b28761'
let g:terminal_color_12 = '#5496bd'
let g:terminal_color_13 = '#9b85bb'
let g:terminal_color_14 = '#459d90'
let g:terminal_color_15 = '#c5cbdb'
