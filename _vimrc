" $HOME/.vimrc
" Maintainer: tacahiroy <tacahiroy```AT```gmail.com>

scriptencoding utf-8

" vundle plugin management "{{{
filetype off
set runtimepath+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'

Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-commentary'
Bundle 'msanders/snipmate.vim'
" Bundle 'mattn/zencoding-vim'
Bundle 'Shougo/neocomplcache'

Bundle 'tacahiroy/vim-endwise'

Bundle 'msanders/cocoa.vim'
Bundle 'thinca/vim-quickrun'
Bundle 'thinca/vim-ref'
Bundle 'tpope/vim-rails'
Bundle 'kchmck/vim-coffee-script'
Bundle 'VimClojure'
Bundle 'jiangmiao/simple-javascript-indenter'
Bundle 'avakhov/vim-yaml'

Bundle 'L9'
Bundle 'matchit.zip'
" Bundle 'IndentAnything'
Bundle 'Align'
" Bundle 'project.tar.gz'
Bundle 'camelcasemotion'

" Bundle 'increment_new.vim'
" Bundle 'colorsel.vim'

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

set nocompatible
set verbose=0


" * functions "{{{1
" convert path separator
" unix <-> dos
function! g:cps(path, style)"{{{
  let styles = {'dos':  ['/', '\'],
        \       'unix': ['\', '/']}

  if has_key(styles, a:style)
    return substitute(a:path, styles[a:style][0], styles[a:style][1], 'g')
  else
    return a:path
  endif
endfunction"}}}


" tag information show in command window
function! s:previewTagLight(word)"{{{
  let t = taglist('^' . a:word . '$')
  let current = expand('%:t')

  for item in t
    if -1 < stridx(item.filename, current)
      " [filename] tag definition
      echohl Search | echomsg printf('%-36s %s', '[' . g:cps(item.filename, 'unix') . ']', item.cmd) | echohl None
    else
      echomsg printf('%-36s %s', '[' . substitute(g:cps(item.filename, 'unix'), '\s\s*$', '', '') . ']', item.cmd)
    endif
  endfor
endfunction"}}}


if executable('ruby') "{{{2 RubyInstantExec
  " RubyInstantExec
  " preview interpreter's output(Tip #1244) improved
  function! s:RubyInstantExec() range
    let buf_name = 'RubyInstantExec Result'
    let tmp = 'vimrie.tmp'

    " put current buffer's content in a temp file
    silent execute printf(':%d,%dw! >> %s', a:firstline, a:lastline, tmp)

    " open the preview window
    silent execute ':pedit! ' . escape(buf_name, '\ ')
    " change to preview window
    wincmd P

    setlocal buftype=nofile
    setlocal noswapfile
    setlocal syntax=none
    setlocal bufhidden=delete

    " replace current buffer with ruby's output
    silent execute printf(':%%!ruby %s 2>&1', tmp)
    " change back to the source buffer
    wincmd p

    call delete(tmp)
  endfunction

  nmap <silent> <Space>R mzggVG:call <SID>RubyInstantExec()<Cr>'z:delm z<Cr>
  nmap <silent> <Space>r :call <SID>RubyInstantExec()<Cr>
  vmap <silent> <Space>r :call <SID>RubyInstantExec()<Cr>
endif
"}}}
"}}}


" GUI menu is not necessary. "{{{
let did_install_default_menus = 1
let did_install_syntax_menu = 1
"}}}

syntax enable
filetype plugin indent on

if has('unix') || has('macunix')
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
set novisualbell
set wildignore=*.exe,*.dll,*.class,*.o,*.obj
set wildmenu
set wildmode=list:longest
set nowrapscan

if has("persistent_undo")
  set undodir=~/.vimundo
  augroup UndoFile
    autocmd!
    autocmd BufReadPre ~/* setlocal undofile
  augroup END
endif

if !has("gui_running")
  "set t_Co=256
  colorscheme summerfruit256
endif

set formatoptions& formatoptions+=mM formatoptions-=r

" statusline {{{2
" [#bufnr]filename [modified?][enc:ff][filetype]
let &statusline = "[#%n]%<%f %m%r%h%w%y"
let &statusline .= "[%{(&l:fileencoding != '' ? &l:fileencoding : &encoding).':'.&fileformat}]"
let &statusline .= "(%{&expandtab ? '' : '>'}%{&l:tabstop})"
let &statusline .= "%#Underlined#%{fugitive#statusline()}%*"
" monstermethod.vim support
let &statusline .= "%{exists('b:mmi.name') && 0<len(b:mmi.name) ? ' -- '.b:mmi.name.'('.b:mmi.lines.')' : ''}"
let &statusline .= "%=%-16(\ %l/%LL,%c\ %)%P"
" }}}

set matchpairs& matchpairs+=<:>
let g:loaded_matchparen = 0
"highlight! MatchParen term=reverse ctermbg=LightRed gui=NONE guifg=fg guibg=LightRed
" }}}


" * map "{{{
" ummmmm like Emacs
" cmdline editing
cnoremap <C-o> <C-q>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>

nnoremap Y y$
nnoremap j gj
nnoremap k gk
nnoremap vv <C-v>
nmap [visual-row-without-eol] 0v$ho
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

nnoremap <silent> <Space>o :cwindow<Cr>
nnoremap <silent> <Space>ta :call <SID>previewTagLight(expand('<cword>'))<Cr>

nnoremap <silent> ,<< dT>
nnoremap <silent> ,>> dt<

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
  nnoremap <silent> <Space>e :<C-u>silent execute ":!open -a Finder %:p:h"<Cr>
elseif has('win32') || has('win64')
  nnoremap <silent> <Space>e :<C-u>silent execute ":!start explorer \"" . g:cps(expand("%:p:h"), "dos") . "\""<Cr>
  " open current directory with Command Prompt
  nnoremap <silent> <Space>E :<C-u>silent execute ":!start cmd /k cd \"" . g:cps(expand("%:p:h"), "dos") . "\""<Cr>
endif

" inspired by ujihisa's. cooool!!
nnoremap <Space>w :<C-u>write<Cr>
nnoremap <Space>q :<C-u>quit<Cr>
nnoremap <Space>W :<C-u>write!<Cr>
nnoremap <Space>Q :<C-u>quit!<Cr>

nnoremap <Space>j <C-f>
nnoremap <Space>k <C-b>

nnoremap <Space>h :<C-u>h 

nnoremap <silent> <Space>_ :<C-u>edit $MYVIMRC<Cr>
nnoremap <silent> <Space>s_ :<C-u>source $MYVIMRC<Cr>

nnoremap <silent> <Esc><Esc> <Esc>:<C-u>nohlsearch<Cr>

nnoremap <silent> g<C-f> :<C-u>echo expand('%:p')<Cr>

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
  return pumvisible() ? neocomplcache#close_popup()."\<Cr>" : "\<Cr>"
endfunction
inoremap <silent> <Cr> <C-R>=<SID>CrInInsertModeBetterWay()<Cr>

inoremap <silent> ,dt <C-R>=strftime('%Y.%m.%d')<Cr>
inoremap <silent> ,ti <C-R>=strftime('%H:%M')<Cr>
inoremap <silent> ,fn <C-R>=expand('%')<Cr>

" selected text search
vnoremap * y/<C-R>"<Cr>
vnoremap < <gv
vnoremap > >gv

if executable('tidy')
  vnoremap <leader>ty :<C-u>!tidy -xml -i -shiftjis -wrap 0 -q -asxml<Cr>
  nnoremap <leader>ty :<C-u>1,$!tidy -xml -i -shiftjis -wrap 0 -q -asxml<Cr>
endif

let g:xml_tag_completion_map = ''
"}}}


" * abbreviations"{{{
inoreabbr funciton function
inoreabbr requrie require
inoreabbr reuqire require
"}}}


" syntax: vim.vim
let g:vimsyntax_noerror = 1

" * something "{{{
augroup MySomething
  autocmd!

  autocmd BufReadPre * let g:updtime = &l:updatetime
  autocmd BufReadPost * if !search('\S', 'cnw') | let &l:fileencoding = &encoding | endif
  " restore cursor position
  autocmd BufReadPost * if line("'\"") <= line('$') | execute "normal '\"" | endif
  autocmd BufReadPost * setlocal formatoptions-=o
  " autochdir emulation
  autocmd BufEnter * if expand('%') !~# '^fugitive://' | execute ':lcd ' . escape(expand('%:p:h'), ' ') | endif
  autocmd BufRead,BufNewFile *.js set filetype=javascript.jquery
  autocmd BufLeave,BufWinLeave * if exists('g:updtime') | let &l:updatetime = g:updtime | endif
augroup END


augroup MyAutoCmd
  autocmd!

  " http://vim-users.jp/2009/11/hack96/ {{{
  autocmd FileType *
  \   if &l:omnifunc == ''
  \|   setlocal omnifunc=syntaxcomplete#Complete
  \| endif
  " }}}

  " like less
  autocmd FileType help
        \  nnoremap <buffer> <silent> q <C-w>c
        \| nnoremap <buffer> <silent> d <C-f>
        \| nnoremap <buffer> <silent> u <C-b>
  autocmd FileType qf nnoremap <buffer> <silent> q <C-w>c
  autocmd FileType javascript* setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType ruby,rspec let &path .= "," . g:cps($RUBYLIB, 'unix')

  " inspired by ujihisa's
  autocmd FileType irb inoremap <buffer> <silent> <Cr> <Esc>:<C-u>ruby v=VIM::Buffer.current;v.append(v.line_number, '#=> ' + eval(v[v.line_number]).inspect)<Cr>jo
  nnoremap <Space>irb :<C-u>new<Cr>:setfiletype irb<Cr>

  autocmd FileType rspec
  \  compiler rspec
  \| setlocal omnifunc=rubycomplete#Complete

  autocmd FileType vim,snippet setlocal tabstop=2 shiftwidth=2 softtabstop=2

  autocmd FileType html*,xhtml,xml,xslt,mathml,svg
  \  setlocal tabstop=2 shiftwidth=2 softtabstop=2

  let g:xml_no_auto_nesting = 1
  let g:xml_use_xhtml = 1
  let g:xml_tag_completion_map = ''

  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS tabstop=2 shiftwidth=2 softtabstop=2

  let g:loaded_sql_completion = 1
  autocmd FileType sql*,plsql
  \  setlocal tabstop=4 shiftwidth=4 softtabstop=4
  \| nnoremap <buffer> <silent> <C-Return> :DBExecSQLUnderCursor<Cr>
  \| vnoremap <buffer> <silent> <C-Return> :DBExecVisualSQL<Cr>

  let g:sqlutil_align_comma = 1
  let g:sqlutil_align_where = 1
  let g:sqlutil_keyword_case = '\U'
  let g:dbext_default_type = 'ORA'

  if executable("jsl")
    autocmd FileType javascript,javascript.jquery,html,xhtml
    \  setlocal makeprg=jsl\ -conf\ \"$HOME/jsl.conf\"\ -nologo\ -nofilelisting\ -nosummary\ -nocontext\ -process\ %
    \| setlocal errorformat=%f(%l):\ %m
  endif

  autocmd Filetype c,cpp set tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype c,cpp compiler gcc
  autocmd Filetype c,cpp setlocal makeprg=gcc\ -Wall\ %\ -o\ %:r.o
  autocmd Filetype c,cpp nmap <buffer> <Space>m :<C-u>write<Cr>:make --std=c99<Cr>
augroup END
"}}}


" * plugins "{{{
" plug: vim-ref
let g:ref_refe_cmd = $HOME . "/rubyrefm/refe-1_9_2"

" plug: VimClojure
let vimclojure#HighlightBuiltins = 1
let vimclojure#ParenRainbow = 1
let vimclojure#FuzzyIndent = 1
let vimclojure#HighlightContrib = 1
let vimclojure#DynamicHighlighting = 1
" Nailgun
let vimclojure#WantNailgun = 1
let vimclojure#NailgunClient = $HOME . "/Projects/wk/vimclojure.hg/client/ng"
let vimclojure#NailgunServer = "127.0.0.1"
let vimclojure#NailgunPort = "2113"


" plug: NeocomplCache {{{
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_auto_select = 0
let g:neocomplcache_enable_display_parameter = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_disable_caching_file_path_pattern = '\(\.vimprojects\|\*unite\*\|\[Scratch\]\|\[BufExplorer\]\|\.vba\|\.aspx\)'
let g:neocomplcache_min_keyword_length = 2
let g:neocomplcache_min_syntax_length = 2

let g:neocomplcache_snippets_dir = expand("$DOTVIM/bundle/snipmate.vim/snippets")

if has('win32') || has('win64')
  let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default':  $DOTVIM.'/dict/gene.txt',
      \ 'rb':       $DOTVIM.'/dict/n.dict',
      \ 'sql':      $DOTVIM.'/dict/n.dict',
      \ 'vbnet':    $DOTVIM.'/dict/n.dict',
      \ 'vb':       $DOTVIM.'/dict/n.dict',
      \ }
endif

let g:neocomplcache_plugin_completion_length_list = {
  \ 'snipMate_complete':  1,
  \ 'buffer_complete':    1,
  \ 'include_complete':   2,
  \ 'syntax_complete':    2,
  \ 'filename_complete':  2,
  \ 'keyword_complete':   2,
  \ 'omni_complete':      1,
  \ }

let g:neocomplcache_include_paths = {
  \ 'vbnet': '.',
  \ }

let g:neocomplcache_include_exprs = {
  \ 'ruby': 'substitute(v:fname,''\\.'',''/'',''g'')',
  \ }

let g:neocomplcache_include_patterns = {
  \ 'ruby': '^require',
  \ 'perl': '^use',
  \ }

if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.perl = '[^. *\t]\.\w*\|\h\w*::'

inoremap <expr> <C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
inoremap <expr> <C-l> &filetype == 'vim' ? "\<C-x><C-v><C-p>" : neocomplcache#manual_omni_complete()
" }}}

" plug: ctrlp.vim "{{{
let g:ctrlp_map = '<Space>ff'
let g:ctrlp_jump_to_buffer = 2
let g:ctrlp_working_path_mode = 2
let g:ctrlp_match_window_bottom = 0
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_highlight_match = [1, 'Constant']

let g:ctrlp_user_command = ['.git/', 'cd %s && git ls-files']
let g:ctrlp_user_command = ['.hg/', 'hg --cwd %s locate --fullpath -I .']

let g:ctrlp_prompt_mappings = {
  \ 'PrtSelectMove("j")': ['<C-n>'],
  \ 'PrtSelectMove("k")': ['<C-p>'],
  \ 'PrtHistory(-1)':     [''],
  \ 'PrtHistory(1)':      [''],
  \ }

set wildignore+=*/.git/*,*/.hg/*,*/.svn/*
set wildignore+=*/.neocon/*,*/.vimundo/*
set wildignore+=*.mp3,*.aac,*.flac
set wildignore+=*.mp4,*.flv,*.mpg,*.mkv,*.avi,*.wmv,*.mov,*.iso

noremap <Space>fb :CtrlPBuffer<Cr>
noremap <Space>ff :CtrlP<Cr>
noremap <Space>fm :CtrlPMRU<Cr>
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

" plug: project.vim
let g:proj_flags = "St"
"}}}

if has('multi_byte_ime') || has('xim')
  set iminsert=0 imsearch=0
  imap <silent> <Esc> <Esc>:<C-u>set iminsert=0<Cr>
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

set runtimepath+=$DOTVIM/sandbox

" __END__ {{{
" vim: ts=2 sts=2 sw=2 fdm=marker

