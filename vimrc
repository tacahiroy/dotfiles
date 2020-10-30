" $HOME/.vimrc
" Author: Takahiro Yoshihara <tacahiroy@gmail.com>

set cpo&vim

if has('vim_starting')
  set encoding=utf-8
  set termencoding=utf-8
endif
set verbose=0

scriptencoding utf-8

let g:mapleader = ','

" Clear all autocmds in the default group
autocmd!
augroup Tacahiroy
  autocmd!
augroup END

let s:mac = has('macunix') || has('mac')
let s:linux = !s:mac && has('unix')
let s:win = !(s:mac || s:linux) && has('win32') || has('win64')
let s:grep = executable('rg') ? 'rg' : (executable('ag') ? 'ag' : '')
let s:grep = 'ag'
let g:show_cwd = 1

" functions " {{{
" * global
function! Echohl(group, msg)
  execute printf('echohl %s | echomsg "%s" | echohl NONE', a:group, a:msg)
endfunction

" To realise where I am
function! Cwd()
  return '(' . s:shorten_path(getcwd(), 25) . ')'
endfunction

function! s:has_plugin(plugin)
  return &runtimepath =~# a:plugin
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
function! s:append_blank_line()
  silent! call append(line('.'), '')
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

function! s:xclip()
  if isdirectory('/mnt/c') && executable('xclip')
    let tmp = tempname()
    call writefile([getreg('"')], tmp)
    call system('xclip -d :0 -i ' . tmp)
    call delete(tmp)
    echomsg 'Copied!'
  elseif has('xterm_clipboard')
    let @+ = @"
  else
    let @* = @"
  endif
endfunction

function! s:ins_note_template(title)
  let s = []
  call add(s, printf('title: %s', a:title))
  call add(s, '==========')
  call add(s, printf('date: %s', strftime('%Y-%m-%d %T')))
  call add(s, 'tags: []')
  call add(s, '- - -')
  let i = 1
  for y in s
    call setline(i, y)
    let i += 1
  endfor
endfunction

function! s:create_new_note()
  while 1
    let ans = input('New note> ')
    if !empty(ans)
      break
    endif
  endwhile
  let title = substitute(ans, '[\t /\\:?\*<>|]', '-', 'g')
  execute printf('edit %s/%s-%s.md', g:note_path, strftime('%Y-%m-%d'), title)
  call s:ins_note_template(ans)
endfunction
"}}}

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

" Toggle
nnoremap [Toggle] <Nop>
nmap <Leader><Leader> [Toggle]
" Space
nnoremap [Space] <Nop>
map <Space> [Space]

" * plugin management "{{{
silent! packadd minpac

call minpac#init()

" minpac must have {'type': 'opt'} so that it can be loaded with `packadd`.
call minpac#add('k-takata/minpac', {'type': 'opt'})

call minpac#add('tpope/vim-fugitive')

" Completion {{{
" call minpac#add('prabirshrestha/async.vim')
call minpac#add('prabirshrestha/vim-lsp')
  let g:lsp_use_lua = (has('lua') && has('patch-8.2.0775'))
  let g:lsp_async_completion = 1 "{{{ vim-lsp
  let g:lsp_diagnostics_enabled = 0
  let g:lsp_diagnostics_echo_cursor = 0
  let g:lsp_signs_enabled = 0
  let g:lsp_signs_error = {'text': '🤬'}
  let g:lsp_signs_warning = {'text': '🤢'}
  let g:lsp_signs_hint = {'text': '🐑'}
  let g:lsp_log_verbose = 0
  " let g:lsp_log_file = expand('~/vim-lsp.log')

  function! s:on_lsp_buffer_enabled() abort
      setlocal omnifunc=lsp#complete
      setlocal signcolumn=auto
      if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
      nmap <buffer> gd <plug>(lsp-definition)
      nmap <buffer> <Leader>rr <plug>(lsp-references)
      nmap <buffer> <Leader>ri <plug>(lsp-implementation)
      nmap <buffer> <Leader>rt <plug>(lsp-type-definition)
      nmap <buffer> <leader>rm <plug>(lsp-rename)
      nmap <buffer> <Leader>rp <Plug>(lsp-previous-diagnostic)
      nmap <buffer> <Leader>rn <Plug>(lsp-next-diagnostic)
      nmap <buffer> <Leader>rw <Plug>(lsp-workspace-symbol)
      nmap <buffer> K <plug>(lsp-hover)
  endfunction

  augroup lsp_install
      autocmd!
      " call s:on_lsp_buffer_enabled only for languages that has the server registered.
      autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END

  augroup LspEFM
    au!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'efm-langserver',
        \ 'cmd': {server_info->['efm-langserver', '-c=$HOME/.config/efm-langserver/config.yaml']},
        \ 'whitelist': ['markdown'],
        \ })
  augroup END
"}}}

call minpac#add('mattn/vim-lsp-settings')

call minpac#add('prabirshrestha/asyncomplete.vim')
  let g:asyncomplete_smart_completion = has('lua')
  let g:asyncomplete_auto_popup = 1
  let g:asyncomplete_popup_delay = 200
  let g:asyncomplete_remove_duplicates = 1
  " let g:asyncomplete_log_file = expand('~/asyncomplete.log')

call minpac#add('prabirshrestha/asyncomplete-lsp.vim')
call minpac#add('prabirshrestha/asyncomplete-buffer.vim')
  augroup Tacahiroy
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
          \ 'name': 'buffer',
          \ 'whitelist': ['*'],
          \ 'blacklist': ['go', 'markdown'],
          \ 'completor': function('asyncomplete#sources#buffer#completor'),
          \ 'config': {
          \    'max_buffer_size': 5242880,
          \  },
          \ }))
  augroup END

call minpac#add('fatih/vim-go')
  let g:go_def_mode = 'gopls'
  let g:go_info_mode = 'gopls'
  let g:go_gopls_enabled = 1
  let g:go_highlight_diagnostic_errors = 0
  let g:go_highlight_diagnostic_warnings = 0

call minpac#add('stephpy/vim-yaml')
call minpac#add('cohama/lexima.vim')
  " let g:lexima_no_default_rules = 1
  let g:lexima_enable_space_rules = 0
  let g:lexima_enable_endwise_rule = 1

call minpac#add('bkad/CamelCaseMotion')

call minpac#add('godlygeek/tabular')
call minpac#add('luochen1990/rainbow')
  let g:rainbow_active = 1
  let g:rainbow_conf = {}
  let g:rainbow_conf.guifgs = ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick']
  let g:rainbow_conf.ctermfgs = ['darkblue', 'darkyellow', 'darkgreen', 'darkgray', 'darkmagenta']
  let g:rainbow_conf.operators = '_,_'
  let g:rainbow_conf.parentheses = ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold']
  let g:rainbow_conf.separately = { '*': {} }

call minpac#add('benjifisher/matchit.zip')
call minpac#add('tpope/vim-commentary')
  nmap [Space]c gcc
  nmap [Space]yc yygccp
  xmap [Space]c gc
  xmap [Space]yc ygvgcgv<Esc>p

call minpac#add('tpope/vim-surround')
  nmap ye ys$
  xmap s <Plug>VSurround

" {{{ ctrlp.vim
call minpac#add('ctrlpvim/ctrlp.vim')
  let g:ctrlp_by_filename = 0
  let g:ctrlp_map = '<Space>e'
  let g:ctrlp_cmd = 'CtrlP'
  let g:ctrlp_switch_buffer = 'Et'
  let g:ctrlp_tabpage_position = 'ac'
  let g:ctrlp_working_path_mode = 'ra'
  let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max10,results:50'
  let g:ctrlp_max_height = 20
  let g:ctrlp_clear_cache_on_exit = 1
  let g:ctrlp_follow_symlinks = 1
  let g:ctrlp_max_files = 10000
  let g:ctrlp_max_depth = 10
  let g:ctrlp_show_hidden = 0
  let g:ctrlp_mruf_max = 1024
  let g:ctrlp_mruf_tilde_homedir = 1
  let g:ctrlp_mruf_exclude = 'COMMIT_EDITMSG'
  let g:ctrlp_mruf_default_order = 1
  let g:ctrlp_path_nolim = 0
  " Set delay to prevent extra search
  let g:ctrlp_lazy_update = 200
  let g:ctrlp_brief_prompt = 1
  let g:ctrlp_key_loop = 1
  let g:ctrlp_use_caching = 0

  if s:grep ==# 'rg'
    let g:ctrlp_user_command = 'rg %s -i --files --no-heading --max-depth 10'
  elseif s:grep ==# 'ag'
    let g:ctrlp_user_command = 'ag %s -g "" --depth 10'
  elseif s:grep ==# ''
    if s:linux || s:mac
      let g:ctrlp_user_command = 'find %s -type f'
    else
      let g:ctrlp_user_command = 'dir %s /-n /b /s /a-d'
    endif
  endif

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

  nnoremap [Space]fl :CtrlPBuffer<Cr>
  nnoremap [Space]fm :CtrlPMRU<Cr><F5>
  nnoremap [Space]fi :CtrlPLine<Cr>
  nnoremap [Space]f. :CtrlPCurWD<Cr>
  nnoremap [Space]f, :CtrlPCurFile<Cr>
  nnoremap [Space]fr :CtrlPRTS<Cr>
  nnoremap [Space]fq :CtrlPQuickfix<Cr>

call minpac#add('tacahiroy/ctrlp-funky', { 'frozen': 1 })
  let g:ctrlp_funky_debug = 0
  let g:ctrlp_funky_use_cache = 0
  let g:ctrlp_funky_matchtype = 'path'
  let g:ctrlp_funky_sort_by_mru = 0
  let g:ctrlp_funky_syntax_highlight = 0
  let g:ctrlp_funky_filter_conversions = { 'yaml.ansible': 'ansible' }

  let g:ctrlp_funky_nudists = ['php', 'ruby']

  nnoremap [Space]fu :CtrlPFunky<Cr>
  nnoremap [Space]uu :execute 'CtrlPFunky ' . fnameescape(expand('<cword>'))<Cr>

if has('python3')
  call minpac#add('FelikZ/ctrlp-py-matcher')
    let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
    let g:ctrlp_match_current_file = 0 " to include current file in matches
endif

"{{{ ALE
  call minpac#add('dense-analysis/ale')
    let g:ale_enabled = 1
    let g:ale_lint_on_text_changed = 'never'
    let g:ale_set_loclist = 0
    let g:ale_set_quickfix = 1
    let g:ale_disable_lsp = 1

    let g:ale_history_log_output = 1
    let g:ale_use_global_executables = 1
    let g:ale_fix_on_save = 1
    let g:ale_completion_enabled = 0

    let g:ale_linters = {'html': ['eslint'],
                       \ 'python': ['pyls', 'flake8'],
                       \ 'yaml': ['yamllint']}
    let g:ale_fixers = {'python': ['black', 'yapf'],
          \             '*': ['remove_trailing_lines', 'trim_whitespace'],
          \             'Jenkinsfile': ['jenkins_linter'],
          \ }

    let g:ale_python_auto_pipenv = 1
    let g:ale_python_flake8_auto_pipenv = 1
    let g:ale_yaml_yamllint_options = '-c $HOME/.config/yamllint/ansible.yml'

    function! LinterStatus() abort
      let l:counts = ale#statusline#Count(bufnr(''))

      let l:all_errors = l:counts.error + l:counts.style_error
      let l:all_non_errors = l:counts.total - l:all_errors

      return l:counts.total == 0 ? '🦄' : printf(
      \   '🤔%d🥶%d',
      \   all_non_errors,
      \   all_errors
      \)
    endfunction
  "}}}

  call minpac#add('Yggdroot/indentLine')

  " call minpac#add('sheerun/vim-polyglot')
  "   let g:polyglot_disabled = ['markdown']

  call minpac#add('tacahiroy/vim-colors-isotake')
  call minpac#add('mechatroner/rainbow_csv')
  call minpac#add('jremmen/vim-ripgrep')

  if has('python3')
    call minpac#add('SirVer/ultisnips')
      let g:UltiSnipsExpandTrigger = "<C-e>"
      let g:UltiSnipsListSnippets = "<C-j>"
      let g:UltiSnipsJumpForwardTrigger = "<C-y>"
      let g:UltiSnipsJumpBackwardTrigger = "<C-j>"

      " If you want :UltiSnipsEdit to split your window.
      let g:UltiSnipsEditSplit = "vertical"

    call minpac#add('honza/vim-snippets')

    call minpac#add('prabirshrestha/asyncomplete-ultisnips.vim')
      augroup Tacahiroy
        autocmd User asyncomplete_setup
              \ call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
              \ 'name': 'ultisnips',
              \ 'whitelist': ['*'],
              \ 'completor': function('asyncomplete#sources#ultisnips#completor'),
              \ }))
      augroup END
  endif

  call minpac#add('mattn/emmet-vim')

  if filereadable(expand('~/.vimrc.plugins'))
    source ~/.vimrc.plugins
  endif

  packload

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
"}}}
" set completeopt=preview,menuone,noinsert,noselect
set completeopt+=preview"}}}

