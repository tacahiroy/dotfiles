" $HOME/.vimrc
" Author: Tacahiroy <tacahiroy```AT```gmail.com>

scriptencoding utf-8

let g:mapleader = ','

" vundle plugin management "{{{
filetype off
set runtimepath& runtimepath+=~/.vim/vundle.git
call vundle#rc()

" Bundle 'avakhov/vim-yaml'
" Bundle 'bbommarito/vim-slim'
Bundle 'glidenote/memolist.vim'
Bundle 'godlygeek/tabular'
Bundle 'jiangmiao/simple-javascript-indenter'
" Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim'
Bundle 'mattn/zencoding-vim'
Bundle 'msanders/snipmate.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'tacahiroy/vim-endwise'
" Bundle 'thinca/vim-quickrun'
Bundle 'thinca/vim-ref'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-fugitive'
Bundle 'hallison/vim-markdown'
" Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'
Bundle 'tyru/open-browser.vim'
Bundle 'vim-ruby/vim-ruby'
" Bundle 'Align'
" Bundle 'IndentAnything'
Bundle 'camelcasemotion'
" Bundle 'increment_new.vim'
Bundle 'matchit.zip'
" Bundle 'DrawIt'

" it seems this has ftdetect problem
" Bundle 'chrisbra/csv.vim'
Bundle 'netrw.vim'

if isdirectory($HOME . '/.vim')
  let $DOTVIM = $HOME . '/.vim'
else
  " MS Windows etc...
  let $DOTVIM = $HOME . '/vimfiles'
endif

if isdirectory(expand('$DOTVIM/sandbox'))
  let dirs = split(glob($DOTVIM.'/sandbox/**/*'))
  for d in dirs
    execute ':set runtimepath+=' . d
    if d =~# '/doc$'
      execute ':helptags ' . d
    endif
  endfor
endif

filetype plugin indent on
"}}}

let s:is_mac = has('macunix')
" I don't use AIX, BSD, HP-UX and any other UNIX
let s:is_linux = !s:is_mac && has('unix')

set cpo&vim

autocmd!

set nocompatible
set verbose=0

" * functions "{{{
" tag information show in command window
function! s:preview_tag_lite(word)
  let t = taglist('^' . a:word . '$')
  let current = expand('%:t')

  for item in t
    if -1 < stridx(item.filename, current)
      " [filename] tag definition
      echohl Search | echomsg printf('%-36s %s', '[' . item.filename . ']', item.cmd) | echohl None
    else
      echomsg printf('%-36s %s', '[' . substitute(item.filename, '\s\s*$', '', '') . ']', item.cmd)
    endif
  endfor
endfunction
command! -nargs=0 PreviewTagLite call s:preview_tag_lite(expand('<cword>'))

" which + chop
function! s:which(cmd)
  let res = system('which ' . a:cmd)
  if v:shell_error
    return ''
  else
    return substitute(res, '\n$', '', '')
  endif
endfunction
"}}}


" I don't need GUI menus
let did_install_default_menus = 1
let did_install_syntax_menu = 1


syntax enable
filetype plugin indent on

set encoding=utf-8
set termencoding=utf-8


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
set backupskip& backupskip+=/tmp/*,/private/tmp/*,*.bac,COMMIT_EDITMSG,hg-editor-*.txt,svn-commit.[0-9]*.tmp
set cedit=
set cmdheight=2
set colorcolumn=80
set noequalalways
set expandtab smarttab
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=unix,dos,mac
set helplang=en,ja
set hidden
set history=10000
set hlsearch
set infercase
set ignorecase
set incsearch
set nojoinspaces
set keywordprg=:help
set linebreak
set linespace=0
set nolist
set listchars=tab:>-,trail:-,extends:>,precedes:<
set laststatus=2
set lazyredraw
set modeline
set modelines=5
set mouse=a
if 702 < v:version
  set relativenumber
else
  set number
endif
set nrformats=hex
set previewheight=8
set pumheight=24
set scroll=0
if s:is_mac
  set shell=/usr/local/bin/zsh
elseif s:is_linux
  set shell=/usr/bin/zsh
endif
set shellslash
set shiftround
set showbreak=>~\ 
set showcmd
set showfulltag
set showmatch matchtime=1
set showtabline=1
set nosplitbelow
set splitright
set smartcase
set spelllang=en
set swapfile directory=$DOTVIM/swaps
set switchbuf=useopen,usetab
set synmaxcol=300
set tags=tags,./tags,**3/tags,tags;/Projects
set title
set titlestring=Vim:\ %F\ %h%r%m
set titlelen=255
set tabstop=2 shiftwidth=2 softtabstop=2
set viminfo='64,<100,s10,n~/.viminfo
set virtualedit=block,onemore
set visualbell
set wildignore=*.exe,*.dll,*.class,*.o,*.obj
set wildmenu
set wildmode=longest:list,full
set nowrapscan

set matchpairs& matchpairs+=<:>
" prevent highlighting a pair of parentheses and brackets
let g:loaded_matchparen = 0

if has('persistent_undo')
  set undodir=~/.vimundo
  augroup UndoFile
    autocmd!
    autocmd BufReadPre ~/* setlocal undofile
  augroup END
endif

" gVim specific
if has('gui_running')
  set columns=132
  set guioptions=aeciM
  set guitablabel=%N)\ %f
  set lines=100
  set mousehide
  set nomousefocus

  if &guioptions =~# 'M'
    let &guioptions = substitute(&guioptions, '[mT]', '', 'g')
  endif

  if s:is_mac
    set guifont=Migu\ 1M\ Regular:h13
    set antialias
    set fuoptions& fuoptions+=maxhorz
  elseif s:is_linux
    set guifont=M+1VM+IPAG\ circle\ 10
  else
    " Windows
    set guifont=M+1VM+IPAG_circle:h10:cDEFAULT
  endif

  if has('printer')
    let &printfont = &guifont
  endif
endif

set t_Co=256
set background=light
colorscheme seashell

set formatoptions& formatoptions+=mM formatoptions-=r

let &statusline = '[#%n]%<%#FileName#%f%* %m%r%h%w'
" let &statusline .= '%{&filetype.":".(&l:fileencoding != "" ? &l:fileencoding : &encoding).":".&fileformat}'
let &statusline .= '%{&filetype}:'
let &statusline .= '%{(&l:fileencoding != "" ? &l:fileencoding : &encoding).":".&fileformat}'
let &statusline .= '(%{&expandtab ? "" : ">"}%{&l:tabstop}'
let &statusline .= '%{search("\\t", "cnw") ? "<" : ""})'
let &statusline .= '%{(empty(&mouse) ? "" : "m")}'
let &statusline .= '%{(&paste ? "p" : "")}'
let &statusline .= '%{(&list ? "l" : "")}'
let &statusline .= '%{(empty(&clipboard) ? "" : "c")} '
let &statusline .= '%#Function#%{fugitive#statusline()}%*'
let &statusline .= ' %=%{Gps()}'
let &statusline .= '%-12( %l/%LL,%c %)%P'

function! s:shorten_path(path, ratio)
  if !empty(&buftype)
    return ''
  endif

  let path = substitute(a:path, $HOME, '~', '')

  if 3 < len(split(path, '/'))
    return join(split(path, '/')[-3:-1], '/')
  else
    return path
  endif
endfunction

function! Gps()
  return '(' . s:shorten_path(getcwd(), 25) . ')'
endfunction
" }}}


" * map "{{{
" Emacs rules!
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-d> <Del>
cnoremap <C-o> <C-d>

nnoremap s <Nop>
nnoremap q <Nop>
nnoremap Q q

nnoremap Y y$
nnoremap j gj
nnoremap k gk

" selection
nnoremap vv <C-v>
nnoremap vo vg_
nnoremap vO ^vg_

nnoremap <Return> :<C-u>call append(line('.'), '')<Cr>

nnoremap <C-]> <C-]>zz
nnoremap <C-t> <C-t>zz

nnoremap * *N
nnoremap # #N

nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

nnoremap <silent> qj :cnext<Cr>
nnoremap <silent> qk :cprevious<Cr>

nnoremap <silent> qo :<C-u>silent call <SID>toggle_qf_list()<Cr>

function! s:toggle_qf_list()
  let bufs = s:redir('buffers')
  let l = matchstr(split(bufs, '\n'), '[\t ]*\d\+[\t ]\+.\+[\t ]\+"\[Quickfix\ List\]"')

  let winnr = -1
  if !empty(l)
    let bufnbr = matchstr(l, '[\t ]*\zs\d\+\ze[\t ]\+')
    let winnr = bufwinnr(str2nr(bufnbr, 10))
  endif

  if !empty(getqflist())
    if winnr == -1
      copen
    else
      cclose
    endif
  endif
endfunction

function! s:redir(cmd)
  redir => res
  execute a:cmd
  redir END

  return res
endfunction

nnoremap <silent> <Leader>tm :let &mouse = empty(&mouse) ? 'a' : ''<Cr>
nnoremap <silent> <Leader>tp :set paste!<Cr>
nnoremap <silent> <Leader>tl :set list!<Cr>
nnoremap <silent> <Leader>tc :let &clipboard =
      \ empty(&clipboard) ? 'unnamed,unnamedplus' : ''<Cr>

" commentary.vim
nmap <Space>c <Plug>CommentaryLine
xmap <Space>c <Plug>Commentary

" surround.vim
let g:surround_{char2nr('k')} = "「\r」"
let g:surround_{char2nr('K')} = "『\r』"
xmap c <Plug>VSurround

" camelcasemotion
map <silent> w <plug>CamelCaseMotion_w
map <silent> b <plug>CamelCaseMotion_b
map <silent> e <plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e

" open current directory with filer
if s:is_mac
  nnoremap <silent> <Space>e
        \ :<C-u>silent execute '!open -a Finder %:p:h'<Cr>:redraw!<Cr>
elseif s:is_linux
  nnoremap <silent> <Space>e
        \ :<C-u>silent execute '!nautilus %:p:h &'<Cr>:redraw!<Cr>
endif

nnoremap <Space>w :<C-u>update<Cr>
nnoremap <Space>q :<C-u>quit<Cr>
nnoremap <Space>W :<C-u>update!<Cr>
nnoremap <Space>Q :<C-u>quit!<Cr>

nnoremap <C-h> :<C-u>h<Space>
nnoremap <Space>t :<C-u>tabe<Space>
nnoremap s<Space> i<Space><Esc>

nnoremap <silent> <Space>_ :<C-u>edit $MYVIMRC<Cr>
nnoremap <silent> <Space>g_ :<C-u>edit $MYGVIMRC<Cr>
nnoremap <Space>S :<C-u>source %<Cr>

nnoremap <Leader>nn :<C-u>NERDTreeToggle<Cr>
nnoremap <Leader>nf :<C-u>NERDTreeFind<Cr>zz<C-w><C-w>

nnoremap <silent> <Esc><Esc> <Esc>:<C-u>nohlsearch<Cr>

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

" Ctrl-H dispution
" set t_kb=<Bs>
" set t_kD=<Del>
" inoremap <Del> <Bs>

inoremap <silent> <Leader>dd <C-R>=strftime('%Y-%m-%d')<Cr>
inoremap <silent> <Leader>tm <C-R>=strftime('%H:%M')<Cr>
inoremap <silent> <Leader>fn <C-R>=@%<Cr>

" used to toggle IME
inoremap <silent> <C-j> <Nop>
cnoremap <silent> <C-j> <Nop>
inoremap <silent> <C-l> <Nop>
cnoremap <silent> <C-l> <Nop>

" selected text search
vnoremap * y/<C-R>"<Cr>
vnoremap < <gv
vnoremap > >gv

vnoremap <Down> :call <SID>move_block('d')<Cr>==gv
vnoremap <Up> :call <SID>move_block('u')<Cr>==gv

function! s:move_block(d) range
  let cnt = a:lastline - a:firstline

  if a:d ==# 'u'
    let sign = '-'
    let cnt = 2
  else
    let sign = '+'
    let cnt += 1
  endif

  execute printf('%d,%dmove%s%d', a:firstline, a:lastline, sign, cnt)
endfunction

if executable('tidyp')
  function! s:run_tidy(...) range
    " this code is not perfect.
    " tidy's Character encoding option and Vim's fileencoding/encoding is not a pair
    let col = get(a:, 1, 80)
    let enc = &l:fileencoding ? &l:fileencoding : &encoding
    let enc = substitute(enc, '-', '', 'g')

    silent execute printf(': %d,%d!tidyp -xml -i -%s -wrap %d -q -asxml', a:firstline, a:lastline, enc, eval(col))
  endfunction

  command! -nargs=? -range Tidy <line1>,<line2>call s:run_tidy(<args>)
endif
"}}}


" syntax: vim.vim
let g:vimsyntax_noerror = 1


" * something "{{{
augroup Tacahiroy
  autocmd!

  autocmd BufReadPost * if !search('\S', 'cnw') | let &l:fileencoding = &encoding | endif
  " restore cursor position
  autocmd BufReadPost * if line("'\"") <= line('$') | execute "normal '\"" | endif
  autocmd BufEnter * setlocal formatoptions-=o

  " autochdir emulation
  autocmd BufEnter * call s:auto_chdir(6)

  function! s:get_project_root(dir, depth)
    let i = 0
    let dir = a:dir

    while i < a:depth
      let dirs = split(dir, '/')
      if !exists('midx')
        let midx = len(dirs)
      endif

      let idx = midx - i
      if idx < 0
        break
      endif

      let dir = '/'.join(dirs[0:idx], '/')
      let files = ['Gemfile', 'Rakefile', 'README.mkd', 'README.md', 'README.markdown', 'README.rdoc']
      for f in files
        if filereadable(dir.'/'.f)
          return dir
        endif
      endfor
      let i += 1
    endwhile

    return a:dir
  endfunction

  function! s:auto_chdir(n)
    if expand('%') =~# '^\S\+://'
      return
    endif

    let dir = s:get_project_root(expand('%:p:h'), 5)

    execute ':lcd ' . escape(dir, ' ')
  endfunction

  autocmd BufRead,BufNewFile *.ru,Gemfile,Guardfile set filetype=ruby
  autocmd BufRead,BufNewFile ?zshrc,?zshenv set filetype=zsh

  augroup PersistentUndo
    autocmd BufWritePre COMMIT_EDITMSG setlocal noundofile
    autocmd BufWritePre *.bak *.bac setlocal noundofile
    autocmd BufWritePre knife-edit-*.js setlocal noundofile
  augroup END

  autocmd User Rails nnoremap <buffer> <Space>r :<C-u>R

  autocmd FileType mail set spell
  autocmd FileType slim setlocal makeprg=slimrb\ -c\ %

  autocmd BufRead,BufNewFile *.applescript,*.scpt setfiletype applescript
  autocmd FileType applescript set commentstring=#\ %s

  autocmd FileType help,qf,logaling,ref-* nnoremap <buffer> <silent> qq <C-w>c
  autocmd FileType javascript* set omnifunc=javascriptcomplete#CompleteJS

  autocmd FileType rspec compiler rspec
  autocmd FileType rspec set omnifunc=rubycomplete#Complete
  autocmd FileType *ruby,rspec :execute 'setlocal iskeyword+=' . char2nr('?')
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4

  autocmd FileType vim,snippet setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType vim :execute 'set iskeyword+=' . char2nr(':')

  autocmd FileType html,xhtml,xml,xslt,mathml,svg setlocal tabstop=2 shiftwidth=2 softtabstop=2

  autocmd FileType css,sass,scss,less setlocal omnifunc=csscomplete#CompleteCSS tabstop=2 shiftwidth=2 softtabstop=2

  " let g:loaded_sql_completion = 1
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

  " Chef
  autocmd BufRead knife-edit-*.js set filetype=javascript.json

  autocmd FileType javascript.json setlocal makeprg=ruby\ $HOME/bin/jsonv.rb\ %

  autocmd Filetype c setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype c compiler gcc
  autocmd FileType c setlocal makeprg=gcc\ -Wall\ %\ -o\ %:r.o
  autocmd FileType c nnoremap <buffer> <Space>m :<C-u>write<Cr>:make --std=c99<Cr>

  autocmd FileType markdown inoremap <buffer> <Leader>h1 <Esc>10i=<Esc>^
                         \| inoremap <buffer> <Leader>h2 <Esc>10i-<Esc>^
                         \| inoremap <buffer> <Leader>h3 <Esc>I###<Space>
                         \| inoremap <buffer> <Leader>h4 <Esc>I####<Space>
                         \| inoremap <buffer> <Leader>h5 <Esc>I#####<Space>
                         \| inoremap <buffer> <Leader>hr <Esc>i- - -<Esc>^
  autocmd FileType markdown set autoindent

  " easy way
  if executable('markdown')
    function! s:md_preview_by_browser(f)
      let tmp = '/tmp/vimmarkdown.html'
      call system('markdown ' . a:f . ' > ' . tmp)
      call system('open ' . tmp)
    endfunction
    autocmd FileType markdown command! -buffer -nargs=0 MdPreview call s:md_preview_by_browser(expand('%'))
  endif

  " only for the WinMerge document translation project
  function! s:move_to_segment(is_prev)
    let flag = a:is_prev ? 'b' : ''
    call search('<\(para\|section\|term\)[^>]*>', 'esW'.flag)
  endfunction

  autocmd FileType xml nnoremap <silent> <buffer> <Tab> :call <SID>move_to_segment(0)<Cr>
  autocmd FileType xml nnoremap <silent> <buffer> <S-Tab> :call <SID>move_to_segment(1)<Cr>
  autocmd FileType xml noremap  <silent> <buffer> <Leader>a :call <SID>run_tidy(80)<Cr>
  autocmd BufRead,BufEnter *.xml set updatetime=1000
  autocmd BufLeave,BufWinLeave *.xml set updatetime&

  autocmd BufRead,BufNewFile * syn match ExtraSpaces '[\t ]\+$'
  hi def link ExtraSpaces Error

  inoreabbr funciton function
  inoreabbr requrie require
  inoreabbr reuqire require
  inoreabbr passowrd password
  inoreabbr WinMerege WinMerge
  inoreabbr Winmerge WinMerge
  inoreabbr ture true
augroup END
"}}}


" * plugins "{{{
" plug: vim-ref
let g:ref_refe_cmd = $HOME . '/Projects/wk/rubyrefm/refe-1_9_2'

" plug: ctrlp.vim "{{{
let g:ctrlp_map = '<Space>ff'
let g:ctrlp_command = 'CtrlPRoot'
let g:ctrlp_jump_to_buffer = 2
let g:ctrlp_working_path_mode = 2
let g:ctrlp_match_window_bottom = 1
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_height = 20
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_highlight_match = [1, 'Constant']
let g:ctrlp_max_files = 12800
let g:ctrlp_max_depth = 24
let g:ctrlp_dotfiles = 1

let g:ctrlp_user_command = {
  \ 'types': {
    \ 1: ['.git/', 'cd %s && git ls-files'],
    \ 2: ['.hg/', 'hg --cwd %s locate -I .'],
    \ 3: ['.svn/', 'svn ls file://%s'],
  \ }
\ }

let g:ctrlp_prompt_mappings = {
  \ 'AcceptSelection("e")': ['<Cr>'],
  \ 'AcceptSelection("h")': ['<C-x>'],
  \ 'AcceptSelection("t")': ['<C-t>', '<C-Cr>'],
  \ 'AcceptSelection("v")': ['<C-v>'],
  \ 'PrtSelectMove("j")':   ['<C-n>'],
  \ 'PrtSelectMove("k")':   ['<C-p>'],
  \ 'PrtHistory(-1)':       ['<Up>'],
  \ 'PrtHistory(1)':        ['<Down>'],
  \ 'CreateNewFile()':      ['<C-y>'],
  \ }

let g:ctrlp_extensions = ['line', 'buffertag', 'dir', 'mixed', 'funky']

let dir = ['\.git$', '\.hg$', '\.svn$', '\.vimundo$', '\.ctrlp_cache/',
      \    '\.rbenv/', '\.gem/', 'backup$', 'Downloads$', $TMPDIR]
let g:ctrlp_custom_ignore = {
  \ 'dir': join(dir, '\|'),
  \ 'file': '\v(\.exe\|\.so\|\.dll\|\.DS_Store\|\.db)$',
  \ }

nnoremap <Space>fl :CtrlPBuffer<Cr>
nnoremap <Space>fd :CtrlPCurWD<Cr>
nnoremap <Space>fm :CtrlPMRU<Cr>
nnoremap <Space>li :CtrlPLine<Cr>
nnoremap <Space>fk :CtrlPBookmarkDir<Cr>
nnoremap <Space>fo :execute 'CtrlP ' . $chef . '/cookbooks/_default'<Cr>
nnoremap <Space>fw :execute 'CtrlP ' . expand('%:p:h')<Cr>

nnoremap <Space>fu :CtrlPFunky<Cr>
"}}}

" plug: memolist.vim " {{{
let g:memolist_path = expand('~/Projects/memo')
let g:memolist_memo_suffix = 'md'
let g:memolist_memo_date = '%Y-%m-%d %H:%M'
let g:memolist_prompt_tags = 1
let g:memolist_prompt_categories = 0
let g:memolist_qfixgrep = 0
let g:memolist_vimfiler = 0

nnoremap <Space>mc :MemoNew<Cr>
nnoremap <Space>mg :MemoGrep<Cr>
nnoremap <Space>mL :MemoList<Cr>
nnoremap <Space>ml :execute 'CtrlP ' . g:memolist_path<Cr><F5>
" }}}

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

" plug: openbrowser.vim
let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)

" plug: loga.vim
let g:loga_executable = s:which('loga')
let g:loga_enable_auto_lookup = 0
let g:loga_delimiter = '=3'
map  <Space>a <Plug>(loga-lookup)
autocmd FileType logaling imap <buffer> <Leader>v <Plug>(loga-insert-delimiter)

" plug: timetap.vim
let g:timetap_accept_path_pattern = '^~/\%(\..\+$\|Projects\)'
let g:timetap_ignore_path_pattern = '\(/a\+\.\w\+$\|/\.git/\|tags\|tags-.+\|NERD_tree_.\+$\)'
let g:timetap_is_sort_base_today = 1
let g:timetap_is_display_zero = 1
let g:timetap_is_debug = 0
let g:timetap_display_limit = 15
let g:timetap_observe_cursor_position = 1
"}}}

if has('multi_byte_ime') || has('xim')
  set iminsert=0 imsearch=0
  inoremap <silent> <Esc> <Esc>:<C-u>set iminsert=0<Cr>
endif

" {{{
" open a loaded buffer with new tab
command! -nargs=1 -complete=buffer NTab :999tab sbuffer <args>
command! Big wincmd _ | wincmd |

" Chef
if executable('knife')
  function! s:upload_cookbook(...) abort
    let path = expand('%:p')
    if path !~# '/cookbooks/[^/]\+/.\+'
      return
    endif

    let cookbooks = [get(a:, 1, '')]
    let m = matchlist(path, '^\(.\+/cookbooks/[^/]\+\)/\([^/]\+\)/')
    let cb_path = m[1]
    if index(cookbooks, m[2]) == -1
      call insert(cookbooks, m[2])
    endif

    if 0 < len(cookbooks)
      let cookbooks = filter(cookbooks, 'isdirectory(cb_path."/".v:val)')
      let mes = 'Uploading cookbook' . (1 < len(cookbooks) ? 's' : '')
      let cmd = printf('knife cookbook upload -o %s %s', cb_path, join(cookbooks, ' '))

      echomsg printf('%s: %s', mes, join(cookbooks, ' '))

      call s:tmux.run(cmd, 1, 1)
      " execute ':!' . cmd
    else
      echoerr 'no cookbooks are found.'
    endif
  endfunction

  command! -nargs=* CCookbookUpload call s:upload_cookbook(<f-args>)
  nnoremap <Space>U :<C-u>CCookbookUpload<Cr>
endif

" tmux: just send keys against tmux
let s:tmux = {}
let s:tmux.last_cmd = ''

function! s:tmux.is_installed()
  call system('which tmux')
  return v:shell_error == 0
endfunction

function! s:tmux.is_running()
  call system('tmux ls -F "#{session_name}:#{session_attached}" | grep :1')
  return v:shell_error == 0
endfunction

function! s:tmux.run(cmd, ...)
  let split = get(a:, 1, 0)
  let run_in_vim = get(a:, 2, 0)
  let is_control = (a:cmd =~# '^\^[a-zA-Z]$')

  if !is_control
    let self.last_cmd = a:cmd
  endif

  if self.is_running()
    if split
      let res = system(printf('tmux splitw -v "%s"', a:cmd))
      if v:shell_error
        echomsg res
      endif
    else
      let enter = (is_control ? '' : 'Enter')
      call system(printf('`tmux send "%s" %s`', a:cmd, enter))
    endif
  elseif run_in_vim
    execute ':!' . a:cmd
  else
    echohl ErrorMsg | echo 'ERR: tmux is not running' | echohl NONE
    return
  endif
endfunction

function! s:tmux.operate(cmd)
  if self.is_running()
    call system(printf('`tmux "%s"`', a:cmd))
  else
    echohl ErrorMsg | echo 'ERR: tmux is not running' | echohl NONE
    return
  endif
endfunction

if s:tmux.is_installed()
  command! -nargs=+ TMRun call s:tmux.run(<q-args>)
  command! -nargs=0 TMInt call s:tmux.run('^C')
  command! -nargs=0 TMClear call s:tmux.run('^L')
  command! -nargs=0 TMRunAgain echo s:tmux.last_cmd | call s:tmux.run(s:tmux.last_cmd)
  command! -nargs=0 TMNextWindow call s:tmux.operate('next-window')
  command! -nargs=0 TMPrevWindow call s:tmux.operate('previous-window')

  nnoremap <Leader>r :<C-u>TMRun<Space>
  nnoremap <Leader>! :<C-u>TMRunAgain<Cr>
  nnoremap <Leader>c :<C-u>TMInt<Cr>
  nnoremap <Leader>> :<C-u>TMNextWindow<Cr>
  nnoremap <Leader>< :<C-u>TMPrevWindow<Cr>
endif
" }}}


if filereadable(expand('~/.vimrc.mine'))
  source ~/.vimrc.mine
endif

" __END__ {{{
" vim: ts=2 sts=2 sw=2

