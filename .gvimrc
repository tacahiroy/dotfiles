" $HOME/.gvimrc
" Maintainer:   TaCahiroy <tacahiroy*DELETE-ME*@gmail.com>

scriptencoding utf-8

set cmdheight=2
set columns=100
set guioptions=eciM
set guitablabel=%N)\ %f
set lines=40
set t_vb=

set mouse=a
set nomousefocus
set mousehide

if &guioptions =~# 'M'
  let &guioptions = substitute(&guioptions, '[mT]', '', 'g')
endif


set background=light
colorscheme seashell
let g:colorscheme = colors_name

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


" printing font
if has('printer')
  if has('win32') || has('win64')
    set printfont=M+1VM+IPAG_circle:h10:cDEFAULT
  endif
endif

nmap <C-LeftMouse> <C-]>zz
nmap <C-RightMouse> <C-t>zz

" __END__ {{{
" vim: ts=2 sts=2 sw=2 fdm=marker

