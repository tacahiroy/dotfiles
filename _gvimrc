" $HOME/.gvimrc
" Maintainer:   TaCahiroy <tacahiroy*DELETE-ME*@gmail.com>

scriptencoding utf-8

set columns=100
set lines=40
set cmdheight=2

set guioptions& guioptions=eciM
set guitablabel=%N)\ %f

nmap <C-LeftMouse> <C-]>zz
nmap <C-RightMouse> <C-t>zz

" hilight
" for completion
"au! ColorScheme *
" \ hi! Pmenu       guibg=LightGrey guifg=DarkBlue |
" \ hi! PmenuSel    guibg=SeaGreen guifg=White |
" \ hi! PmenuSbar   guibg=Orange |
" \ hi! Pmenuthumb  guifg=White  |
" \ hi! SignColor   guibg=Grey60 |
" \ hi! SignColumn  guibg=LightGrey guifg=LightGrey

set background=light
colorscheme seashell
let g:colorscheme = colors_name

" plug: vimshell
"autocmd BufEnter * if &buftype == '' | execute 'colorscheme ' . g:colorscheme | let &background=g:bg | else | colorscheme lucius | syntax on | endif

"augroup InsertHook
"  autocmd!
"  hi! Cursor gui=NONE guibg=Violet
"  hi! CursorIM gui=NONE guibg=#ff9900

"  autocmd InsertEnter * hi Cursor gui=NONE guibg=#3399ff
"  autocmd InsertLeave * hi CursorIM gui=NONE guibg=#ff9900
"                     \| hi Cursor gui=NONE guibg=Violet
"augroup END

" font
if has('unix')
  set guifont=M+1VM+IPAG\ circle\ 10
elseif has('mac')
else
  " Windows or others
  set guifont=M+1VM+IPAG_circle:h10:cDEFAULT
endif

if has('multi_byte_ime') || has('xim')
  set iminsert=0 imsearch=0
endif

set mouse=a
set nomousefocus
set mousehide
"
if &guioptions =~# 'M'
  let &guioptions = substitute(&guioptions, '[mT]', '', 'g')
endif

" printing font
if has('printer')
  if has('win32') || has('win64')
    set printfont=M+1VM+IPAG_circle:h10:cDEFAULT
  endif
endif

" __END__ {{{
" vim: ts=2 sts=2 sw=2 fdm=marker

