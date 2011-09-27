" $HOME/.gvimrc
" Maintainer:   TaCahiroy <tacahiroy*DELETE-ME*@gmail.com>

scriptencoding utf-8

set cmdheight=2
set columns=100
set guioptions=aeciM
set guitablabel=%N)\ %f
set lines=40

if 702 < v:version
  set relativenumber
endif

set t_vb=

set mouse=a
set nomousefocus
set mousehide


nmap <C-LeftMouse> <C-]>zz
nmap <C-RightMouse> <C-t>zz


if &guioptions =~# 'M'
  let &guioptions = substitute(&guioptions, '[mT]', '', 'g')
endif


set background=light
colorscheme seashell
let g:colorscheme = colors_name

if has('mac')
  set guifont=Monaco:h12
  set antialias

  set fuoptions+=maxhorz
elseif has('unix')
  set guifont=M+1VM+IPAG\ circle\ 10
else
  " Windows
  set guifont=M+1VM+IPAG_circle:h10:cDEFAULT
endif

if has('multi_byte_ime') || has('xim')
  set iminsert=0 imsearch=0
endif


" printing font
if has('printer')
  if has('win32')
    let &printfont = &guifont
  endif
endif

" __END__ {{{
" vim: ts=2 sts=2 sw=2 fdm=marker
