" $HOME/.vimrc
" Author: Tacahiroy <tacahiroy\AT/gmail.com>

scriptencoding utf-8

let g:mapleader = ','

function! s:system(cmd)
  let res = system(a:cmd)
  return { 'out': res, 'err': v:shell_error }
endfunction

" which + chop
function! s:which(cmd)
  let res = s:system('which ' . a:cmd)
  if res.err
    return ''
  else
    return substitute(res.out, '\n$', '', '')
  endif
endfunction

" vundle plugin management "{{{
filetype off
set runtimepath& runtimepath+=~/.vim/vundle.git
call vundle#rc()

Bundle 'avakhov/vim-yaml'
" Bundle 'bbommarito/vim-slim'
Bundle 'glidenote/memolist.vim'
Bundle 'godlygeek/tabular'
Bundle 'jiangmiao/simple-javascript-indenter'
Bundle 'kien/ctrlp.vim'
Bundle 'mattn/zencoding-vim'
Bundle 'msanders/snipmate.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'slj/gundo.vim'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-markdown'
Bundle 'tpope/vim-surround'
Bundle 'tyru/open-browser.vim'
Bundle 'vim-ruby/vim-ruby'
" Bundle 'DrawIt'
Bundle 'camelcasemotion'
Bundle 'matchit.zip'

" it seems this has ftdetect problem
" Bundle 'chrisbra/csv.vim'

" plugin configurations {{{
" plug: memolist
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

" plug: ctrlp.vim
  let g:ctrlp_map = '<Space>ff'
  let g:ctrlp_command = 'CtrlPRoot'
  let g:ctrlp_switch_buffer = 'Et'
  let g:ctrlp_tabpage_position = 'ac'
  let g:ctrlp_working_path_mode = 'ra'
  let g:ctrlp_match_window_bottom = 1
  let g:ctrlp_match_window_reversed = 0
  let g:ctrlp_max_height = 20
  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_follow_symlinks = 1
  let g:ctrlp_highlight_match = [1, 'Constant']
  let g:ctrlp_max_files = 12800
  let g:ctrlp_max_depth = 24
  let g:ctrlp_dotfiles = 1
  let g:ctrlp_mruf_max = 512
  let g:ctrlp_mruf_exclude = 'knife-edit-*.*'

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
  nnoremap <Space>fm :CtrlPMRU<Cr>
  nnoremap <Space>li :CtrlPLine<Cr>
  nnoremap <Space>fk :CtrlPBookmarkDir<Cr>
  nnoremap <Space>fc :execute 'CtrlP ' . $chef . '/cookbooks/_default'<Cr>
  nnoremap <Space>fw :CtrlPCurFile<Cr>
  nnoremap <Space>fd :CtrlPCurWD<Cr>

  nnoremap <Space>fu :CtrlPFunky<Cr>

" plug: nerdtree
  let NERDTreeShowBookmarks = 1
  nnoremap <Space>nt :<C-u>NERDTreeToggle<Cr>
  nnoremap <Space>nn :<C-u>NERDTreeFind<Cr>zz<C-w><C-w>

" plug: syntastic
let g:syntastic_mode_map =
      \ { 'mode': 'active',
        \ 'active_filetypes': ['ruby', 'eruby', 'cucumber', 'perl', 'javascript', 'python', 'sh'],
        \ 'passive_filetypes': ['xml'] }
let g:syntastic_enable_balloons = 0
let g:syntastic_auto_loc_list = 0

" plug: commentary.vim
  nmap <Space>c <Plug>CommentaryLine
  xmap <Space>c <Plug>Commentary

" plug: surround.vim
  let g:surround_{char2nr('k')} = "「\r」"
  let g:surround_{char2nr('K')} = "『\r』"
  xmap c <Plug>VSurround

" plug: openbrowser
  let g:netrw_nogx = 1
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)

" plug: camelcasemotion
  map <silent> w <plug>CamelCaseMotion_w
  map <silent> b <plug>CamelCaseMotion_b
  map <silent> e <plug>CamelCaseMotion_e
  sunmap w
  sunmap b
  sunmap e

" plug: vim-ref
let g:ref_refe_cmd = $HOME . '/Projects/wk/rubyrefm/refe-1_9_2'

" plug: loga.vim
let g:loga_executable = s:which('loga')
let g:loga_enable_auto_lookup = 0
let g:loga_delimiter = '=3'
map  <Space>a <Plug>(loga-lookup)
autocmd FileType logaling imap <buffer> <Leader>v <Plug>(loga-insert-delimiter)

" plug: bestfriend.vim
let g:bestfriend_accept_path_pattern = '^~/\%(\..\+$\|.*Projects\)'
let g:bestfriend_ignore_path_pattern = '\(/a\+\.\w\+$\|/\.git/\|tags\|tags-.+\|NERD_tree_.\+$\)'
let g:bestfriend_is_sort_base_today = 0
let g:bestfriend_is_display_zero = 1
let g:bestfriend_is_debug = 0
let g:bestfriend_display_limit = 15
let g:bestfriend_observe_cursor_position = 1

" }}}

if isdirectory($HOME . '/.vim')
  let $DOTVIM = $HOME . '/.vim'
else
  " MS Windows etc...
  let $DOTVIM = $HOME . '/vimfiles'
endif

if isdirectory(expand('$DOTVIM/sandbox'))
  let dirs = filter(split(glob($DOTVIM.'/sandbox/**/*')), 'isdirectory(v:val)')
  for d in dirs
    execute 'set runtimepath+=' . d
    if d =~# '/doc$'
      execute 'helptags ' . d
    endif
  endfor
endif

filetype plugin indent on
"}}}

let s:is_mac = has('macunix') || has('mac') || system('uname | grep "^Darwin"') =~# "^Darwin"
" I don't use AIX, BSD, HP-UX and any other UNIX
let s:is_linux = !s:is_mac && has('unix')

set cpo&vim

autocmd!

set nocompatible
set verbose=0

" * functions "{{{
function! Echohl(group, msg)
  try
    execute 'echohl ' . a:group
    echomsg a:msg
  finally
    echohl NONE
  endtry
endfunction


" shows tag information into command window
function! s:preview_tag_lite(word)
  let t = taglist('^' . a:word . '$')
  let current = expand('%:t')

  for item in t
    if -1 < stridx(item.filename, current)
      " [filename] tag definition
      call Echohl('Search', printf('%-36s [%s]', item.filename, item.cmd))
    else
      echomsg printf('%-36s %s', '[' . substitute(item.filename, '\s\s*$', '', '') . ']', item.cmd)
    endif
  endfor
endfunction
command! -nargs=0 PreviewTagLite call s:preview_tag_lite(expand('<cword>'))
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

set shell&
for sh in ['/usr/local/bin/zsh', '/usr/bin/zsh', '/bin/zsh', '/bin/bash']
  if executable(sh)
    let &shell = sh
    break
  endif
endfor

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
    set guifont=Migu\ 1M\ Regular\ 13
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
let &statusline .= '%{&filetype}:'
let &statusline .= '%{(&l:fileencoding != "" ? &l:fileencoding : &encoding).":".&fileformat}'
let &statusline .= '(%{&expandtab ? "" : ">"}%{&l:tabstop}'
let &statusline .= '%{search("\\t", "cnw") ? "!" : ""})'
let &statusline .= '%{(empty(&mouse) ? "" : "m")}'
let &statusline .= '%{(&list ? "l" : "")}'
let &statusline .= '%{(empty(&clipboard) ? "" : "c")}'
let &statusline .= '%{(&paste ? "p" : "")}'
let &statusline .= '%#Function#%{fugitive#statusline()}%*'
let &statusline .= ' %='
let &statusline .= '%{Gps()}'
let &statusline .= '%{(g:auto_chdir_enabled ? "e" : "d")}'
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
nnoremap Q <Nop>
nnoremap <C-q> q
nnoremap q <Nop>

nnoremap Y y$
nnoremap j gj
nnoremap k gk

" selection
nnoremap vv <C-v>
nnoremap vo vg_
nnoremap vO ^vg_

nnoremap <C-]> <C-]>zz
nnoremap <C-t> <C-t>zz

nnoremap * *N
nnoremap # #N

nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" quickfix
function! s:redir(cmd)
  redir => res
  execute a:cmd
  redir END

  return res
endfunction

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
nnoremap <silent> qo :<C-u>silent call <SID>toggle_qf_list()<Cr>
nnoremap <silent> qj :cnext<Cr>zz
nnoremap <silent> qk :cprevious<Cr>zz
nnoremap <silent> qf :cc<Cr>zz

nnoremap <silent> <Leader>tm :let &mouse = empty(&mouse) ? 'a' : ''<Cr>
nnoremap <silent> <Leader>tp :set paste!<Cr>
nnoremap <silent> <Leader>tl :set list!<Cr>
nnoremap <silent> <Leader>tc :let &clipboard =
      \ empty(&clipboard) ? 'unnamed,unnamedplus' : ''<Cr>
nnoremap <silent> <Leader>tn :<C-u>setlocal relativenumber!<Cr>

" open the current editing file's location using file manager
function! s:open_with_filer(...)
  let cmd = s:get_command()
  let path = get(a:, 1, s:convert_path(expand('%:p:h')))

  if empty(cmd)
    call Echohl('Error', 'Your system is not supported.')
    return
  endif

  execute printf('!%s %s', cmd, path)
endfunction
command! -nargs=? Finder call s:open_with_filer(<f-args>)

function! s:convert_path(path)
  if has('win32') || has('win64')
    return '"' . substitute(a:path, '/', '\', 'g') . '"'
  else
    return a:path
  endif
endfunction

function! s:get_command()
  if s:is_mac
    return 'open -a Finder'
  elseif has('unix') && has('gui_gnome')
    return 'nautilus'
  elseif has('win32') || has('win64')
    return 'start explorer'
  else
    return ''
  endif
endfunction

nnoremap <Space>w :<C-u>update<Cr>
nnoremap <Space>q :<C-u>quit<Cr>
nnoremap <Space>W :<C-u>update!<Cr>
nnoremap <Space>Q :<C-u>quit!<Cr>

nnoremap <C-h> :<C-u>h<Space>
nnoremap s<Space> i<Space><Esc>

" open .vimrc
nnoremap <Space>_ :<C-u>execute (empty(expand('%')) && !&modified ? 'edit ' : 'tabedit ') . $MYVIMRC<Cr>
nnoremap <Space>S :<C-u>source %<Cr>:nohlsearch<Cr>

nnoremap <Leader>s :<C-u>s/
nnoremap <Leader>S :<C-u>%s/
vnoremap <Leader>s :s/
vnoremap <Leader>S :s/
nnoremap <Leader>g :<C-u>g/
nnoremap <Leader>te :<C-u>tabe<Space>

nnoremap <silent> <C-c> <Esc>:<C-u>nohlsearch<Cr>

nnoremap <silent> sh <C-w>h
nnoremap <silent> sk <C-w>k
nnoremap <silent> sl <C-w>l
nnoremap <silent> sj <C-w>j

nnoremap <silent> sn :tabnext<Cr>
nnoremap <silent> sp :tabprevious<Cr>
" conflict tmux key binds
if s:is_mac && has('gui_running')
  nnoremap <silent> <D-Right> :tabnext<Cr>
  nnoremap <silent> <D-Left>  :tabprevious<Cr>
  nnoremap <silent> <M-Left>  <C-w>h
  nnoremap <silent> <M-Up>    <C-w>k
  nnoremap <silent> <M-Right> <C-w>l
  nnoremap <silent> <M-Down>  <C-w>j
endif

" visual last pasted lines
nnoremap sv `[v`]

nnoremap <MiddleMouse> <Nop>
nnoremap <2-MiddleMouse> <Nop>

" preview tag
nnoremap <silent> <Space>p <C-w>}
nnoremap <silent> <Space>P :pclose<Cr>

" Ctrl-H dispution
" set t_kb=<Bs>
" set t_kD=<Del>
" inoremap <Del> <Bs>

inoremap <silent> <Leader>date <C-R>=strftime('%Y-%m-%d')<Cr>
inoremap <silent> <Leader>time <C-R>=strftime('%H:%M')<Cr>
inoremap <silent> <Leader>fn <C-R>=@%<Cr>
inoremap <silent> <C-v> <Esc>:set paste<Cr>"+P:set nopaste<Cr>v`]

" search selected text
vnoremap * y/<C-R>"<Cr>
vnoremap < <gv
vnoremap > >gv

vnoremap <Down> :call <SID>move_block('d')<Cr>==gv
vnoremap <Up> :call <SID>move_block('u')<Cr>==gv

function! s:move_block(d) range
  let cnt = a:lastline - a:firstline

  if a:d is# 'u'
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

    silent execute printf('%d,%d!tidyp -xml -i -%s -wrap %d -q -asxml', a:firstline, a:lastline, enc, eval(col))
  endfunction

  command! -nargs=? -range Tidy <line1>,<line2>call s:run_tidy(<args>)
endif
"}}}


if has('vim_starting')
  let g:auto_chdir_enabled = get(g:, 'auto_chdir_enabled', 1)
  " syntax: vim.vim
  let g:vimsyntax_noerror = 1
endif

if has('multi_byte_ime') || has('xim')
  set iminsert=0 imsearch=0
  inoremap <silent> <Esc> <Esc>:<C-u>set iminsert=0<Cr>
endif


" * autocmds "{{{
augroup Tacahiroy
  autocmd!

  autocmd BufReadPost * if !search('\S', 'cnw') | let &l:fileencoding = &encoding | endif
  " restore cursor position
  autocmd BufReadPost * if line("'\"") <= line('$') | execute "normal '\"" | endif
  autocmd BufEnter * setlocal formatoptions-=o

  autocmd FileType *
        \  if &buftype !~# '^\(quickfix\|help\|nofile\)$'
        \|    nnoremap <buffer>  <Return> :<C-u>call append(line('.'), '')<Cr>
        \| endif

  autocmd BufRead,BufNewFile *
        \  if expand('%:p:h') =~# '.*/cookbooks/.*'
        \|   setlocal makeprg=foodcritic\ $*\ %
        \|   setlocal errorformat=%m:\ %f:%l
        \| endif

  " autochdir emulation
  autocmd BufEnter * call s:auto_chdir(6)

  function! s:get_project_root(dir, depth)
    let i = 0
    let dir = a:dir

    while i < a:depth
      let dirs = split(dir, '/')
      if !exists('maxidx')
        let maxidx = len(dirs)
      endif

      let idx = maxidx - i
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
    if ! get(g:, 'auto_chdir_enabled', 1)
      return
    endif

    if expand('%') =~# '^\S\+://'
      return
    endif

    let dir = s:get_project_root(expand('%:p:h'), a:n)

    execute 'lcd ' . escape(dir, ' ')
  endfunction

  function! s:toggle_auto_chdir_mode()
    let g:auto_chdir_enabled = ! get(g:, 'auto_chdir_enabled', 1)
    call Echohl('Constant', 'AutoChdir: ' . (g:auto_chdir_enabled ? 'enabled' : 'disabled'))
  endfunction
  command! -nargs=0 -bang AutoChdirToggle call s:toggle_auto_chdir_mode()

  augroup PersistentUndo
    autocmd!
    autocmd BufWritePre COMMIT_EDITMSG setlocal noundofile
    autocmd BufWritePre *.bak,*.bac setlocal noundofile
    autocmd BufWritePre knife-edit-*.js setlocal noundofile
  augroup END

  autocmd User Rails nnoremap <buffer> <Space>r :<C-u>R

  autocmd BufRead,BufNewFile *.ru,Gemfile,Guardfile setlocal filetype=ruby
  autocmd BufRead,BufNewFile ?zshrc,?zshenv setlocal filetype=zsh

  function! s:insert_today_for_md_changelog()
    call append(line('.') - 1, strftime('%Y-%m-%d'))
    call append(line('.') - 1, '----------')
  endfunction
  autocmd BufRead,BufNewFile *.md,*.mkd,*.markdown setlocal filetype=markdown
  autocmd FileType markdown nnoremap <buffer> <Leader>it :<C-u>call <SID>insert_today_for_md_changelog()<Cr>
  autocmd FileType markdown nnoremap <buffer> <Leader>ix i[x]<Space><Esc>

  autocmd FileType gitcommit setlocal spell
  autocmd FileType mail set spell
  autocmd FileType slim setlocal makeprg=slimrb\ -c\ %

  autocmd BufRead,BufNewFile *.applescript,*.scpt setfiletype applescript
  autocmd FileType applescript set commentstring=#\ %s

  autocmd FileType help,qf,logaling,bestfriend,ref-* nnoremap <buffer> <silent> qq <C-w>c
  autocmd FileType javascript* set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType rspec compiler rspec
  autocmd FileType rspec set omnifunc=rubycomplete#Complete
  autocmd FileType *ruby,rspec :execute 'setlocal iskeyword+=' . char2nr('?')
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
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

  " Chef
  autocmd BufRead,BufNewFile knife-edit-*.js,*.json setlocal filetype=javascript.json
  autocmd FileType *json* setlocal makeprg=python\ -mjson.tool\ 2>&1\ %\ >\ /dev/null
                       \| setlocal errorformat=%m:\ line\ %l\ column\ %c\ %.%#

  autocmd Filetype c setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype c compiler gcc
  autocmd FileType c setlocal makeprg=gcc\ -Wall\ %\ -o\ %:r.o
  autocmd FileType c nnoremap <buffer> <Space>m :<C-u>write<Cr>:make --std=c99<Cr>

  autocmd FileType markdown inoremap <buffer> <Leader>h1 <Esc>I#<Space>
                         \| inoremap <buffer> <Leader>h2 <Esc>I##<Space>
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
        \| hi def link ExtraSpaces MatchParen

  " typo correction
  inoreabbr funciton function
  inoreabbr requrie require
  inoreabbr reuqire require
  inoreabbr passowrd password
  inoreabbr ture true
  inoreabbr stating staging
augroup END
"}}}


" Chef
if executable('knife')
  function! s:knife_cookbook_upload(...) abort
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
      let cmd = printf('knife cookbook upload -o %s %s;', cb_path, join(cookbooks, ' '))

      if s:is_mac && executable('growlnotify')
        let gtitle = 'cookbook upload: ' . join(cookbooks, ' ')
        let gapp = 'Chef'
        let cmd .= 'if [ $? -eq 0 ]; then echo SUCCESS; else echo FAILURE; fi | '
        let cmd .= printf('growlnotify -n %s \"%s\"', gapp, gtitle)
      endif

      echomsg printf('%s: %s', mes, join(cookbooks, ' '))
      call s:tmux.run(cmd, 1, 1)
    else
      echoerr 'no cookbooks are found.'
    endif
  endfunction

  command! -nargs=* KnifeCookbookUpload call s:knife_cookbook_upload(<f-args>)
  nnoremap <Space>K :<C-u>KnifeCookbookUpload<Cr>

  function! s:knife_data_bag_from_file(json, ...)
    let path = fnamemodify(expand(a:json), ':p')
    if path !~# '/data_bags/'
      call Echohl('WarningMsg', printf('%s is not a data bag file.', path))
      return
    endif

    let bag_name = fnamemodify(path, ':p:h:t')
    let opts = join(a:000, ' ')

    echom printf('!knife data bag from file %s %s %s', bag_name, bufname(a:json), opts)
    execute printf('!knife data bag from file %s %s %s', bag_name, bufname(a:json), opts)
  endfunction
  command! -nargs=+ KnifeDataBagFromFile call s:knife_data_bag_from_file(<f-args>)
endif

" light tmux integration " {{{
" reinvent the wheel?
let s:tmux = {}
let s:tmux.last_cmd = ''

function! s:tmux.is_installed()
  return !empty(s:which('which tmux'))
endfunction

function! s:tmux.is_running()
  let r = s:system('tmux ls -F "#{session_name}:#{session_attached}" | grep :1')
  return r.err == 0
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
      let res = s:system(printf('tmux splitw -v "%s"', a:cmd))
      if res.err
        echomsg res.out
      endif
    else
      let enter = (is_control ? '' : 'Enter')
      call s:system(printf('`tmux send "%s" %s`', a:cmd, enter))
    endif
  elseif run_in_vim
    execute '!' . a:cmd
  else
    call Echohl('ErrorMsg', 'ERR: tmux is not running')
    return
  endif
endfunction

function! s:tmux.operate(cmd)
  if self.is_running()
    call s:system(printf('`tmux "%s"`', a:cmd))
  else
    call Echohl('ErrorMsg', 'ERR: tmux is not running')
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

if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

" __END__ {{{
" vim: fen fdm=marker ts=2 sts=2 sw=2

