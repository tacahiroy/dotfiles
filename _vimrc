" $HOME/.vimrc
" Author: Tacahiroy <tacahiroy```AT```gmail.com>

scriptencoding utf-8

" vundle plugin management "{{{
filetype off
set runtimepath& runtimepath+=~/.vim/bundle/vundle
call vundle#rc()

Bundle 'gmarik/vundle'

" Bundle 'altercation/vim-colors-solarized'
Bundle 'avakhov/vim-yaml'
" Bundle 'bbommarito/vim-slim'
Bundle 'glidenote/memolist.vim'
Bundle 'godlygeek/tabular'
Bundle 'jiangmiao/simple-javascript-indenter'
" Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim'
Bundle 'mattn/zencoding-vim'
" Bundle 'msanders/snipmate.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'tacahiroy/vim-endwise'
" Bundle 'thinca/vim-quickrun'
Bundle 'thinca/vim-ref'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'
" Bundle 'tpope/vim-rails'
Bundle 'tpope/vim-surround'
Bundle 'tyru/open-browser.vim'
Bundle 'vim-ruby/vim-ruby'

" Bundle 'Align'
" Bundle 'IndentAnything'
Bundle 'camelcasemotion'
" Bundle 'increment_new.vim'
Bundle 'matchit.zip'

filetype plugin indent on
"}}}

set cpo&vim

autocmd!

let g:mapleader = ','

if isdirectory($HOME . '/.vim')
  let $DOTVIM = $HOME . '/.vim'
else
  " MS Windows etc...
  let $DOTVIM = $HOME . '/vimfiles'
endif

" likes pathogen?
if isdirectory(expand('$DOTVIM/sandbox'))
  let dirs = split(glob($DOTVIM.'/sandbox/*'))
  for d in dirs
    execute ':set runtimepath+=' . d
    if d =~# '/doc$'
      execute ':helptags ' . d
    endif
  endfor
endif

set nocompatible
set verbose=0

" * functions "{{{
" convert path separator
" unix <-> dos
function! Cps(path, sep)
  return substitute(a:path, '[/\\]', a:sep, 'g')
endfunction


" tag information show in command window
function! s:previewTagLite(word)
  let t = taglist('^' . a:word . '$')
  let current = expand('%:t')

  for item in t
    if -1 < stridx(item.filename, current)
      " [filename] tag definition
      echohl Search | echomsg printf('%-36s %s', '[' . Cps(item.filename, '/') . ']', item.cmd) | echohl None
    else
      echomsg printf('%-36s %s', '[' . substitute(Cps(item.filename, '/'), '\s\s*$', '', '') . ']', item.cmd)
    endif
  endfor
endfunction
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
set backupskip& backupskip+=/tmp/*,/private/tmp/*,*.bac,COMMIT_EDITMSG,hg-editor-*.txt,svn-commit.[0-9]*.tmp
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

set previewheight=8
set pumheight=24
set scroll=0
set shellslash
set shiftround
set showbreak=>\ 
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

if has('persistent_undo')
  set undodir=~/.vimundo
  augroup UndoFile
    autocmd!
    autocmd BufReadPre ~/* setlocal undofile
  augroup END
endif

let g:solarized_termcolors = 256
let g:solarized_termtrans = 1
let g:solarized_contrast = 'high'
let g:solarized_visibility = 'high'
let g:solarized_hitrail = 1
let g:solarized_menu = 0
set background=light
set t_Co=256
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
let &statusline .= ' %=%{ImHere()}'
let &statusline .= '%-12( %l/%LL,%c %)%P'

function! ImHere()
  function! ShortenPath(path, ratio)
    if !empty(&buftype)
      return ''
    endif

    let path = substitute(a:path, $HOME, '~', '')
    " let plen = len(path)
    " let width = (&columns + &numberwidth) * 1.0

    " if 0.5 < plen / width
    "   let slen = float2nr(plen * a:ratio * 0.01)
    "   let path = strpart(path, 0, slen) . '...' . strpart(path, plen - slen)
    " endif

    if 3 < len(split(path, '/'))
      return '(' . join(split(path, '/')[-3:-1], '/') . ')'
    else
      return '(' . path . '/)'
    endif
  endfunction

  if !get(g:, 'iamhere_enabled', 1)
    return ''
  endif

  return ShortenPath(getcwd(), 25)
endfunction
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
nnoremap vV ^vg_
nnoremap vo vg_
nnoremap <Return> :<C-u>call append(line('.'), '')<Cr>
nnoremap <C-]> <C-]>zz
nnoremap <C-t> <C-t>zz

nnoremap <silent> qj :cnext<Cr>
nnoremap <silent> qk :cprevious<Cr>
nnoremap <silent> qh :bnext<Cr>
nnoremap <silent> ql :bprevious<Cr>

nnoremap s <Nop>
nnoremap q <Nop>
nnoremap Q q

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

nnoremap <silent> <Leader>M :let &mouse = empty(&mouse) ? 'a' : ''<Cr>
nnoremap <silent> <Leader>P :set paste!<Cr>
nnoremap <silent> <Leader>L :set list!<Cr>
nnoremap <silent> <Leader>C :let &clipboard =
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
if has('macunix')
  nnoremap <silent> <Space>e
        \ :<C-u>silent execute ':!open -a Finder %:p:h'<Cr>:redraw!<Cr>
elseif has('win32') || has('win64')
  nnoremap <silent> <Space>e
        \ :<C-u>silent execute ":!start explorer \"" . Cps(expand("%:p:h"), "\\") . "\""<Cr>
  " open current directory with Command Prompt
  nnoremap <silent> <Space>E
        \ :<C-u>silent execute ":!start cmd /k cd \"" . Cps(expand("%:p:h"), "\\") . "\""<Cr>
endif

nnoremap <Space>w :<C-u>update<Cr>
nnoremap <Space>q :<C-u>quit<Cr>
nnoremap <Space>W :<C-u>update!<Cr>
nnoremap <Space>Q :<C-u>quit!<Cr>

nnoremap <Space>j <C-f>
nnoremap <Space>k <C-b>

nnoremap <Space>h :<C-u>h<Space>
nnoremap <Space>t :<C-u>tabe<Space>

nnoremap <silent> <Space>_ :<C-u>edit $MYVIMRC<Cr>
nnoremap <silent> <Space>g_ :<C-u>edit $MYGVIMRC<Cr>
nnoremap <Space>S :<C-u>source %<Cr>

nnoremap <Space>TT :<C-u>NERDTreeToggle<Cr>
nnoremap <Space>Tf :<C-u>NERDTreeFind<Cr>

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

" Ctrl-H dispute
" set t_kb=<Bs>
" set t_kD=<Del>
" inoremap <Del> <Bs>

" vim-endwise support
function! s:CrInInsertModeBetterWay()
  return pumvisible() ? "\<C-y>\<Cr>" : "\<Cr>"
endfunction
inoremap <silent> <Cr> <C-R>=<SID>CrInInsertModeBetterWay()<Cr>

inoremap <silent> <Leader>dd <C-R>=strftime('%Y-%m-%d')<Cr>
inoremap <silent> <Leader>tm <C-R>=strftime('%H:%M')<Cr>
inoremap <silent> <Leader>fn <C-R>=@%<Cr>

" ^J is used to toggle IME
inoremap <silent> <C-j> <Nop>
cnoremap <silent> <C-j> <Nop>

" selected text search
vnoremap * y/<C-R>"<Cr>
vnoremap < <gv
vnoremap > >gv
vnoremap <C-k> :m-2<Cr>gv
vnoremap <C-j> :m+1<Cr>gv

if executable('tidyp')
  function! s:runTidy(col) range
    " this code is not perfect.
    " tidy's Character encoding option and Vim's fileencoding/encoding is not a pair
    let enc = &l:fileencoding ? &l:fileencoding : &encoding
    let enc = substitute(enc, '-', '', 'g')

    silent execute printf(': %d,%d!tidyp -xml -i -%s -wrap %d -q -asxml', a:firstline, a:lastline, enc, eval(a:col))
  endfunction

  command! -nargs=1 -range Tidy call s:runTidy(<args>)
endif
"}}}


" * abbreviations"{{{
inoreabbr funciton function
inoreabbr requrie require
inoreabbr reuqire require
inoreabbr passowrd password
inoreabbr WinMerege WinMerge
inoreabbr Winmerge WinMerge
"}}}


" syntax: vim.vim
let g:vimsyntax_noerror = 1


" * something "{{{
augroup Tacahiroy
  autocmd!

  autocmd VimLeave * :mksession! ~/.vimsession

  autocmd BufReadPost * if !search('\S', 'cnw') | let &l:fileencoding = &encoding | endif
  " restore cursor position
  autocmd BufReadPost * if line("'\"") <= line('$') | execute "normal '\"" | endif
  autocmd BufEnter * setlocal formatoptions-=o
  " autocmd BufRead,BufWritePost * if &expandtab && search('\t', 'cnw') && !&readonly | setlocal list | else | setlocal nolist | endif

  " autochdir emulation
  autocmd BufEnter * call s:autoChdir(6)
  function! s:autoChdir(n) "{{{
    function! GetTopDir(dir, n) "{{{
      let i = 0
      let dir = a:dir

      while i < a:n
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
    endfunction "}}}

    if expand('%') =~# '^fugitive://'
      return
    endif

    let dir = GetTopDir(expand('%:p:h'), 5)

    execute ':lcd ' . escape(dir, ' ')
  endfunction "}}}

  autocmd BufRead,BufNewFile *.ru,Gemfile,Guardfile set filetype=ruby
  autocmd BufRead,BufNewFile ?zshrc,?zshenv set filetype=zsh

  augroup PersistentUndo
    autocmd BufWritePre COMMIT_EDITMSG setlocal noundofile
    autocmd BufWritePre *.bak *.bac setlocal noundofile
    autocmd BufWritePre knife-edit-*.js setlocal noundofile
  augroup END

  autocmd User Rails nnoremap <buffer> <Space>r :<C-u>R

  autocmd FileType mail setlocal spell
  autocmd FileType slim setlocal makeprg=slimrb\ -c\ %

  autocmd FileType help,qf,logaling,ref-* nnoremap <buffer> <silent> qq <C-w>c
  autocmd FileType javascript* setlocal omnifunc=javascriptcomplete#CompleteJS

  autocmd FileType rspec compiler rspec
  autocmd FileType rspec setlocal omnifunc=rubycomplete#Complete
  autocmd FileType *ruby,rspec :execute 'setlocal iskeyword+=' . char2nr('?')

  autocmd FileType vim,snippet setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType vim :execute 'setlocal iskeyword+=' . char2nr(':')

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

  autocmd BufRead knife-edit-*.js set filetype=javascript.json
  autocmd FileType javascript.json setlocal makeprg=ruby\ $HOME/bin/jsonv.rb\ %

  autocmd Filetype c set tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype c compiler gcc
  autocmd FileType c setlocal makeprg=gcc\ -Wall\ %\ -o\ %:r.o
  autocmd FileType c nnoremap <buffer> <Space>m :<C-u>write<Cr>:make --std=c99<Cr>

  autocmd FileType markdown inoremap <buffer> <Leader>h1 <Esc>10i=<Esc>^
                         \| inoremap <buffer> <Leader>h2 <Esc>10i-<Esc>^
                         \| inoremap <buffer> <Leader>h3 <Esc>I### 
                         \| inoremap <buffer> <Leader>h4 <Esc>I#### 
                         \| inoremap <buffer> <Leader>h5 <Esc>I##### 
                         \| inoremap <buffer> <Leader>hr <Esc>i- - -<Esc>^
  autocmd FileType markdown setlocal autoindent

  " easy way
  if executable('markdown')
    autocmd FileType markdown nnoremap <buffer> <Leader>r :<C-u>call <SID>md_preview_by_browser(expand('%'))<Cr>
    function! s:md_preview_by_browser(f)
      let tmp = '/tmp/vimmarkdown.html'
      call system('markdown ' . a:f . ' > ' . tmp)
      call system('open ' . tmp)
    endfunction
  endif


  " only for the WinMerge document translation project
  function! s:moveToSegment(is_prev)
    let flag = a:is_prev ? 'b' : ''
    call search('<\(para\|section\|term\)[^>]*>', 'esW'.flag)
  endfunction
  autocmd FileType xml nnoremap <silent> <buffer> <Tab> :call <SID>moveToSegment(0)<Cr>
  autocmd FileType xml nnoremap <silent> <buffer> <S-Tab> :call <SID>moveToSegment(1)<Cr>
  autocmd FileType xml noremap  <silent> <buffer> <Leader>a :call <SID>runTidy(80)<Cr>
  autocmd BufRead,BufEnter *.xml set updatetime=1000
  autocmd BufLeave,BufWinLeave *.xml set updatetime&

  autocmd BufRead,BufNewFile * syn match ExtraSpaces '[\t ]\+$'
  hi def link ExtraSpaces Error
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

let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.hg$\|\.svn$\|\.vimundo$\|\.ctrlp_cache/\|\.rbenv/\|\.gem/\|backup$\|Downloads$',
  \ 'file': '\.exe$\|\.so$\|\.dll$\|\.DS_Store$',
  \ }

nnoremap <Space>ls :CtrlPBuffer<Cr>
nnoremap <Space>fd :CtrlPCurWD<Cr>
nnoremap <Space>fm :CtrlPMRU<Cr>
nnoremap <Space>fl :CtrlPLine<Cr>
nnoremap <Space>fk :CtrlPBookmarkDir<Cr>
nnoremap <Space>ft :CtrlPBufTag<Cr>
nnoremap <Space>fT :CtrlPBufTagAll<Cr>
nnoremap <Space>fo :execute 'CtrlP ' . $chef . '/cookbooks/_default'<Cr>
nnoremap <Space>fw :execute 'CtrlP ' . getcwd()<Cr>

nnoremap <Space>fu :CtrlPFunky<Cr>
"}}}

" plug: memolist.vim " {{{
let g:memolist_memo_suffix = 'md'
let g:memolist_memo_date = '%Y-%m-%d %H:%M'
let g:memolist_prompt_tags = 1
let g:memolist_prompt_categories = 1
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
let g:loga_executable = system('which loga')
let g:loga_enable_auto_lookup = 0
let g:loga_delimiter = '=3'
map <Space>a <Plug>(loga-lookup)
imap <Leader>v <Plug>(loga-insert-delimiter)

" plug: timetap.vim
let g:timetap_accept_path_pattern = '^~/\%(\..\+$\|Projects\)'
let g:timetap_ignore_path_pattern = '\(/a\+\.\w\+$\|/\.git/\|tags\|tags-.+\|NERD_tree_.\+$\)'
let g:timetap_is_sort_base_today = 1
let g:timetap_is_display_zero = 1
let g:timetap_is_debug = 0
let g:timetap_display_limit = 15
let g:timetap_observe_cursor_position = 1
nnoremap <Leader>tt :<C-u>TimeTap<Cr>
nnoremap <Leader>ta :<C-u>TimeTapCurrentProject<Cr>
nnoremap <Leader>tp :<C-u>TimeTapProject<Cr>
"}}}

if has('multi_byte_ime') || has('xim')
  set iminsert=0 imsearch=0
  inoremap <silent> <Esc> <Esc>:<C-u>set iminsert=0<Cr>
endif

" * commands {{{
" open loaded buffer with new tab.
command! -nargs=1 -complete=buffer NTab :999tab sbuffer <args>
command! Big wincmd _ | wincmd |

" Chef
function! s:upload_cookbook(...)
  let path = expand('%:p')
  if path !~# '/cookbooks/_default/.\+'
    return
  endif

  let cookbooks = []
  if 0 < a:0
    let cookbooks = deepcopy(a:000)
  endif

  let m = matchlist(path, '^\(.\+/cookbooks/_default\)/\([^/]\+\)/')
  let cb_path = m[1]
  if index(cookbooks, m[2]) == -1
    call insert(cookbooks, m[2])
  endif

  if 0 < len(cookbooks)
    let cookbooks = filter(cookbooks, 'isdirectory(cb_path."/".v:val)')
    echomsg printf('Uploading cookbooks: %s', join(cookbooks, ' '))
    execute printf('!knife cookbook upload -o %s %s', cb_path, join(cookbooks, ' '))
  else
    echoerr 'no cookbooks are found.'
  endif
endfunction
command! -nargs=* CCookbookUpload call s:upload_cookbook(<f-args>)
nnoremap <Space>U :<C-u>CCookbookUpload<Cr>
" }}}

if filereadable(expand('~/.vimrc.mine'))
  source ~/.vimrc.mine
endif

if has('gui_running') && filereadable(expand('~/.gvimrc'))
  source ~/.gvimrc
end

" __END__ {{{
" vim: ts=2 sts=2 sw=2

