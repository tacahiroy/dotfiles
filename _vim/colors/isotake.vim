" Vim color file: isotake
" Author:   Tacahiroy <tacahiroy@gmail.com>
" This is based on seashell.vim by Gerald S. Williams
" http://www.vim.org/scripts/script.php?script_id=589

hi clear
if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "isotake"

hi Cursor   gui=NONE guibg=Orange
hi CursorIM gui=NONE guibg=#67db57

if &background == 'light'
  hi  Normal        guibg=Seashell       ctermfg=0
  hi  NonText       guibg=LavenderBlush  guifg=Gray30
  hi  LineNr        guibg=#ffdfe6        guifg=Gray30       cterm=NONE        ctermbg=NONE    ctermfg=007
  hi  CursorLineNr  gui=NONE             guibg=#ffdfe6      guifg=Brown       cterm=NONE      ctermbg=NONE  ctermfg=208
  hi  DiffDelete    guibg=LightRed       guifg=Black        ctermbg=DarkRed   ctermfg=White
  hi  DiffAdd       guibg=LightGreen     ctermbg=DarkGreen  ctermfg=White
  hi  DiffChange    guibg=Gray90         ctermbg=DarkCyan   ctermfg=White
  hi  DiffText      gui=NONE             guibg=LightCyan2   ctermbg=DarkCyan  ctermfg=Yellow
  hi  Comment       guifg=#339933        gui=Bold
  hi  Constant      guifg=DeepPink
  hi  PreProc       guifg=DarkMagenta
  hi  StatusLine    gui=NONE             guibg=Orange       guifg=Black       cterm=NONE      ctermfg=16    ctermbg=253
  hi  StatusLineNC  gui=NONE             guibg=Gray
  hi  VertSplit     gui=NONE             guibg=Gray
  hi  Identifier    guifg=#006f6f
  hi  Statement     guifg=DarkRed        ctermfg=DarkRed
  hi  MatchParen    guibg=turquoise
  hi  Search        guibg=LightGreen     guifg=DarKRed      gui=NONE
  hi  IncSearch     guibg=Pink           guifg=DarkGrey     gui=NONE
  hi  Pmenu         guibg=LightGrey      guifg=DarkBlue
  hi  PmenuSel      guibg=#6ac4ff        guifg=White
  hi  PmenuSbar     guibg=Grey70
  hi  Pmenuthumb    guifg=#bed4f7
  hi  SignColor     guibg=Grey60
  hi  SignColumn    guibg=LightGrey      guifg=LightGrey
  hi  TabLineSel    ctermbg=214          ctermfg=232
  hi  Visual        guibg=#ffd32e        gui=NONE
  hi  Folded        guibg=Pink           guifg=DarkBlue     ctermbg=236       ctermfg=226
  hi  FileName      gui=NONE             guifg=DarkRed      guibg=White       cterm=NONE      ctermfg=199
  hi  ColorColumn   guibg=#fde5fd        cterm=NONE         ctermbg=222       ctermfg=016
else
  hi  Normal        guibg=#0c0e66        guifg=seashell        ctermfg=White
  hi  NonText       guifg=LavenderBlush  ctermfg=LightMagenta
  hi  DiffDelete    guibg=DarkRed        guifg=Black           ctermbg=DarkRed   ctermfg=White
  hi  DiffAdd       guibg=DarkGreen      ctermbg=DarkGreen     ctermfg=White
  hi  DiffChange    guibg=Gray30         ctermbg=DarkCyan      ctermfg=White
  hi  DiffText      gui=NONE             guibg=DarkCyan        ctermbg=DarkCyan  ctermfg=Yellow
  hi  Comment       guifg=LightBlue
  hi  PreProc       ctermfg=Magenta
  hi  StatusLine    gui=NONE             guibg=DarkGreen       guifg=White       cterm=NONE      ctermfg=White  ctermbg=DarkGreen
  hi  StatusLineNC  guifg=Gray
  hi  VertSplit     guifg=Gray
  hi  Type          gui=NONE             guifg=#c1e3af
  hi  Identifier    guifg=Cyan
  hi  Statement     guifg=Brown3         ctermfg=DarkRed
  hi  Search        guibg=Gold3          ctermfg=White
  hi  Folded        guibg=gray20
  hi  FoldColumn    guibg=gray10
  hi  FileName      gui=NONE             guibg=White           guifg=Blue
endif
