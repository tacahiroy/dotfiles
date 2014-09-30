" $HOME/.vimrc
" Author: tacahiroy <tacahiroy\AT/gmail.com>

scriptencoding utf-8

let g:mapleader = ','

" Clear all autocmds in the default group
autocmd!
augroup Tacahiroy
  autocmd!
augroup END

" functions " {{{
" * global
function! Echohl(group, msg)
  try
    execute 'echohl ' . a:group
    echomsg a:msg
  finally
    echohl NONE
  endtry
endfunction

" To realise where I am
function! Gps()
  return '(' . s:shorten_path(getcwd(), 25) . ')'
endfunction

" $HOME shown as tilde etc.
function! s:shorten_path(path, ratio)
  if !empty(&buftype)
    return '-'
  endif

  let path = substitute(a:path, $HOME, '~', '')

  if len(split(path, '/')) > 3
    return join(split(path, '/')[-3:-1], '/')
  else
    return path
  endif
endfunction

" * private
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

" show tag information in the command window
function! s:preview_tag_lite(word)
  let t = taglist('^' . a:word . '$')
  let current = expand('%:t')

  for item in t
    if stridx(item.filename, current) > -1
      " [filename] tag definition
      call Echohl('Search', printf('%-36s [%s]', item.filename, item.cmd))
    else
      echomsg printf('%-36s %s', '[' . substitute(item.filename, '\s\s*$', '', '') . ']', item.cmd)
    endif
  endfor
endfunction
command! -nargs=0 PreviewTagLite call s:preview_tag_lite(expand('<cword>'))
"}}}

" enough
let s:is_mac = has('macunix') || has('mac') || system('uname | grep "^Darwin"') =~# "^Darwin"
" GNU/Linux only
let s:is_linux = !s:is_mac && has('unix')
" just in case
let s:is_windows = has('win32') || has('win64')

if isdirectory($HOME . '/.vim')
  let $DOTVIM = $HOME . '/.vim'
else
  " MS Windows etc...
  let $DOTVIM = $HOME . '/vimfiles'
endif

if has('vim_starting')
  let g:auto_chdir_enabled = get(g:, 'auto_chdir_enabled', 1)
  " syntax: vim.vim
  let g:vimsyntax_noerror = 1
endif

" * vundle plugin management "{{{
filetype off
set runtimepath& runtimepath+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
" Plugin 'ctrlpvim/ctrlp.vim', { 'name': 'ctrlp.vim' }
Plugin 'tpope/vim-surround'
Plugin 'godlygeek/tabular'
Plugin 'sjl/gundo.vim'
Plugin 'glidenote/memolist.vim'
Plugin 'tyru/open-browser.vim'
Plugin 'thinca/vim-quickrun'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-endwise'
Plugin 'scrooloose/nerdtree'
Plugin 'chrisbra/csv.vim'
Plugin 'othree/html5.vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'jiangmiao/simple-javascript-indenter'
" Plugin 'jeroenbourgois/vim-actionscript'
Plugin 'tpope/vim-markdown'
Plugin 'avakhov/vim-yaml'
Plugin 'slim-template/vim-slim'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-rails'
Plugin 'derekwyatt/vim-scala'
Plugin 'elixir-lang/vim-elixir'
Plugin 'ekalinin/Dockerfile.vim'
" from vim-scripts repo
Plugin 'camelcasemotion'
Plugin 'matchit.zip'



" self pathogen: really simple-minded
if isdirectory($DOTVIM . '/sandbox')
  let dirs = filter(split(glob($DOTVIM . '/sandbox/**/*')), 'isdirectory(v:val)')
  for d in dirs
    execute 'set runtimepath+=' . d
    if d =~# '/doc$'
      execute 'helptags ' . d
    endif
  endfor
endif

" Disable GUI /Syntax/ menu
let did_install_syntax_menu = 1
let did_install_default_menus = 1

call vundle#end()
filetype plugin indent on
syntax enable


" * make prefix keys visible {{{
" Toggle
nnoremap [Toggle] <Nop>
nmap <Leader><Leader> [Toggle]
" Space
nnoremap [Space] <Nop>
map <Space> [Space]
" }}}

" * plugin configurations {{{
" plug: memolist
  let g:memolist_path = expand('~/Projects/memo')
  let g:memolist_memo_suffix = 'md'
  let g:memolist_memo_date = '%Y-%m-%d %H:%M'
  let g:memolist_prompt_tags = 1
  let g:memolist_prompt_categories = 0
  let g:memolist_qfixgrep = 0
  let g:memolist_vimfiler = 0

  nnoremap [Space]mc :MemoNew<Cr>
  nnoremap [Space]mg :MemoGrep<Cr>
  nnoremap [Space]mL :MemoList<Cr>
  nnoremap [Space]ml :execute 'CtrlP ' . g:memolist_path<Cr><F5>

" plug: ctrlp.vim
  let g:ctrlp_map = '[Space]ff'
  let g:ctrlp_cmd = 'CtrlPRoot'
  let g:ctrlp_switch_buffer = 'Et'
  let g:ctrlp_tabpage_position = 'ac'
  let g:ctrlp_working_path_mode = 'ra'
  let g:ctrlp_match_window_bottom = 1
  let g:ctrlp_match_window_reversed = 0
  let g:ctrlp_max_height = 16
  let g:ctrlp_clear_cache_on_exit = 0
  let g:ctrlp_follow_symlinks = 1
  let g:ctrlp_highlight_match = [1, 'Constant']
  let g:ctrlp_max_files = 12800
  let g:ctrlp_max_depth = 24
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_mruf_max = 1024
  let g:ctrlp_mruf_exclude = 'knife-edit-*.*'

  let g:ctrlp_funky_matchtype = 'path'

  let g:ctrlp_user_command = {
    \ 'types': {
      \ 1: ['.git/', 'cd %s && git ls-files . -co --exclude-standard'],
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
  let g:ctrlp_extensions = ['line', 'buffertag', 'dir', 'mixed', 'funky', 'ssh']

  let dir = ['\.git$', '\.hg$', '\.svn$', '\.vimundo$', '\.cache/ctrlp$',
        \    '\.rbenv', '\.gem', 'backup', 'Documents', $TMPDIR,
        \    '/vendor/*/vendor']
  let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/]' . join(dir, '|') . '/',
    \ 'file': '\v(\.exe|\.so|\.dll|\.DS_Store|\.db|COMMIT_EDITMSG)$'
    \ }

  let g:ctrlp_preview_enabled = 1

  let g:ctrlp_funky_ruby_chef_words = 1
  let g:ctrlp_funky_sort_by_mru = 0
  let g:ctrlp_funky_syntax_highlight = 1
  let g:ctrlp_funky_debug = 1
  let g:ctrlp_funky_use_cache = 1

  let g:ctrlp_mruf_relative = 0

  let g:ctrlp_ssh_keep_ctrlp_window = 1

  nnoremap [Space]fl :CtrlPBuffer<Cr>
  nnoremap [Space]fm :CtrlPMRU<Cr><F5>
  nnoremap [Space]li :CtrlPLine<Cr>
  nnoremap [Space]fk :CtrlPBookmarkDir<Cr>
  nnoremap [Space]fc :execute 'CtrlP ' . $chef . '/cookbooks'<Cr>
  nnoremap [Space]fw :CtrlPCurFile<Cr>
  nnoremap [Space]f. :CtrlPCurWD<Cr>
  nnoremap [Space]fr :CtrlPRTS<Cr>

  nnoremap [Space]fu :CtrlPFunky<Cr>
  nnoremap [Space]fs :CtrlPSSH<Cr>

" plug: nerdtree
  let NERDTreeShowBookmarks = 1
  nnoremap [Space]nt :NERDTreeToggle<Cr>
  nnoremap [Space]nn :NERDTreeFind<Cr>zz<C-w><C-w>
  nnoremap [Space]nc :execute 'NERDTree ' . $chef . '/cookbooks'<Cr>

  if s:is_mac
    augroup Tacahiroy
      autocmd FileType nerdtree nnoremap <buffer> <Leader>ql :<C-u>call NERDTreeQuickLook()<Cr>
                             \| nnoremap <buffer> <Leader>qe :<C-u>call NERDTreeExecuteFile()<Cr>
    augroup END
  endif

" plug: vim-quickrun
  let g:quickrun_config = {
        \    'perl': {
              \ 'outputter': 'buffer',
              \ 'runner': 'system',
              \ 'cmdopt': '',
              \ 'args': '-H 127.0.0.1 -P 8000'
        \ }
  \ }

" plug: syntastic
  let g:syntastic_mode_map =
        \ { 'mode': 'active',
          \ 'active_filetypes': ['ruby', 'cucumber', 'perl', 'javascript', 'python', 'sh'],
          \ 'passive_filetypes': ['xml'] }
  let g:syntastic_enable_balloons = 0
  let g:syntastic_auto_loc_list = 2
  let g:syntastic_error_symbol='✗'
  let g:syntastic_warning_symbol='⚠'

" plug: commentary.vim
  nmap [Space]c gcc
  nmap [Space]yc yygccp
  xmap [Space]c gc

" plug: surround.vim
  let g:surround_{char2nr('k')} = "「\r」"
  let g:surround_{char2nr('K')} = "『\r』"
  let g:surround_{char2nr('e')} = "<%= \r %>"
  let g:surround_{char2nr('b')} = "<%- \r %>"
  xmap s <Plug>VSurround

" plug: openbrowser
  let g:netrw_nogx = 1
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)

" plug: camelcasemotion
  map <silent> W <plug>CamelCaseMotion_w
  map <silent> B <plug>CamelCaseMotion_b
  map <silent> E <plug>CamelCaseMotion_e
  sunmap W
  sunmap B
  sunmap E

" plug: vim-quickrun
  nmap <Space>r <Plug>(quickrun)
  vmap <Space>r <Plug>(quickrun)

" plug: loga.vim
  let g:loga_executable = s:which('loga')
  let g:loga_enable_auto_lookup = 0
  let g:loga_delimiter = '=3'
  map  [Space]a <Plug>(loga-lookup)
  autocmd FileType logaling imap <buffer> <Leader>v <Plug>(loga-insert-delimiter)

" plug: bestfriend.vim
  let g:bestfriend_accept_path_pattern = '^~/\%(\..\+$\|.*Projects\)'
  let g:bestfriend_ignore_path_pattern = '\(/a\+\.\w\+$\|/\.git/\|tags\|tags-.+\|NERD_tree_.\+$\)'
  let g:bestfriend_is_sort_base_today = 0
  let g:bestfriend_is_display_zero = 1
  let g:bestfriend_is_debug = 0
  let g:bestfriend_display_limit = 15
  let g:bestfriend_observe_cursor_position = 1

" plug: csv.vim
  let g:csv_nomap_space = 1

" plug: sqlutilities.vim
  let g:sqlutil_load_default_maps = 0
  let g:sqlutil_align_comma = 1
  let g:sqlutil_align_where = 1
  let g:sqlutil_keyword_case = '\U'
  " don't use menu
  let g:sqlutil_default_menu_mode = 0
" }}}
" }}}

set cpo&vim

set verbose=0

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
set backupskip& backupskip+=/tmp/*,/private/tmp/*,*.bac,COMMIT_EDITMSG,hg-editor-*.txt,svn-commit.[0-9]*.tmp,knife-edit-*
if exists('+breakindent')
  set breakindent
  set breakindentopt=sbr
end
set cedit=<C-x>
set cmdheight=2
set colorcolumn=80
set cpoptions+=n
set noequalalways
set expandtab smarttab
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=unix,dos,mac
set helplang=en
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
set number
if v:version > 702
  set relativenumber
endif
set nrformats=hex
set pastetoggle=<F2>
set previewheight=8
set pumheight=24
" scroll half lines of window height
set scroll=0
set scrolloff=5

" 99% zsh though
set shell&
if !s:is_windows
  let path = ''
  for sh in [ 'zsh', 'bash', 'dash', 'sh' ]
    let path = s:which(sh)
    if executable(path)
      let &shell = path
      break
    endif
  endfor
endif

set shellslash
set shiftround
let &showbreak = "\u279e  "
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
set timeout timeoutlen=1000
set title
set titlestring=Vim:\ %F\ %h%r%m
set titlelen=255
set tabstop=2 shiftwidth=2 softtabstop=2
set updatetime=1000
set viminfo='64,<100,s10,n~/.viminfo
set virtualedit=block,onemore
set t_vb = visualbell
set wildignore=*.exe,*.dll,*.class,*.o,*.obj
if exists('+wildignorecase')
  set wildignorecase
endif
set wildmenu
set wildmode=longest:list,full
set nowrapscan

set matchpairs& matchpairs+=<:>
" prevent highlighting a pair of parentheses and brackets
let g:loaded_matchparen = 1

if has('persistent_undo')
  set undodir=~/.vimundo
  augroup UndoFile
    autocmd!
    autocmd BufReadPre $HOME/* setlocal undofile
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

let &statusline = '[#%n]%<%#Tag#%f%* %m%r%h%w'
let &statusline .= '%{&filetype}:'
let &statusline .= '%{(&l:fileencoding != "" ? &l:fileencoding : &encoding) . ":" . &fileformat}'
let &statusline .= '(%{&expandtab ? "" : ">"}%{&l:tabstop}'
let &statusline .= '%{search("\\t", "cnw") ? "!" : ""})'
let &statusline .= '%{(empty(&mouse) ? "" : "m")}'
let &statusline .= '%{(&list ? "l" : "")}'
let &statusline .= '%{(empty(&clipboard) ? "" : "c")}'
let &statusline .= '%{(&paste ? "p" : "")}'
let &statusline .= ' %=%#Special#'
let &statusline .= '%{Gps()}'
let &statusline .= '%{(g:auto_chdir_enabled ? "e" : "d")}'
let &statusline .= '%-12( %l/%LL,%c %)%P%*'
" }}}


" * mappings "{{{
" Emacs rules!
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-o> <C-d>

cnoremap W!! %!sudo tee > /dev/null %

nnoremap ZZ <Nop>
nnoremap s <Nop>
nnoremap Q <Nop>
nnoremap q <Nop>

" Q for macro
nnoremap Q q
" behave like C or D
nnoremap Y y$

" visual block
nnoremap vv <C-v>
" do visual current column to end-of-line without <NL>
nnoremap vo vg_o
" like V, but without <NL>
nnoremap vO ^vg_o

nnoremap <C-]> <C-]>zz
nnoremap <C-t> <C-t>zz

nnoremap * *N
nnoremap # #N

nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" remove extra '\n' from the redir output
function! s:redir(cmd)
  redir => res
  execute a:cmd
  redir END

  return substitute(res, '^\n\+', '', '')
endfunction

" show/hide quickfix window
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

" quickfix related mappings
nnoremap <silent> qo :<C-u>silent call <SID>toggle_qf_list()<Cr>
nnoremap <silent> qj :cnext<Cr>zz
nnoremap <silent> qk :cprevious<Cr>zz
nnoremap <silent> qc :cc<Cr>zz

nnoremap <silent> qn :bnext<Cr>
nnoremap <silent> qp :bprevious<Cr>

" show/hide line number wisely: this needs Vim 7.3 or above
function! s:toggle_line_number()
  let NU = 'nu'
  let RNU = 'rnu'

  if &nu || &rnu
    " to be off
    let b:prev = { 'nu': &nu, 'rnu': &rnu }
    let &nu = 0
    let &rnu = 0
  else
    " restore previous setting
    let &nu = get(b:prev, 'nu', 1)
    let &rnu = get(b:prev, 'rnu', 1)
  endif
endfunction

nnoremap <silent> [Toggle]m :let &mouse = empty(&mouse) ? 'a' : ''<Cr>
nnoremap <silent> [Toggle]p :set paste!<Cr>
nnoremap <silent> [Toggle]l :set list!<Cr>
nnoremap <silent> [Toggle]c :let &clipboard =
      \ empty(&clipboard) ? 'unnamed,unnamedplus' : ''<Cr>
nnoremap <silent> [Toggle]n :<C-u>silent call <SID>toggle_line_number()<Cr>

nnoremap gf <Nop>
" if <cfile> doesn't exist it'll be created
nnoremap gff :e <cfile><Cr>
" like gff, but open <cfile> in a tab
nnoremap gft :tabe <cfile><Cr>

" returns system specific filer command
function! s:get_filer_command()
  if s:is_mac
    return 'open -a Finder'
  elseif s:is_linux && has('gui_gnome')
    return 'nautilus'
  elseif s:is_windows
    return 'start explorer'
  else
    return ''
  endif
endfunction

" convert path separator: Windows <-> *nix
function! s:convert_path(path)
  if s:is_windows
    return '"' . substitute(a:path, '/', '\', 'g') . '"'
  else
    return a:path
  endif
endfunction

" open the current file's location using file manager
function! s:open_with_filer(...)
  let cmd = s:get_filer_command()
  let path = get(a:, 1, s:convert_path(expand('%:p:h')))

  if empty(cmd)
    call Echohl('Error', 'Your system is not supported yet.')
    return
  endif

  execute printf('!%s %s', cmd, path)
endfunction
command! -nargs=? Filer call s:open_with_filer(<f-args>)

nnoremap [Space]w :<C-u>update<Cr>
nnoremap [Space]q :<C-u>quit<Cr>
nnoremap [Space]W :<C-u>update!<Cr>
nnoremap [Space]Q :<C-u>quit!<Cr>

nnoremap <C-h> :<C-u>h<Space>
nnoremap s<Space> i<Space><Esc>

" open .vimrc
nnoremap [Space]_ :<C-u>execute (empty(expand('%')) && !&modified ? 'edit ' : 'tabedit ') . $MYVIMRC<Cr>
nnoremap [Space]S :<C-u>source %<Cr>:nohlsearch<Cr>

nnoremap <Leader>g :<C-u>g/
nnoremap <Leader>s :<C-u>s/
nnoremap <Leader>S :<C-u>%s/
" enter substitute mode in visual mode
xnoremap <Leader>s :s/

nnoremap <Leader>ta :Tabularize<Space>/
xnoremap <Leader>ta :Tabularize<Space>/

nnoremap <Leader>te :<C-u>tabe<Space>
" Clear search highlight
nnoremap <silent> <C-l> <Esc>:<C-u>nohlsearch<Cr><C-l>

" move around windows
nnoremap <silent> sh <C-w>h
nnoremap <silent> sk <C-w>k
nnoremap <silent> sl <C-w>l
nnoremap <silent> sj <C-w>j

nnoremap <silent> sn :tabnext<Cr>
nnoremap <silent> sp :tabprevious<Cr>

" visual last put lines: p or gp
nnoremap sv `[v`]

nnoremap <MiddleMouse> <Nop>
nnoremap <2-MiddleMouse> <Nop>

" insert current file name
inoremap <silent> <Leader>fn <C-R>=@%<Cr>
" copy current file name to @" register
nnoremap <silent> <Leader>fn :let @" = @%<Cr>
" insert current file name (absolute path)
inoremap <silent> <Leader>fN <C-R>=fnamemodify(@%, ':p')<Cr>
nnoremap <silent> <Leader>fN :let @" = fnamemodify(@%, ':p')<Cr>

if s:is_mac && has('gui_running')
  inoremap <silent> <D-v> <Esc>:let &paste=1<Cr>a<C-R>=@*<Cr><Esc>:let &paste=0<Cr>a
  cnoremap <D-v> <C-R>*
  vnoremap <D-c> "+y
  nnoremap <D-a> ggVG
endif

" search visual-ed text
vnoremap * y/<C-R>"<Cr>
vnoremap < <gv
vnoremap > >gv

" like Eclipse's Alt+Up/Down
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

vnoremap <Down> :call <SID>move_block('d')<Cr>==gv
vnoremap <Up> :call <SID>move_block('u')<Cr>==gv


" format HTML/XML
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


if has('multi_byte_ime') || has('xim')
  set iminsert=0 imsearch=0
  inoremap <silent> <Esc> <Esc>:<C-u>set iminsert=0<Cr>
endif


" * autocmds "{{{
autocmd User Rails nnoremap <buffer> [Space]r :<C-u>R
augroup Tacahiroy
  autocmd BufReadPost * if !search('\S', 'cnw') | let &l:fileencoding = &encoding | endif
  " restore cursor position
  autocmd BufReadPost * if line("'\"") <= line('$') | execute "normal '\"" | endif
  " prevent auto comment insertion when 'o' pressed
  autocmd BufEnter * setlocal formatoptions-=o

  autocmd FileType *
        \  if &buftype !~# '^\(quickfix\|help\|nofile\)$'
        \|    nnoremap <buffer> <Return> :<C-u>call append(line('.'), '')<Cr>
        \| endif

  autocmd BufRead,BufNewFile *.frm,*.bas,*.cls,*.dsr setlocal filetype=vb
  autocmd FileType vb setlocal fileformat=dos

  " Chef
  autocmd BufRead,BufNewFile *
        \  if expand('%:p:h') =~# '.*/cookbooks/.*'
        \|   setlocal makeprg=foodcritic\ $*\ %
        \|   setlocal errorformat=%m:\ %f:%l
        \| endif

  autocmd FileType eruby*
        \  inoremap <silent> <buffer> <Leader>e <C-g>u<%=  %><Esc>F<Space>i
        \| inoremap <silent> <buffer> <Leader>b <C-g>u<%-  -%><Esc>F<Space>i
        \| inoremap <silent> <buffer> <Leader>d <C-g>u<%===  %><Esc>F<Space>i
        \| setlocal makeprg=erubis\ $*\ %

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

      let dir = '/' . join(dirs[0:idx], '/')
      let patterns = ['Gemfile', 'Rakefile', 'README*']
      for pat in patterns
        for f in split(glob(dir . '/' . pat))
          if filereadable(f)
            return dir
          endif
        endfor
      endfor
      let i += 1
    endwhile

    return a:dir
  endfunction

  function! s:auto_chdir(depth)
    if ! get(g:, 'auto_chdir_enabled', 1)
      return
    endif

    " fugitive:// or something
    if expand('%') =~# '^\S\+://'
      return
    endif

    let dir = s:get_project_root(expand('%:p:h'), a:depth)

    execute 'lcd ' . escape(dir, ' ')
  endfunction

  function! s:toggle_auto_chdir_mode()
    let g:auto_chdir_enabled = ! get(g:, 'auto_chdir_enabled', 1)
    call Echohl('Constant', 'AutoChdir: ' . (g:auto_chdir_enabled ? 'enabled' : 'disabled'))
  endfunction
  command! -nargs=0 -bang AutoChdirToggle call s:toggle_auto_chdir_mode()

  augroup PersistentUndo
    autocmd!
    autocmd BufWritePre
          \ COMMIT_EDITMSG,*.bak,*.bac,knife-edit-*.js,?.* setlocal noundofile
  augroup END

  autocmd BufRead,BufNewFile *.ru,Gemfile,Guardfile setlocal filetype=ruby
  autocmd BufRead,BufNewFile ?zshrc,?zshenv setlocal filetype=zsh

  function! s:insert_today_for_md_changelog()
    call append(line('.') - 1, strftime('%Y-%m-%d'))
    call append(line('.') - 1, '----------')
  endfunction
  autocmd BufRead,BufNewFile *.md,*.mkd,*.markdown setlocal filetype=markdown

  autocmd FileType markdown
        \  inoremap <buffer> <Leader>it <Esc>:<C-u>call <SID>insert_today_for_md_changelog()<Cr>:startinsert<Cr>
        \| inoremap <buffer> <Leader>ix [x]<Space>
  autocmd FileType markdown setlocal tabstop=4 shiftwidth=4

  autocmd FileType gitcommit setlocal spell
  autocmd FileType mail set spell
  autocmd FileType slim setlocal makeprg=slimrb\ -c\ %

  autocmd BufRead,BufNewFile *.applescript,*.scpt setfiletype applescript
  autocmd FileType applescript set commentstring=#\ %s

  autocmd FileType help,qf,logaling,bestfriend,ref-* nnoremap <buffer> <silent> qq <C-w>c
  autocmd FileType javascript* set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType rspec
        \  compiler rspec
        \| set omnifunc=rubycomplete#Complete
  autocmd FileType *ruby,rspec :execute 'setlocal iskeyword+=' . char2nr('?')
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType vim if &iskeyword !~# '&' | setlocal iskeyword+=& | endif
  autocmd FileType css,sass,scss,less setlocal omnifunc=csscomplete#CompleteCSS

  let g:loaded_sql_completion = 1
  autocmd FileType sql*,plsql setlocal tabstop=4 shiftwidth=4 softtabstop=4

  if executable('jsl')
    autocmd FileType javascript*,*html setlocal makeprg=jsl\ -conf\ \"$HOME/jsl.conf\"\ -nologo\ -nofilelisting\ -nosummary\ -nocontext\ -process\ %
    autocmd FileType javascript*,*html setlocal errorformat=%f(%l):\ %m
  endif

  " Chef
  autocmd BufRead,BufNewFile knife-edit-*.js,*.json setlocal filetype=javascript.json
  autocmd FileType *json* setlocal makeprg=python\ -mjson.tool\ 2>&1\ %\ >\ /dev/null
                       \| setlocal errorformat=%m:\ line\ %l\ column\ %c\ %.%#
  autocmd FileType *json* nnoremap <Leader>pp :%!json_xs -f json -t json-pretty<Cr>

  autocmd Filetype c setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd Filetype c compiler gcc
  autocmd FileType c setlocal makeprg=gcc\ -Wall\ %\ -o\ %:r.o
  autocmd FileType c nnoremap <buffer> [Space]m :<C-u>write<Cr>:make --std=c99<Cr>

  autocmd FileType markdown inoremap <buffer> <Leader>h1 <Esc>I#<Space>
                         \| inoremap <buffer> <Leader>h2 <Esc>I##<Space>
                         \| inoremap <buffer> <Leader>h3 <Esc>I###<Space>
                         \| inoremap <buffer> <Leader>h4 <Esc>I####<Space>
                         \| inoremap <buffer> <Leader>h5 <Esc>I#####<Space>
                         \| inoremap <buffer> <Leader>hr <Esc>i- - -<Esc>^
  autocmd FileType markdown set autoindent

  " simple markdown preview
  if executable('markdown')
    function! s:md_preview_by_browser(f)
      let tmp = '/tmp/vimmarkdown.html'
      call system('markdown ' . a:f . ' > ' . tmp)
      call system('open ' . tmp)
    endfunction
    autocmd FileType markdown command! -buffer -nargs=0 MdPreview call s:md_preview_by_browser(expand('%'))
  endif

  autocmd FileType xml noremap  <silent> <buffer> <Leader>pp :call <SID>run_tidy(80)<Cr>
  autocmd BufRead,BufEnter *.xml set updatetime=1000
  autocmd BufLeave,BufWinLeave *.xml set updatetime&

  autocmd BufRead,BufNewFile * syn match ExtraSpaces '[\t ]\+$'
        \| hi def link ExtraSpaces MatchParen

  " wonderful typo correction system
  inoreabbr funciton function
  inoreabbr requrie require
  inoreabbr reuqire require
  inoreabbr passowrd password
  inoreabbr ture true
  inoreabbr stating staging
augroup END
"}}}


" * Chef " {{{
" a wrapper of the knife command
if executable('knife')
  let s:knife = {} " knife {{{
  function! s:knife.cookbook_upload(...) abort
    let path = expand('%:p')
    if path !~# '/cookbooks/[^/]\+/.\+'
      return
    endif

    let cookbooks = [get(a:, 1, '')]
    echom path
    let m = matchlist(path, '^\(.\+/cookbooks\)/\([^/]\+\)/')
    let cb_path = m[1]
    if index(cookbooks, m[2]) == -1
      call insert(cookbooks, m[2])
    endif

    if len(cookbooks) > 0
      let cookbooks = filter(cookbooks, 'isdirectory(cb_path . "/" . v:val)')
      let mes = 'Uploading cookbook' . (len(cookbooks) != 1 ? 's' : '')
      let cmd = printf('knife cookbook upload -o %s %s;', cb_path, join(cookbooks))
      let cmd .= s:notify(join(cookbooks), 'Chef', $DOTVIM . '/images/chef_logo.png')

      if s:tmux.is_running()
        let cmd .= '; echo Press enter to close the pane.; read'
      endif

      echomsg printf('%s: %s', mes, join(cookbooks))
      " echomsg cmd
      " rough :|
      let cmd = "PATH=$HOME/.rbenv/shims:$PATH " . cmd
      call s:tmux.run(cmd, 1, 1)
    else
      echoerr 'no cookbooks are found.'
    endif
  endfunction

  " Convert a Chef element name to dirname
  " e.g. 'data_bags' -> 'data bag'
  function! s:knife.dir2ele(dir)
    return substitute(substitute(a:dir, '_', ' ', ''), 's$', '', '')
  endfunction

  function! s:knife.elename(path)
    for v in [ 'data_bags', 'environments', 'roles' ]
      if a:path =~# '/' . v . '/'
        return v
      endif
    endfor
  endfunction

  function! s:knife.from_file(json, opts)
    let path = fnamemodify(expand(a:json), ':p')
    let dirname = self.elename(path)
    let ele = self.dir2ele(dirname)

    if path !~# dirname
      call Echohl('WarningMsg', printf('%s is not a ' . ele . ' file.', path))
      return
    endif

    if ele ==# 'data bag'
      " BAG
      let item = fnamemodify(path, ':p:h:t')
      if empty(item)
        call Echohl('WarningMsg', printf('cannot get BAG name from %s', path))
        return
      endif
    else
      let item = ''
    endif

    " echom printf('!knife %s from file %s %s %s', ele, item, path, a:opts)
    execute printf('!knife %s from file %s %s %s', ele, item, path, a:opts)
  endfunction

  " commands and maps
  command! -nargs=* KnifeCookbookUpload call s:knife.cookbook_upload(<f-args>)
  command! -nargs=+ KnifeFromFile call s:knife.from_file(<q-args>, <q-args>)

  nnoremap [Space]K :<C-u>KnifeCookbookUpload<Cr>
endif
" }}}

" Cookbook utilities
let s:chef = {} " {{{
function! s:chef.convert_attr_notation(colon) abort
  if !search('\>', 'bcnW')
    return
  endif

  let [bufnbr, lnum, col, offset] = getpos('.')
  let line = getline(lnum)

  if match(line, '\.') == -1
    return
  endif

  let sc = self.find_attr_pos()
  let ec = col
  let l = matchstr(line, printf('.*\%%<%dc', sc))
  let r = matchstr(line, printf('\%%>%dc.*', ec))
  let attrs = split(matchstr(line, printf('\%%%dc.\+\%%%dc', sc - 1, ec + 1)), '\.')

  if a:colon
    let fmt = '"[:" . v:val . "]"'
  else
    let fmt = '"[\"" . v:val . "\"]"'
  endif

  let attr = attrs[0] . join(map(attrs[1:], fmt), '')
  call setline(lnum, l . attr . r)
  call setpos('.', [bufnbr, lnum, len(l . attr) + 1, 0])
  execute 'startinsert'
endfunction

function! s:chef.find_attr_pos()
  " let pos = searchpos('\(^\|\s\)', 'bnW')
  let pos = searchpos('\<\(node\|default\|normal\)\>', 'bnW')
  return pos[1] + 1
endfunction

command! -nargs=1 ChefConvertAttrNotation call s:chef.convert_attr_notation(<f-args>)
inoremap <silent> <C-y>x <C-g>u<Esc>:ChefConvertAttrNotation 1<Cr>
inoremap <silent> <C-y>X <C-g>u<Esc>:ChefConvertAttrNotation 0<Cr>
" }}}

" Get cmd-line for notification
function! s:notify(title, app, ...)
  if ! s:is_mac | return '' | endif

  if executable('terminal-notifier')
    return s:notification_center(a:title, a:app)
  elseif executable('growlnotify')
    return s:growlnotify(a:title, a:app, get(a:, 1, ''))
  else
    return ''
  endif
endfunction

function! s:growlnotify(title, app, ...)
  let icon = get(a:, 1, '')

  let cmd = 'if [ $? -eq 0 ]; then echo SUCCESS; else echo FAILURE; fi | '
  let cmd .= printf('growlnotify -n %s ', a:app)

  if !empty(icon)
    let cmd .= '--image ' . icon . ' '
  endif

  let cmd .= printf('\"%s\"', a:title)

  return cmd
endfunction

function! s:notification_center(title, app)
  let cmd = 'if [ $? -eq 0 ]; then echo SUCCESS; else echo FAILURE; fi | '
  let cmd .= printf('terminal-notifier -title %s -subtitle %s', a:app, a:title)
  return cmd
endfunction
" }}}


" * tmux " {{{
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
  let no_enter = get(a:, 3, 0)
  let is_control = (a:cmd =~# '^\^[a-zA-Z]$') || no_enter

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