" Super simple note taking
let g:note_path = expand('~/dev/memo')
command! -nargs=1 InsertNoteTemplate call <SID>ins_note_template(<q-args>)
command! -nargs=0 NewNote call <SID>create_new_note()
nnoremap [Space]mc :NewNote<Cr>
nnoremap [Space]ml :execute 'CtrlP ' . g:note_path<Cr><F5>

" plug: camelcasemotion
  map <silent> W <plug>CamelCaseMotion_w
  map <silent> B <plug>CamelCaseMotion_b
  map <silent> E <plug>CamelCaseMotion_e
  sunmap W
  sunmap B
  sunmap E
" }}} plugin management

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
set backupskip& backupskip+=/tmp/*,/private/tmp/*,*.bac,COMMIT_EDITMSG,svn-commit.[0-9]*.tmp
set belloff=backspace,cursor,esc,insertmode
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
if s:grep ==# 'rg'
  let &grepprg = 'rg --no-heading --ignore-file ~/.gitignore'
elseif s:grep ==# ''
  if s:linux
    let &grepprg = 'grep --color=none'
  else
    let &grepprg = 'findstr /n'
  endif
endif
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
set nrformats=hex
set pastetoggle=<F2>
set previewheight=8
set pumheight=24
" scroll half lines of window height
set scroll=0
set scrolloff=5

set shell&
for s in ['/usr/bin/bash', '/bin/bash', '/usr/local/bin/zsh', '/usr/bin/zsh', '/bin/zsh', '/bin/sh']
  if executable(s)
    let &shell = s
    break
  endif
endfor

set shellslash
set shiftround
let &showbreak = nr2char(8618) . ' '
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
set synmaxcol=150
set tags=tags,./tags
set timeout timeoutlen=500
set title
set titlestring=Vim:\ %F\ %h%r%m
set titlelen=255
set tabstop=2 shiftwidth=2 softtabstop=2
set updatetime=2000
set viminfo='64,<100,s10,n~/.viminfo
set virtualedit=block,onemore
set t_vb= novisualbell

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

filetype plugin indent on
syntax on

set t_Co=256

set formatoptions& formatoptions+=mM formatoptions-=r

function! s:set_statusline()
  " statusline config
  let &statusline = '#%n|'
  let &statusline .= '%<%t%*|%m%r%h%w'
  let &statusline .= '%{&expandtab ? "" : ">"}%{&l:tabstop}'
  let &statusline .= '%{search("\\t", "cnw") ? "!" : ""}'
  let &statusline .= '%{(empty(&mouse) ? "" : "m")}'
  let &statusline .= '%{(&list ? "L" : "")}'
  let &statusline .= '%{(empty(&clipboard) ? "" : "c")}'
  let &statusline .= '%{(&paste ? "p" : "")}'
  let &statusline .= '|%{&textwidth}'

  if exists('*LinterStatus')
    let &statusline .= '%{LinterStatus()}'
  endif

  if exists('*FugitiveStatusline')
    let &statusline .= '%#Type#'
    let &statusline .= '%{winwidth(0) > 100 ? fugitive#statusline() : ""}'
    let &statusline .= '%*'
  endif

  if exists('*virtualenv#statusline')
    let g:virtualenv_stl_format = '[%n]'
    let &statusline .= '%{virtualenv#statusline()}'
  endif

  " right side from here
  let &statusline .= ' %='
  " Cwd
  let &statusline .= '%#CursorLineNr#'
  let &statusline .= '%{winwidth(0) > 100 ? (get(g:, "show_cwd", 0) ? Cwd() : "") : ""}'
  " ft:fenc:ff
  let &statusline .= '%*'
  let &statusline .= '%{&filetype}:'
  let &statusline .= '%{(&l:fileencoding != "" ? &l:fileencoding : &encoding) . ":" . &fileformat}'
  let &statusline .= '%-10(%#MoreMsg#%l%#Title#/%L:%c %)%P%*'
endfunction

augroup Tacahiroy
  autocmd VimEnter * call s:set_statusline()
augroup END
" }}}
" * mappings "{{{
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-o> <C-d>
inoremap <C-f> <Right>
inoremap <C-b> <Left>

" in case forgot to run vim w/o sudo
cnoremap W!! %!sudo tee > /dev/null %

" disable dangerous / unwanted mappings
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
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
nnoremap so gv<Esc>
nnoremap sap va}V
nnoremap su :<C-u>call <SID>toggle_case(1)<Cr>
nnoremap sl :<C-u>call <SID>toggle_case(0)<Cr>
nnoremap [Space]te :<C-u>terminal<Cr>

function! s:toggle_case(upper)
  let [_, l, c, _] = getpos('.')
  let keys = a:upper ? 'gUaw' : 'guaw'
  echom 'normal! ' . keys
  execute 'normal! ' . keys
  call cursor(l, c)
endfunction

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

" quickfix related mappings
nnoremap <silent> qo :<C-u>silent call <SID>toggle_qf_list()<Cr>
nnoremap <silent> q[ :cprevious<Cr>zz
nnoremap <silent> q] :cnext<Cr>zz
nnoremap <silent> qc :cc<Cr>zz

" buffer navigations
nnoremap <silent> qn :bnext<Cr>
nnoremap <silent> qp :bprevious<Cr>
" tab navigations
nnoremap <silent> gn :tabnext<Cr>
nnoremap <silent> gh :tabprevious<Cr>

" window navigations
nnoremap <silent> sh <C-w>h
nnoremap <silent> se <C-w>k
nnoremap <silent> si <C-w>l
nnoremap <silent> sn <C-w>j

nnoremap <silent> <Return> :<C-u>call <SID>append_blank_line()<Cr>

" show/hide line number wisely: this needs Vim 7.3 or above
function! s:toggle_line_number()
  if v:version <= 703 | return | endif

  let b:prev = get(b:, 'prev', {})

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
nnoremap <silent> [Toggle]s :set spell!<Cr>
nnoremap <silent> [Toggle]n :<C-u>silent call <SID>toggle_line_number()<Cr>
nnoremap <silent> [Toggle]r :set relativenumber!<Cr>
nnoremap <silent> [Toggle]w :let g:show_cwd = abs(get(g:, 'show_cwd', 0) - 1)<Cr>
nnoremap <silent> [Toggle]b :let &background = &background ==# 'dark' ? 'light' : 'dark'<Cr>
nnoremap <silent> [Toggle]i :IndentLinesToggle<Cr>

" * makes gf better
nnoremap gf <Nop>
" if <cfile> doesn't exist it'll be created
nnoremap gff :e <cfile><Cr>
" like gff, but open <cfile> in a tab
nnoremap gft :tabe <cfile><Cr>

" save / quit
nnoremap [Space]w <Esc>:<C-u>update<Cr>
nnoremap [Space]q <Esc>:<C-u>quit<Cr>
nnoremap [Space]W <Esc>:<C-u>update!<Cr>
nnoremap [Space]Q <Esc>:<C-u>quit!<Cr>

" help
nnoremap <Leader>h :<C-u>h<Space>
" put a whitespace into under the cursor
nnoremap s<Space> i<Space><Esc>

" opens .vimrc
nnoremap [Space]_ :<C-u>execute (empty(expand('%')) && !&modified ? 'edit ' : 'tabedit ') . $MYVIMRC<Cr>
nnoremap [Space]S :<C-u>source %<Cr>:nohlsearch<Cr>

" global and substitutes
nnoremap <Leader>g :<C-u>g/
nnoremap <Leader>v :<C-u>v/
nnoremap <Leader>s :<C-u>s/
nnoremap <Leader>S :<C-u>%s/
xnoremap <Leader>s :s@

nnoremap <Leader>ta :Tabularize<Space>/
xnoremap <Leader>ta :Tabularize<Space>/

nnoremap <Leader>te :<C-u>tabe<Space>
" clears search highlight
nnoremap <silent> <C-l> :<C-u>nohlsearch<Cr>

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

inoremap <Leader><Leader>c <Esc>bgUwgi

" Copy absolute path to current file to clipboard
command! -nargs=0 CopyCurrentFilePath2CB let @* = fnamemodify(@%, ':p')
command! -nargs=0 AbsolutePath echomsg fnamemodify(@%, ':p')
command! -nargs=0 RelativePath echomsg substitute(fnamemodify(@%, ':p'), getcwd() . '/', '', '')

command! -nargs=0 Xclip execute ':!cat % | xclip'

" search visual-ed text
vnoremap * y/<C-R>"<Cr>

" like Eclipse's Alt+Up/Down
function! s:move_block(d) range
  let [sign, cnt] = a:d is# 'u' ? ['-', 2] : ['+', a:lastline-a:firstline+1]
  execute printf('%d,%dmove%s%d', a:firstline, a:lastline, sign, cnt)
endfunction
vnoremap <C-p> :call <SID>move_block('u')<Cr>==gv
vnoremap <C-n> :call <SID>move_block('d')<Cr>==gv

" format HTML/XML
function! s:run_tidy(...) range
  if !executable('tidy')
    call Echohl('Error', 'tidy is not installed or not in PATH.')
    return 0
  endif

  " this code is not perfect.
  " tidy's Character encoding option and Vim's fileencoding/encoding is not a pair
  let col = get(a:, 1, 80)
  let enc = &l:fileencoding ? &l:fileencoding : &encoding
  let enc = substitute(enc, '-', '', 'g')

  silent execute printf('%d,%d!tidy -xml -i -%s -wrap %d -q -asxml', a:firstline, a:lastline, enc, eval(col))
endfunction

command! -nargs=? -range Tidy <line1>,<line2>call s:run_tidy(<args>)
"}}}

if has('pythonx') "{{{
  runtime! autoload/tacahiroy/python.vim

  function! s:format_sql() range
    pythonx format_sql(firstline=int(vim.eval('a:firstline'))-1, lastline=int(vim.eval('a:lastline'))-1)
  endfunction

  function! s:encode_uri() range
    pythonx encode(int(vim.eval('a:firstline'))-1, int(vim.eval('a:lastline'))-1)
  endfunction

  function! s:decode_uri() range
    pythonx decode(int(vim.eval('a:firstline'))-1, int(vim.eval('a:lastline'))-1)
  endfunction

  command! -nargs=? -range PrettifySQL <line1>,<line2>call s:format_sql()
  command! -nargs=0 -range EncodeURI <line1>,<line2>call s:encode_uri()
  command! -nargs=0 -range DecodeURI <line1>,<line2>call s:decode_uri()
endif

if has('multi_byte_ime') || has('xim')
  set iminsert=0 imsearch=0
  inoremap <silent> <Esc> <Esc>:<C-u>set iminsert=0<Cr>
endif

" * autocmds "{{{
augroup Tacahiroy
  autocmd VimEnter * call lexima#add_rule({'char': '(', 'at': '\%#\w', 'input': '('})
  autocmd VimEnter * call lexima#add_rule({'char': '"', 'at': '\%#\w', 'input': '"'})
  autocmd VimEnter * call lexima#add_rule({'char': "'", 'at': '\%#\w', 'input': "'"})

  autocmd BufRead,BufNewFile */playbooks/*.yml,*/tasks/*.yml,*/handlers/*.yml set filetype=yaml.ansible

  autocmd BufEnter ControlP let b:ale_enabled = 0
  autocmd BufReadPost * if !search('\S', 'cnw') | let &l:fileencoding = &encoding | endif
  " restore cursor position
  autocmd BufReadPost * if line("'\"") <= line('$') | execute "normal '\"" | endif
  " prevent auto comment insertion when 'o' pressed
  autocmd BufEnter * setlocal formatoptions-=o

  "my ftdetects
  autocmd BufRead,BufNewFile ?zshrc,?zshenv set filetype=zsh
  autocmd BufRead,BufNewFile *
        \ if &readonly || !&modifiable | nnoremap <buffer> <Return> <Return> | endif

  autocmd CompleteDone * if !pumvisible() | silent! pclose | endif

  " ShellScript
  autocmd FileType sh,zsh setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

  autocmd FileType make setlocal list
  autocmd FileType make setlocal iskeyword+=-
  " autocmd BufRead,BufNewFile *.groovy,*.jenkins,Jenkinsfile* setlocal filetype=groovy
  autocmd BufRead,BufNewFile *.jenkins setfiletype groovy
  autocmd FileType groovy,jenkinsfile setlocal autoindent smartindent

  augroup PersistentUndo
    autocmd!
    autocmd BufWritePre
          \ COMMIT_EDITMSG,*.bak,*.bac,knife-edit-*.js,?.* setlocal noundofile
  augroup END

  function! s:insert_today_for_md_changelog()
    call append(line('.') - 1, strftime('%Y-%m-%d'))
    call append(line('.') - 1, repeat('=', 10))
  endfunction
  " autocmd BufRead,BufNewFile *.md,*.mkd,*.markdown set filetype=markdown

  autocmd FileType markdown inoremap <buffer> <Leader>tt <Esc>:<C-u>call <SID>insert_today_for_md_changelog()<Cr>:startinsert<Cr>
  autocmd FileType markdown set autoindent
  autocmd FileType markdown setlocal tabstop=4 shiftwidth=4 conceallevel=0
  let g:markdown_fenced_languages = ['python', 'bash=sh']
  let g:markdown_syntax_conceal = 0

  autocmd FileType gitcommit setlocal spell

  autocmd FileType help,qf,ref-* nnoremap <buffer> <silent> qq <C-w>c

  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType vim if &iskeyword !~# '&' | setlocal iskeyword+=& | endif

  autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4

  autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab
augroup END

augroup lsp_install
    autocmd!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
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
  set lines=40
  set mousehide
  set nomousefocus

  " Disable GUI /Syntax/ menu
  let did_install_syntax_menu = 1
  " let did_install_default_menus = 1

  if &guioptions =~# 'M'
    let &guioptions = substitute(&guioptions, '[mT]', '', 'g')
  endif

  if s:mac
    set guifont=HackGen:h14
    set linespace=1
    set antialias
    set fuoptions& fuoptions+=maxhorz

    inoremap <silent> <D-v> <Esc>:let &paste=1<Cr>a<C-R>=@*<Cr><Esc>:let &paste=0<Cr>a
    cnoremap <D-v> <C-R>*
    vnoremap <D-c> "+y
    nnoremap <D-a> ggVG
  elseif s:linux
    set guifont=HackGen\ 14
    vnoremap <silent> <M-c> "+y
    inoremap <silent> <M-v> <Esc>:let &paste=1<Cr>a<C-R>+<Esc>:let &paste=0<Cr>a
    " copy to clipboard
    nnoremap <silent> [Space]a :<C-u>call <SID>xclip()<Cr>
  else
    " Windows
    set guifont=HackGen:h14:cSHIFTJIS:qDRAFT
    if has('directx')
      set renderoptions=type:directx,level:2.0,geom:1,renmode:5,contrast:1,taamode:0
    endif
    inoremap <silent> <M-v> <Esc>:let &paste=1<Cr>a<C-R>=@*<Cr><Esc>:let &paste=0<Cr>a
    cnoremap <M-v> <C-R>*
    vnoremap <M-c> "+y
  endif

  if has('printer')
    let &printfont = &guifont
  endif
endif
" __END__ {{{
" vim: fen fdm=marker ts=2 sts=2 sw=2 tw=0
