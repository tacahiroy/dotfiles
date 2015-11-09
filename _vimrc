" $HOME/.vimrc
" Author: Takahiro Yoshihara <tacahiroy@gmail.com>

set cpo&vim

if has('vim_starting')
  set encoding=utf-8
endif
set termencoding=utf-8
set verbose=0

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
function! Cwd()
  return '(' . s:shorten_path(getcwd(), 25) . ')'
endfunction

function! Monstermethod()
  return monstermethod#search()
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
  let g:auto_chdir_enabled = 0
  " syntax: vim.vim
  let g:vimsyntax_noerror = 1
endif

let s:ctrlp_matcher = 'ctrlp-cmatcher'
" let s:ctrlp_matcher = 'cpsm'

" * plugin management "{{{
call plug#begin($HOME . '/plugins.vim')

if s:ctrlp_matcher ==# 'ctrlp-cmatcher'
Plug 'JazzCore/ctrlp-cmatcher', { 'do': './install.sh' }
elseif s:ctrlp_matcher ==# 'cpsm'
Plug 'nixprime/cpsm'
endif
if has('patch-7.3.598')
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --gocode-completer' }
endif
Plug 'Raimondi/delimitMate'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'camelcasemotion'
Plug 'davidhalter/jedi-vim',            { 'for': 'python', 'do': 'pip install jedi' }
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'glidenote/memolist.vim',          { 'on': ['MemoList', 'MemoNew', 'MemoGrep'] }
Plug 'godlygeek/tabular',               { 'on': 'Tabularize' }
Plug 'justinmk/vim-dirvish'
Plug 'kien/rainbow_parentheses.vim'
Plug 'matchit.zip'
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dispatch', { 'on': 'Dispatch' }
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tyru/open-browser.vim'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }

Plug 'ctrlpvim/ctrlp.vim'
" Plug 'tacahiroy/ctrlp-funky', { 'branch': 'add-project-search-mode' }

if filereadable(expand('~/.vimrc.plugins'))
  source ~/.vimrc.plugins
endif

call plug#end()


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
  let g:ctrlp_mruf_tilde_homedir = 1
  let g:ctrlp_mruf_exclude = 'knife-edit-*.*\|COMMIT_EDITMSG'

  let g:ctrlp_user_command = {
    \ 'types': {
      \ 1: ['.git/', 'cd %s && git ls-files . -co --exclude-standard | grep -v "\.\(png\|jpg\)"'],
      \ 2: ['.hg/', 'hg --cwd %s locate -I .'],
      \ 3: ['.svn/', 'svn ls file://%s']
    \ },
    \ 'fallback': 'ag %s -i --nocolor --nogroup -p ~/.agignore --hidden -g ""',
  \ }

  if &runtimepath =~# 'cpsm'
    let g:ctrlp_match_func = { 'match': 'cpsm#CtrlPMatch' }
  elseif &runtimepath =~# 'ctrlp-cmatcher'
    let g:ctrlp_match_func = { 'match': 'matcher#cmatch' }
  endif

  " Set delay to prevent extra search
  let g:ctrlp_lazy_update = 120

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

  let dir = ['\.git$', '\.hg$', '\.svn$', '\.vimundo$', '\.cache/ctrlp$',
        \    '\.rbenv', '\.gem', 'backup', 'Documents', $TMPDIR,
        \    '/vendor/*/vendor']
  let g:ctrlp_custom_ignore = {
    \ 'dir': '\v[\/]' . join(dir, '|') . '/',
    \ 'file': '\v(\.exe|\.so|\.dll|\.DS_Store|\.db|COMMIT_EDITMSG)$'
    \ }

  let g:ctrlp_funky_debug = 0
  let g:ctrlp_funky_use_cache = 1
  let g:ctrlp_funky_matchtype = 'path'
  let g:ctrlp_funky_sort_by_mru = 0
  let g:ctrlp_funky_syntax_highlight = 1
  let g:ctrlp_funky_ruby_chef_words = 1

  let g:ctrlp_ssh_keep_ctrlp_window = 0

  nnoremap [Space]fl :CtrlPBuffer<Cr>
  nnoremap [Space]fm :CtrlPMRU<Cr><F5>
  nnoremap [Space]fi :CtrlPLine<Cr>
  nnoremap [Space]f. :CtrlPCurWD<Cr>
  nnoremap [Space]f, :CtrlPCurFile<Cr>
  nnoremap [Space]fr :CtrlPRTS<Cr>

  nnoremap [Space]fu :CtrlPFunky<Cr>
  nnoremap [Space]F  :CtrlPFunkyDeep<Cr>
  nnoremap [Space]uu :execute 'CtrlPFunky ' . fnameescape(expand('<cword>'))<Cr>
  nnoremap [Space]fs :CtrlPSSH<Cr>

  nnoremap [Space]t :CtrlPTag<Cr>

" plug: jedi-vim
  let g:jedi#auto_vim_configuration = 0

" plug: kien/rainbow_parentheses
  if &runtimepath =~# 'rainbow_parentheses.vim'
    augroup Tacahiroy
      autocmd VimEnter * RainbowParenthesesToggle
      autocmd Syntax * RainbowParenthesesLoadBraces
      autocmd Syntax * RainbowParenthesesLoadRound
      " autocmd Syntax * RainbowParenthesesLoadSquare
    augroup END
  endif

  let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['red',         'Darkblue'],
  \ ]

" plug: Valloric/YouCompleteMe
  let g:ycm_collect_identifiers_from_comments_and_strings = 1
  let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_complete_in_comments = 1

" plug: UltiSnips
  let g:UltiSnipsExpandTrigger = '<C-y>'
  let g:UltiSnipsJumpForwardTrigger = '<C-f>'
  let g:UltiSnipsJumpBackwardTrigger = '<C-b>'

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
  " nmap gx <Plug>(openbrowser-smart-search)
  " vmap gx <Plug>(openbrowser-smart-search)
  nmap gx <Plug>(openbrowser-open)

" plug: camelcasemotion
  map <silent> W <plug>CamelCaseMotion_w
  map <silent> B <plug>CamelCaseMotion_b
  map <silent> E <plug>CamelCaseMotion_e
  sunmap W
  sunmap B
  sunmap E

" plug: SQLUtilities
  let g:sqlutil_keyword_case = '\U'
  let g:sqlutil_align_comma = 1
  let g:sqlutil_align_where = 1

" plug: delimiteMate
  let delimitMate_expand_space = 1
  let delimitMate_expand_cr = 1
  let delimitMate_matchpairs = "(:),[:],{:}"
  augroup Tacahiroy
    autocmd FileType html,xml,eruby let b:delimitMate_matchpairs = &matchpairs
  augroup END
" }}}
" }}}

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
set clipboard=
set cmdheight=2
" this makes scroll slower
set colorcolumn=
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
set listchars=tab:^\ ,trail:-,extends:>,precedes:<
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

set shell&
for s in ['/usr/local/bin/zsh', '/bin/zsh', '/bin/bash', '/bin/sh']
  if executable(s)
    let &shell = s
    break
  endif
endfor

set shellslash
set shiftround
" let &showbreak = "\u279e  "
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

set t_Co=256
set background=light
colorscheme isotake

set formatoptions& formatoptions+=mM formatoptions-=r

" statusline config
let &statusline = '[#%n]%<%#FileName#%f%* %m%r%h%w'
let &statusline .= '%{&filetype}:'
let &statusline .= '%{(&l:fileencoding != "" ? &l:fileencoding : &encoding) . ":" . &fileformat}'
let &statusline .= '(%{&expandtab ? "" : ">"}%{&l:tabstop}'
let &statusline .= '%{search("\\t", "cnw") ? "!" : ""})'
let &statusline .= '%{(empty(&mouse) ? "" : "m")}'
let &statusline .= '%{(&list ? "L" : "")}'
let &statusline .= '%{(empty(&clipboard) ? "" : "c")}'
let &statusline .= '%{(&paste ? "p" : "")}'
let &statusline .= '|%{&textwidth}'
let &statusline .= '%#Type#'
let &statusline .= '%{fugitive#statusline()}'
let &statusline .= '%*'
let &statusline .= ' %=%#Structure#'
" let &statusline .= '%{Monstermethod()}'
let &statusline .= ' '
let &statusline .= '%#Title#'
let &statusline .= '%{Cwd()}'
let &statusline .= '%{(g:auto_chdir_enabled ? "e" : "d")}'
let &statusline .= '%-12( %#Statement#%l%#Title#/%LL,%c %)%P%*'
" }}}

" * mappings "{{{
" Emacs rules!??
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-o> <C-d>

" in case forgot to run vim w/o sudo
cnoremap W!! %!sudo tee > /dev/null %

" disable dangerous? mappings
nnoremap ZZ <Nop>
nnoremap s <Nop>
nnoremap Q <Nop>
nnoremap q <Nop>

" Q for macro
nnoremap Q q
" behaves like C / D
nnoremap Y y$

" * visual stuffs
nnoremap vv <C-v>
" visual the current column to end-of-line without <NL>
nnoremap vo vg_o
" like V, but without <NL>
nnoremap vO ^vg_o
" visual last put lines by p or gp
nnoremap sv `[v`]

nnoremap <C-]> <C-]>zz
nnoremap <C-t> <C-t>zz

nnoremap * *N
nnoremap # #N

nnoremap ; :<C-u>
nnoremap : ;
vnoremap ; :
vnoremap : ;

nnoremap j gj
nnoremap k gk

nnoremap <silent> <Return> :<C-u>call <SID>insert_blank_line()<Cr>
function! s:insert_blank_line()
  if !&readonly && &buftype !~# '\(quickfix\|help\|nofile\)'
    silent! call append(line('.'), '')
  endif
endfunction

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

" buffer navigations
nnoremap <silent> qn :bnext<Cr>
nnoremap <silent> qp :bprevious<Cr>
" tab navigations
nnoremap <silent> sn :tabnext<Cr>
nnoremap <silent> sp :tabprevious<Cr>

" window navigations
nnoremap <silent> sh <C-w>h
nnoremap <silent> sk <C-w>k
nnoremap <silent> sl <C-w>l
nnoremap <silent> sj <C-w>j

" show/hide line number wisely: this needs Vim 7.3 or above
function! s:toggle_line_number()
  if v:version <= 703 | return | endif
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

" mappings for toggle something
nnoremap <silent> [Toggle]m :let &mouse = empty(&mouse) ? 'a' : ''<Cr>
nnoremap <silent> [Toggle]p :set paste!<Cr>
nnoremap <silent> [Toggle]l :set list!<Cr>
nnoremap <silent> [Toggle]c :let &clipboard = empty(&clipboard) ? 'unnamed,unnamedplus' : ''<Cr>
nnoremap <silent> [Toggle]n :<C-u>silent call <SID>toggle_line_number()<Cr>

" * makes gf better
nnoremap gf <Nop>
" if <cfile> doesn't exist it'll be created
nnoremap gff :e <cfile><Cr>
" like gff, but open <cfile> in a tab
nnoremap gft :tabe <cfile><Cr>

" returns the command for system specific file manager
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

" open the current file's location using a file manager
function! s:open_with_file_manager(...)
  let cmd = s:get_filer_command()
  let path = get(a:, 1, s:convert_path(expand('%:p:h')))

  if empty(cmd)
    call Echohl('Error', 'Your system is not supported yet.')
    return
  endif

  execute printf('!%s %s', cmd, path)
endfunction
command! -nargs=? FileManager call s:open_with_file_manager(<f-args>)

" save / quit
nnoremap [Space]w :<C-u>update<Cr>
nnoremap [Space]q :<C-u>quit<Cr>
nnoremap [Space]W :<C-u>update!<Cr>
nnoremap [Space]Q :<C-u>quit!<Cr>

" copy to clipboard
nnoremap <silent> [Space]a :<C-u>let @* = @"<Cr>


" help
nnoremap <C-\> :<C-u>h<Space>
" put a whitespace into under the cursor
nnoremap s<Space> i<Space><Esc>

" opens .vimrc
nnoremap [Space]_ :<C-u>execute (empty(expand('%')) && !&modified ? 'edit ' : 'tabedit ') . $MYVIMRC<Cr>
nnoremap [Space]S :<C-u>source %<Cr>:nohlsearch<Cr>

" global and substitutes
nnoremap <Leader>g :<C-u>g/
nnoremap <Leader>s :<C-u>s/
nnoremap <Leader>S :<C-u>%s/
xnoremap <Leader>s :s/

nnoremap <Leader>ta :Tabularize<Space>/
xnoremap <Leader>ta :Tabularize<Space>/

nnoremap <Leader>te :<C-u>tabe<Space>
" clears search highlight
nnoremap <silent> <C-l> <Esc>:<C-u>nohlsearch<Cr><C-l>

" no mouse basically
nnoremap <MiddleMouse> <Nop>
nnoremap <2-MiddleMouse> <Nop>

" insert current file name
inoremap <silent> <Leader>fn <C-R>=expand('%:t')<Cr>
" copy current file name to @" register
nnoremap <silent> <Leader>fn :let @" = expand('%:t')<Cr>
" insert current file name (absolute path)
inoremap <silent> <Leader>fN <C-R>=fnamemodify(@%, ':p')<Cr>
nnoremap <silent> <Leader>fN :let @" = fnamemodify(@%, ':p')<Cr>

inoremap <Leader>a <Cr><Esc>O

" search visual-ed text
vnoremap * y/<C-R>"<Cr>
vnoremap < <gv
vnoremap > >gv

" like Eclipse's Alt+Up/Down
function! s:move_block(d) range
  let [sign, cnt] = a:d is# 'u' ? ['-', 2] : ['+', a:lastline-a:firstline+1]
  execute printf('%d,%dmove%s%d', a:firstline, a:lastline, sign, cnt)
endfunction
vnoremap <C-p> :call <SID>move_block('u')<Cr>==gv
vnoremap <C-n> :call <SID>move_block('d')<Cr>==gv

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
augroup Tacahiroy
  autocmd BufReadPost * if !search('\S', 'cnw') | let &l:fileencoding = &encoding | endif
  " restore cursor position
  autocmd BufReadPost * if line("'\"") <= line('$') | execute "normal '\"" | endif
  " prevent auto comment insertion when 'o' pressed
  autocmd BufEnter * setlocal formatoptions-=o

  "my ftdetects
  autocmd BufRead,BufNewFile *.ru,Gemfile,Guardfile set filetype=ruby
  autocmd BufRead,BufNewFile ?zshrc,?zshenv set filetype=zsh
  autocmd BufRead,BufNewFile *.as set filetype=actionscript
  autocmd BufRead,BufNewFile *.gradle set filetype=groovy

  " Chef
  autocmd BufRead,BufNewFile *.rb
        \  if expand('%:p:h') =~# '.*/cookbooks/.*'
        \|   setlocal makeprg=foodcritic\ $*\ %
        \|   setlocal errorformat=%m:\ %f:%l
        \| endif

  autocmd FileType eruby* inoremap <silent> <buffer> <Leader>e <C-g>u<%=  %><Esc>F<Space>i
  autocmd FileType eruby* inoremap <silent> <buffer> <Leader>b <C-g>u<%-  -%><Esc>F<Space>i
  autocmd FileType eruby* inoremap <silent> <buffer> <Leader>d <C-g>u<%===  %><Esc>F<Space>i
  autocmd FileType eruby* setlocal makeprg=erubis\ $*\ %

  " Visual Basic
  autocmd BufRead,BufNewFile *.frm,*.bas,*.cls,*.dsr set filetype=vb
  autocmd FileType vb setlocal fileformat=dos

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
    if !get(g:, 'auto_chdir_enabled', 1)
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
    let g:auto_chdir_enabled = !get(g:, 'auto_chdir_enabled', 1)
    call Echohl('Constant', 'AutoChdir: ' . (g:auto_chdir_enabled ? 'enabled' : 'disabled'))
  endfunction
  command! -nargs=0 -bang AutoChdirToggle call s:toggle_auto_chdir_mode()

  augroup PersistentUndo
    autocmd!
    autocmd BufWritePre
          \ COMMIT_EDITMSG,*.bak,*.bac,knife-edit-*.js,?.* setlocal noundofile
  augroup END

  function! s:insert_today_for_md_changelog()
    call append(line('.') - 1, strftime('%Y-%m-%d'))
    call append(line('.') - 1, repeat('=', 10))
  endfunction
  autocmd BufRead,BufNewFile *.md,*.mkd,*.markdown set filetype=markdown

  autocmd FileType markdown inoremap <buffer> <Leader>tt <Esc>:<C-u>call <SID>insert_today_for_md_changelog()<Cr>:startinsert<Cr>
  autocmd FileType markdown set autoindent
  autocmd FileType markdown setlocal tabstop=4 shiftwidth=4
  autocmd FileType markdown inoremap <buffer> <Leader>h1 #<Space>
  autocmd FileType markdown inoremap <buffer> <Leader>h2 ##<Space>
  autocmd FileType markdown inoremap <buffer> <Leader>h3 ###<Space>
  autocmd FileType markdown inoremap <buffer> <Leader>h4 ####<Space>
  autocmd FileType markdown inoremap <buffer> <Leader>h5 #####<Space>

  autocmd FileType gitcommit setlocal spell
  autocmd FileType mail setlocal spell

  autocmd BufRead,BufNewFile *.applescript,*.scpt set filetype=applescript
  autocmd FileType applescript set commentstring=#\ %s

  " map qq to close the window
  autocmd FileType help,qf,logaling,bestfriend,ref-* nnoremap <buffer> <silent> qq <C-w>c
  autocmd FileType rspec compiler rspec
  autocmd FileType rspec set omnifunc=rubycomplete#Complete
  autocmd FileType ruby,eruby,rspec :execute 'setlocal iskeyword+=' . char2nr('?')
  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType vim if &iskeyword !~# '&' | setlocal iskeyword+=& | endif
  autocmd FileType css,sass,scss,less setlocal omnifunc=csscomplete#CompleteCSS

  autocmd FileType sql setlocal tabstop=4 shiftwidth=4 softtabstop=4

  " Java
  autocmd FileType java setlocal tabstop=4 shiftwidth=4 softtabstop=4
  autocmd FileType java setlocal omnifunc=javacomplete#Complete
  let java_highlight_java_lang_ids = 1
  let java_highlight_java_io = 1

  autocmd FileType javascript,javascript.json set omnifunc=javascriptcomplete#CompleteJS
  if executable('jsl')
    autocmd FileType javascript,html setlocal makeprg=jsl\ -conf\ \"$HOME/jsl.conf\"\ -nologo\ -nofilelisting\ -nosummary\ -nocontext\ -process\ %
    autocmd FileType javascript,html setlocal errorformat=%f(%l):\ %m
  endif

  " Chef
  autocmd BufRead,BufNewFile knife-edit-*.js,*.json set filetype=javascript.json
  autocmd FileType json setlocal makeprg=python\ -mjson.tool\ 2>&1\ %\ >\ /dev/null
  autocmd FileType json setlocal errorformat=%m:\ line\ %l\ column\ %c\ %.%#
  autocmd FileType json nnoremap <Leader>pp :%!json_xs -f json -t json-pretty<Cr>

  autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4
  autocmd FileType c compiler gcc
  autocmd FileType c setlocal makeprg=gcc\ -Wall\ %\ -o\ %:r.o
  autocmd FileType c nnoremap <buffer> [Space]m :<C-u>write<Cr>:make --std=c99<Cr>

  " simple markdown preview
  if executable('markdown')
    function! s:md_preview_by_browser(f)
      let tmp = '/tmp/vimmarkdown.html'
      call system('markdown ' . a:f . ' > ' . tmp)
      call system('open ' . tmp)
    endfunction
    autocmd FileType markdown command! -buffer -nargs=0 MdPreview call s:md_preview_by_browser(expand('%'))
  endif

  " I know this shouldn't be here
  autocmd InsertEnter * hi StatusLine guibg=Orange ctermbg=LightMagenta
  autocmd InsertLeave * hi StatusLine guibg=SkyBlue ctermbg=LightCyan
augroup END
"}}}


if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
endif

" gVim specific
if has('gui_running')
  set columns=132
  set guioptions=aeciM
  set guitablabel=%N)\ %f
  set lines=100
  set mousehide
  set nomousefocus

  " Disable GUI /Syntax/ menu
  let did_install_syntax_menu = 1
  " let did_install_default_menus = 1

  if &guioptions =~# 'M'
    let &guioptions = substitute(&guioptions, '[mT]', '', 'g')
  endif

  if s:is_mac
    set guifont=MyricaM\ monospace:h14
    set linespace=1
    set antialias
    set fuoptions& fuoptions+=maxhorz

    inoremap <silent> <D-v> <Esc>:let &paste=1<Cr>a<C-R>=@*<Cr><Esc>:let &paste=0<Cr>a
    cnoremap <D-v> <C-R>*
    vnoremap <D-c> "+y
    nnoremap <D-a> ggVG
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

" __END__ {{{
" vim: fen fdm=marker ts=2 sts=2 sw=2
