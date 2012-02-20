" $HOME/.vimrc
" Maintainer: tacahiroy <tacahiroy```AT```gmail.com>

scriptencoding utf-8

" vundle plugin management "{{{
filetype off
set runtimepath+=~/.vim/vundle.git
call vundle#rc()

Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-commentary'
Bundle 'msanders/snipmate.vim'

Bundle 'tacahiroy/vim-endwise'

Bundle 'thinca/vim-quickrun'
Bundle 'thinca/vim-ref'

Bundle 'scrooloose/nerdtree'

Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'
Bundle 'kchmck/vim-coffee-script'
Bundle 'jiangmiao/simple-javascript-indenter'
Bundle 'avakhov/vim-yaml'
Bundle 'bbommarito/vim-slim'
" Bundle 'mattn/zencoding-vim'

Bundle 'matchit.zip'
" Bundle 'IndentAnything'
Bundle 'Align'
Bundle 'camelcasemotion'

" Bundle 'increment_new.vim'
Bundle 'altercation/vim-colors-solarized'

filetype plugin indent on
"}}}

set cpo&vim

autocmd!

if isdirectory($HOME . '/.vim')
  let $DOTVIM = $HOME . '/.vim'
else
  " MS Windows etc...
  let $DOTVIM = $HOME . '/vimfiles'
endif

if isdirectory(expand('$DOTVIM/sandbox'))
  let dirs = split(glob($DOTVIM.'/sandbox/*'), '\n')
  for d in dirs
    execute ':set runtimepath+=' . d
  endfor
endif

set nocompatible
set verbose=0

" * functions "{{{1
" convert path separator "{{{
" unix <-> dos
function! g:cps(path, sep)
  return substitute(a:path, '[/\\]', a:sep, 'g')
endfunction "}}}


" tag information show in command window
function! s:previewTagLight(word)
  let t = taglist('^' . a:word . '$')
  let current = expand('%:t')

  for item in t
    if -1 < stridx(item.filename, current)
      " [filename] tag definition
      echohl Search | echomsg printf('%-36s %s', '[' . g:cps(item.filename, '/') . ']', item.cmd) | echohl None
    else
      echomsg printf('%-36s %s', '[' . substitute(g:cps(item.filename, '/'), '\s\s*$', '', '') . ']', item.cmd)
    endif
  endfor
endfunction
"}}}
"}}}


" GUI menu is not necessary. "{{{
let did_install_default_menus = 1
let did_install_syntax_menu = 1
"}}}

syntax enable
filetype plugin indent on

if has('unix')
  set encoding=utf-8
  set termencoding=utf-8
else
  set encoding=cp932
  set termencoding=cp932
endif


" * options {{{
set ambiwidth=double
set noautoindent
set nocindent
set nosmartindent
set autoread
set backspace=indent,eol,start
set backup
set backupext=.bac
set backupdir=$DOTVIM/backups
set backupskip& backupskip+=*.bac,COMMIT_EDITMSG,hg-editor-*.txt,svn-commit.tmp,svn-commit.[0-9]*.tmp
set cedit=
set cmdheight=2
set colorcolumn=80
set noequalalways
set expandtab smarttab
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932
let &fileformats = has('unix') ? 'unix,dos,mac' : 'dos,unix,mac'
set helplang=en,ja
set hidden
set history=10000
set hlsearch
set ignorecase
set incsearch
set linebreak
set linespace=0
set nolist
set listchars=tab:>-,trail:-,extends:>,precedes:<,eol:<
set laststatus=2
set lazyredraw
set modeline
set modelines=5

if 702 < v:version
  set relativenumber
else
  set number
endif

set previewheight=8
set pumheight=24
set scroll=0
set shellslash
set shiftround
set showbreak=\ \ \ \ \ 
set showfulltag
set showmatch matchtime=1
set showtabline=1
set nosplitbelow
set splitright
set nosmartcase
set swapfile directory=$DOTVIM/swaps
set switchbuf=useopen,usetab
set synmaxcol=300
set tags=./tags,tags;
set title
set titlestring=Vim:\ %F\ %h%r%m
set titlelen=255
set tabstop=2 shiftwidth=2 softtabstop=2
set viminfo='64,<100,s10,n~/.viminfo
set virtualedit=block
set visualbell
set wildignore=*.exe,*.dll,*.class,*.o,*.obj
set wildmenu
set wildmode=longest:list,full
set nowrapscan

if has('persistent_undo')
  set undodir=~/.vimundo
  augroup UndoFile
    autocmd!
    autocmd BufReadPre ~/* setlocal undofile
  augroup END
endif

let g:solarized_termcolors = 256
let g:solarized_termtrans = 1
let g:solarized_consrast = 'high'
let g:solarized_visibility = 'high'
let g:solarized_menu = 0
set background=light
colorscheme solarized

" if !has('gui_running')
"   colorscheme summerfruit256
" endif

set formatoptions& formatoptions+=mM formatoptions-=r

" statusline {{{2
" [#bufnr]filename [modified?][enc:ff][filetype]
let &statusline = '[#%n]%<%f %m%r%h%w%y'
let &statusline .= '%{(&l:fileencoding != "" ? &l:fileencoding : &encoding).":".&fileformat}'
let &statusline .= '(%{&expandtab ? "" : ">"}%{&l:tabstop})'
let &statusline .= '%#Underlined#%{fugitive#statusline()}%*'
" monstermethod.vim support
let &statusline .= '%{exists("b:mmi.name") && 0<len(b:mmi.name) ? " -- ".b:mmi.name."(".b:mmi.lines.")" : ""}'
let &statusline .= '%=%-16( %l/%LL,%c %)%P'
" }}}

set matchpairs& matchpairs+=<:>
let g:loaded_matchparen = 0
"highlight! MatchParen term=reverse ctermbg=LightRed gui=NONE guifg=fg guibg=LightRed
" }}}


" * map "{{{
" ummmmm like Emacs
" cmdline editing
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-o> <C-d>

nnoremap Y y$
nnoremap j gj
nnoremap k gk
nnoremap vv <C-v>
nnoremap [visual-row-without-eol] 0vg_
nmap vV [visual-row-without-eol]
nnoremap <C-]> <C-]>zz
nnoremap <C-t> <C-t>zz

nnoremap <silent> qj :cnext<Cr>
nnoremap <silent> qk :cprevious<Cr>
nnoremap <silent> <Space>n :bnext<Cr>
nnoremap <silent> <Space>N :bprevious<Cr>

nnoremap s <Nop>
nnoremap q <Nop>
nnoremap Q q
nnoremap ; :
nnoremap : ;

nnoremap <silent> <Space>o :<C-u>cwindow<Cr>
nnoremap <silent> <Space>O :<C-u>cclose<Cr>

" commentary.vim
nmap <Space>c <Plug>CommentaryLine
xmap <Space>c <Plug>Commentary

" surround.vim
let g:surround_{char2nr('k')} = "「\r」"
let g:surround_{char2nr('K')} = "『\r』"
let g:surround_indent = 0

" camelcasemotion
map <silent> w <plug>CamelCaseMotion_w
map <silent> b <plug>CamelCaseMotion_b
map <silent> e <plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

" open current directory with filer
if has('mac')
  nnoremap <silent> <Space>e :<C-u>silent execute ':!open -a Finder %:p:h'<Cr>
elseif has('win32') || has('win64')
  nnoremap <silent> <Space>e :<C-u>silent execute ":!start explorer \"" . g:cps(expand("%:p:h"), "\\") . "\""<Cr>
  " open current directory with Command Prompt
  nnoremap <silent> <Space>E :<C-u>silent execute ":!start cmd /k cd \"" . g:cps(expand("%:p:h"), "\\") . "\""<Cr>
endif

" inspired by ujihisa's. cooool!!
nnoremap <Space>w :<C-u>update<Cr>
nnoremap <Space>q :<C-u>quit<Cr>
nnoremap <Space>W :<C-u>write!<Cr>
nnoremap <Space>Q :<C-u>quit!<Cr>

nnoremap <Space>j <C-f>
nnoremap <Space>k <C-b>

nnoremap <Space>h :<C-u>h<Space>
nnoremap <Space>t :<C-u>tabe<Space>

nnoremap <silent> <Space>_ :<C-u>edit $MYVIMRC<Cr>
nnoremap <silent> <Space>g_ :<C-u>edit $MYGVIMRC<Cr>

nnoremap <silent> <Esc><Esc> <Esc>:<C-u>nohlsearch<Cr>

nnoremap <silent> ,f :<C-u>echo expand('%:p')<Cr>
nnoremap <silent> ,d :<C-u>pwd<Cr>

nnoremap <silent> sh <C-w>h
nnoremap <silent> sk <C-w>k
nnoremap <silent> sl <C-w>l
nnoremap <silent> sj <C-w>j

nnoremap <silent> sn :tabnext<Cr>
nnoremap <silent> sp :tabprevious<Cr>

nnoremap <MiddleMouse> <Nop>
nnoremap <2-MiddleMouse> <Nop>

" preview tag
nnoremap <silent> <Space>p <C-w>}
nnoremap <silent> <Space>P :pclose<Cr>

" vim-endwise support
function! s:CrInInsertModeBetterWay()
  return pumvisible() ? "\<C-y>\<Cr>" : "\<Cr>"
endfunction
inoremap <silent> <Cr> <C-R>=<SID>CrInInsertModeBetterWay()<Cr>

inoremap <silent> ,dt <C-R>=strftime('%Y.%m.%d')<Cr>
inoremap <silent> ,ti <C-R>=strftime('%H:%M')<Cr>
inoremap <silent> ,fn <C-R>=expand('%')<Cr>
" ^J is used to toggle IME
inoremap <silent> <C-j> <Nop>
cnoremap <silent> <C-j> <Nop>

" selected text search
vnoremap * y/<C-R>"<Cr>
vnoremap < <gv
vnoremap > >gv

if executable('tidyp')
  function! s:runTidy(col) range
    " this code is not perfect.
    " tidy's Character encoding option and Vim's fileencoding/encoding is not a pair
    let enc = &l:fileencoding ? &l:fileencoding : &encoding
    let enc = substitute(enc, '-', '', 'g')

    silent execute printf(': %d,%d!tidyp -xml -i -%s -wrap %d -q -asxml', a:firstline, a:lastline, enc, a:col)
  endfunction
endif

let g:xml_tag_completion_map = ''
"}}}


" * abbreviations"{{{
inoreabbr funciton function
inoreabbr requrie require
inoreabbr reuqire require
inoreabbr WinMerege WinMerge
inoreabbr winmerge WinMerge
"}}}


" syntax: vim.vim
let g:vimsyntax_noerror = 1


" * something "{{{
augroup MyAutoCmd
  autocmd!

  autocmd BufReadPost * if !search('\S', 'cnw') | let &l:fileencoding = &encoding | endif
  " restore cursor position
  autocmd BufReadPost * if line("'\"") <= line('$') | execute "normal '\"" | endif
  autocmd BufReadPost * setlocal formatoptions-=o
  " autochdir emulation
  autocmd BufEnter * if expand('%') !~# '^fugitive://' | execute ':lcd ' . escape(expand('%:p:h'), ' ') | endif
  autocmd BufRead,BufNewFile *.ru,Gemfile,Guardfile set filetype=ruby

  autocmd User Rails nnoremap <buffer> <Space>r :<C-u>R

  autocmd FileType slim setlocal makeprg=slimrb\ -c\ %

  " http://vim-users.jp/2009/11/hack96/ {{{
  autocmd FileType *
  \   if &l:omnifunc == ''
  \|   setlocal omnifunc=syntaxcomplete#Complete
  \| endif
  " }}}

  autocmd FileType help,qf nnoremap <buffer> <silent> qq <C-w>c
  autocmd FileType javascript* setlocal omnifunc=javascriptcomplete#CompleteJS

  autocmd FileType rspec compiler rspec
  autocmd FileType rspec setlocal omnifunc=rubycomplete#Complete

  autocmd FileType vim,snippet setlocal tabstop=2 shiftwidth=2 softtabstop=2

  autocmd FileType html,xhtml,xml,xslt,mathml,svg setlocal tabstop=2 shiftwidth=2 softtabstop=2

  autocmd FileType css,sass,scss,less setlocal omnifunc=csscomplete#CompleteCSS tabstop=2 shiftwidth=2 softtabstop=2

  let g:loaded_sql_completion = 1
  autocmd FileType sql*,plsql setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType sql*,plsql nnoremap <buffer> <silent> <C-Return> :DBExecSQLUnderCursor<Cr>
  autocmd FileType sql*,plsql vnoremap <buffer> <silent> <C-Return> :DBExecVisualSQL<Cr>

  let g:sqlutil_align_comma = 1
  let g:sqlutil_align_where = 1
  let g:sqlutil_keyword_case = '\U'
  let g:dbext_default_type = 'ORA'

  if executable('jsl')
    autocmd FileType javascript*,*html setlocal makeprg=jsl\ -conf\ \"$HOME/jsl.conf\"\ -nologo\ -nofilelisting\ -nosummary\ -nocontext\ -process\ %
    autocmd FileType javascript*,*html setlocal errorformat=%f(%l):\ %m
  endif

  autocmd Filetype c set tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype c compiler gcc
  autocmd FileType c setlocal makeprg=gcc\ -Wall\ %\ -o\ %:r.o
  autocmd FileType c nnoremap <buffer> <Space>m :<C-u>write<Cr>:make --std=c99<Cr>

  function! s:moveToSegment(is_prev)
    let flag = a:is_prev ? 'b' : ''
    call search('<\(para\|section\|term\)[^>]*>', 'esW'.flag)
  endfunction
  autocmd FileType xml nnoremap <silent> <buffer> <Tab> :call <SID>moveToSegment(0)<Cr>
  autocmd FileType xml nnoremap <silent> <buffer> <S-Tab> :call <SID>moveToSegment(1)<Cr>
  autocmd FileType xml noremap  <silent> <buffer> <leader>ty :call <SID>runTidy(80)<Cr>
  autocmd BufRead,BufEnter *.xml set updatetime=500
  autocmd BufLeave,BufWinLeave *.xml set updatetime&
augroup END

"}}}


" * plugins "{{{
" plug: vim-ref
let g:ref_refe_cmd = $HOME . '/rubyrefm/refe-1_9_2'

" plug: ctrlp.vim "{{{
let g:ctrlp_map = '<Space>ff'
let g:ctrlp_command = 'CtrlP'
let g:ctrlp_jump_to_buffer = 2
let g:ctrlp_working_path_mode = 2
let g:ctrlp_match_window_bottom = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_highlight_match = [1, 'Constant']
let g:ctrlp_max_files = 5000
let g:ctrlp_max_depth = 20

let g:ctrlp_user_command = {
      \ 'types': {
        \ 1: ['.git/', 'cd %s && git ls-files'],
        \ 2: ['.hg/', 'hg --cwd %s locate -I .'],
        \ },
      \ 'fallback': 'find %s -type f'
      \ }

let g:ctrlp_prompt_mappings = {
	\ 'AcceptSelection("e")': ['<Cr>', '<2-LeftMouse>'],
	\ 'AcceptSelection("h")': ['<C-x>', '<C-Cr>'],
	\ 'AcceptSelection("t")': ['<C-t>', '<MiddleMouse>'],
	\ 'AcceptSelection("v")': ['<C-v>', '<RightMouse>'],
  \ 'PrtSelectMove("j")':   ['<C-n>'],
  \ 'PrtSelectMove("k")':   ['<C-p>'],
  \ 'PrtHistory(-1)':       [''],
  \ 'PrtHistory(1)':        [''],
  \ }

let g:ctrlp_extensions = ['tag', 'buffertag', 'dir', 'thefunks']

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=*/.neocon/*,*/.vimundo/*
set wildignore+=*.mp3,*.aac,*.flac
set wildignore+=*.mp4,*.flv,*.mpg,*.mkv,*.avi,*.wmv,*.mov,*.iso
set wildignore+=.DS_Store

noremap <Space>fb :CtrlPBuffer<Cr>
noremap <Space>ff :CtrlP<Cr>
noremap <Space>fm :CtrlPMRU<Cr>
noremap <Space>ft :CtrlPBufTag<Cr>
noremap <Space>fT :CtrlPBufTagAll<Cr>

command! CtrlPTheFunks call ctrlp#init(ctrlp#thefunks#id())
noremap <Space>fu :CtrlPTheFunks<Cr>
"}}}

" plug: Align
let g:DrChipTopLvlMenu = ''
let g:Align_xstrlen = 0

" plug: prtdialog
let g:prd_fontList  = 'M+1VM+IPAG_circle:h10:cDEFAULT'
let g:prd_fontList .= ',M+2VM+IPAG_circle:h10:cDEFAULT'
let g:prd_fontList .= ',VL_ゴシック:h10:cDEFAULT'
let g:prd_fontList .= ',Takaoゴシック:h10:cDEFAULT'
let g:prd_fontList .= ',Takao明朝:h10:cDEFAULT'
let g:prd_fontList .= ',ＭＳ_明朝:h10:cDEFAULT'

" plug: loga.vim
let g:loga_enable_auto_lookup = 0
map <Space>a <Plug>(loga-lookup)
"}}}

if has('multi_byte_ime') || has('xim')
  set iminsert=0 imsearch=0
  inoremap <silent> <Esc> <Esc>:<C-u>set iminsert=0<Cr>
endif

" * commands {{{
" open loaded buffer with new tab.
command! -nargs=1 -complete=buffer NTab :999tab sbuffer <args>
command! Big wincmd _ | wincmd |

if !exists(':DiffOrig')
  command! DiffOrig
        \ vnew | setlocal buftype=nofile | read# | 0d_ | diffthis | wincmd p | diffthis
endif
" }}}

if filereadable(expand('~/.vimrc.mine'))
  source ~/.vimrc.mine
endif

if has('gui_running') && filereadable(expand('~/.gvimrc'))
  source ~/.gvimrc
end

" __END__ {{{
" vim: ts=2 sts=2 sw=2 fdm=marker

