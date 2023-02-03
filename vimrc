" Tacahiroy's vimrc
"
" Copyright © 2022 Takahiro Yoshihara
" All rights reserved.

" Redistribution and use in source and binary forms, with or without
" modification, are permitted provided that the following conditions are met:
" 1. Redistributions of source code must retain the above copyright
" notice, this list of conditions and the following disclaimer.
" 2. Redistributions in binary form must reproduce the above copyright
" notice, this list of conditions and the following disclaimer in the
" documentation and/or other materials provided with the distribution.

" THIS SOFTWARE IS PROVIDED BY Takahiro Yoshihara ''AS IS'' AND ANY
" EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
" WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
" DISCLAIMED. IN NO EVENT SHALL Takahiro Yoshihara BE LIABLE FOR ANY
" DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
" (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
" LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
" ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
" (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
" SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

" The views and conclusions contained in the software and documentation
" are those of the authors and should not be interpreted as representing
" official policies, either expressed or implied, of Takahiro Yoshihara.

scriptencoding utf-8

set cpo&vim

if has('vim_starting')
  set encoding=utf-8
  set termencoding=utf-8
endif
set verbose=0

let g:mapleader = ','

" Clear all autocmds in the default group
autocmd!
augroup Tacahiroy | autocmd! | augroup END

let s:mac = has('macunix') || has('mac')
let s:linux = !s:mac && has('unix')
let s:win = !(s:mac || s:linux) && has('win32') || has('win64')
let s:grep = executable('rg') ? 'rg' : 'grep'
let g:show_cwd = 1

" functions " {{{
" * global
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

function! s:ins_note_template(title)
  let s = []
  call add(s, printf('%s', a:title))
  call add(s, '==========')
  call add(s, printf('- date: %s', strftime('%Y-%m-%d %T')))
  call add(s, '- tags: []')
  call add(s, '- - -')
  call setline(1, s)
endfunction

function! s:create_new_note()
  while 1
    let ans = input('New note> ')
    if !empty(ans)
      break
    endif
  endwhile
  let title = substitute(ans, '[\t /\\:?\*<>|]', '-', 'g')
  execute printf('edit %s/%s-%s.md', g:tacahiroy_note_path, strftime('%Y-%m-%d'), title)
  call s:ins_note_template(ans)
endfunction

function! s:to_plain_sql() range abort
  execute printf('%d,%d:s/\([''"]\|+[\t ]*$\)//g', a:firstline, a:lastline)
endfunction
command! -nargs=0 -range ToPlainSQL <line1>,<line2>call <SID>to_plain_sql()

function! s:shorten_commit_hash()
  let lh = expand('<cword>')
  let sh = lh
  if len(lh) >= 8
    let sh = lh[0:7]
  endif
  let save_reg = getreg('"')
  call setreg('"', sh)
  normal! "_diwP
  call setreg('"', save_reg)
endfunction
command! -nargs=0 ShortenCommitHash call <SID>shorten_commit_hash()
nnoremap <Leader>H <Cmd>ShortenCommitHash<Cr>
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

" Completion {{{
call minpac#add('prabirshrestha/async.vim')
call minpac#add('prabirshrestha/vim-lsp')
  let g:lsp_auto_enable = 1 "{{{ vim-lsp
  let g:lsp_use_lua = (has('lua') && has('patch-8.2.0775'))
  let g:lsp_async_completion = 1
  let g:lsp_diagnostics_enabled = 1
  let g:lsp_diagnostics_echo_cursor = 1
  let g:lsp_diagnostics_float_cursor = 1
  let g:lsp_diagnostics_signs_enabled = 1
  let g:lsp_inlay_hints_enabled = has('patch-9.0.0167')
  let g:lsp_diagnostics_signs_error = {'text': '🤬'}
  let g:lsp_diagnostics_signs_warning = {'text': '🤢'}
  let g:lsp_diagnostics_signs_information = {'text': '🙄'}
  let g:lsp_diagnostics_signs_hint = {'text': '🤓'}
  let g:lsp_document_code_action_signs_enabled = 0
  let g:lsp_preview_float = 1
	let g:lsp_preview_autoclose = 0
  let g:lsp_log_verbose = v:false
  let g:lsp_log_file = expand('~/vim-lsp.log')
  let g:lsp_semantic_enabled = 0

  let g:lsp_settings = {}
  let g:lsp_settings['efm-langserver'] = {
  \   'disabled': v:false
  \ }

  " https://github.com/golang/tools/blob/master/gopls/doc/settings.md
  " {{{ gopls
  let g:lsp_settings['gopls'] = {
  \   'workspace_config': {
  \     'allExperiments': v:true,
  \     'gofumpt': v:true,
  \     'usePlaceholders': v:true,
  \     'semanticTokens': v:true,
  \     'codelenses': {
  \       'tidy': v:true,
  \       'test': v:true,
  \     },
  \     'analyses': {
  \       'assign': v:true,
  \       'fieldalignment': v:true,
  \       'fillstruct': v:true,
  \       'nilness': v:true,
  \       'shadow': v:true,
  \       'unreachable': v:true,
  \       'unusedparams': v:true,
  \     }
  \   },
  \   'initialization_options': {
  \     'gofumpt': v:true,
  \     'semanticTokens': v:true,
  \     'usePlaceholders': v:false,
  \     'codelenses': {
  \       'tidy': v:true,
  \       'test': v:true,
  \     },
  \     'analyses': {
  \       'fillstruct': v:true,
  \     },
  \   },
  \ } "}}}

  " {{{ pylsp-all
  autocmd Tacahiroy BufReadPre *.py let g:lsp_settings['pylsp-all'] = <SID>get_lsp_setting_pylsp()

  function! s:get_lsp_setting_pylsp() abort
    let config = {
    \   'workspace_config': {
    \     'pyls': {
    \       'plugins': {
    \         'pycodestyle': {
    \           'enabled': v:false,
    \           'maxLineLength': 120
    \         },
    \         'pyflakes': {
    \           'enabled': v:false
    \         },
    \         'yapf': {
    \           'enabled': v:false
    \         },
    \         'pylint': {
    \           'enabled': v:true,
    \           'args': ['--rcfile=.pylintrc'],
    \           'executable': 'poetry run pylint || pylint'
    \         }
    \       }
    \     }
    \   }
    \ }

    " let config['cmd'] = ['poetry run pyls || pyls']

    return config
  endfunction
  " }}}

  " {{{ yaml-language-server
  let g:lsp_settings['yaml-language-server'] = {
  \   'allowlist': ['yaml', 'yaml.ansible'],
  \   'workspace_config': {
  \     'redhat': {
  \       'telemetry': {'enabled': v:false},
  \     },
  \     'yaml': {
  \       'validate': v:false,
  \       'hover': v:false,
  \       'completion': v:true,
  \       'schemas': [],
  \       'format': { 
  \         'enable': v:true
  \       }
  \     }
  \   },
  \ }
  " }}}

  " https://github.com/prabirshrestha/vim-lsp
  function! s:on_lsp_buffer_enabled() abort
      setlocal omnifunc=lsp#complete
      setlocal signcolumn=auto

      if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif

      nmap <buffer> gd <plug>(lsp-definition)
      nmap <buffer> gD <plug>(lsp-document-diagnostics)
      nmap <buffer> g] <plug>(lsp-next-diagnostic)
      nmap <buffer> g[ <plug>(lsp-previous-diagnostic)
      nmap <buffer> gr <plug>(lsp-references)
      nmap <buffer> gI <plug>(lsp-implementation)
      nmap <buffer> gt <plug>(lsp-type-definition)
      nmap <buffer> gR <plug>(lsp-rename)
      nmap <buffer> gA <plug>(lsp-code-action)
      nmap <buffer> gL <plug>(lsp-code-lens)
      nmap <buffer> gC <plug>(lsp-preview-close)
      nmap <buffer> K  <plug>(lsp-hover)
      inoremap <buffer> <expr><S-\<lt>Down> lsp#scroll(+4)
      inoremap <buffer> <expr><S-\<lt>Up> lsp#scroll(-4)

      let g:lsp_format_sync_timeout = 1000
      autocmd! BufWritePre *.rs,*.py,*.go call execute('LspDocumentFormatSync')
  endfunction

  augroup lsp_install
      autocmd!
      " call s:on_lsp_buffer_enabled only for languages that has the server registered.
      autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END
"}}}

call minpac#add('mattn/vim-lsp-settings')

call minpac#add('prabirshrestha/asyncomplete.vim')
  let g:asyncomplete_smart_completion = has('lua')
  let g:asyncomplete_auto_popup = 1
  let g:asyncomplete_auto_completeopt = 1
  let g:asyncomplete_popup_delay = 200
  let g:asyncomplete_remove_duplicates = 1
  " let g:asyncomplete_log_file = expand('~/asyncomplete.log')

call minpac#add('prabirshrestha/asyncomplete-lsp.vim')
call minpac#add('prabirshrestha/asyncomplete-buffer.vim')
  let g:asyncomplete_buffer_clear_cache = 1

  augroup Tacahiroy
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
          \ 'name': 'buffer',
          \ 'allowlist': ['*'],
          \ 'blocklist': ['go', 'python', 'markdown'],
          \ 'completor': function('asyncomplete#sources#buffer#completor'),
          \ 'config': {
          \    'max_buffer_size': 5242880,
          \  },
          \ }))
  augroup END

call minpac#add('thomasfaingnaert/vim-lsp-snippets')
call minpac#add('thomasfaingnaert/vim-lsp-ultisnips')

call minpac#add('stephpy/vim-yaml')
call minpac#add('cohama/lexima.vim')
  " let g:lexima_no_default_rules = 1
  let g:lexima_enable_space_rules = 0
  let g:lexima_enable_endwise_rules = 1

call minpac#add('bkad/CamelCaseMotion')

call minpac#add('godlygeek/tabular')
  call minpac#add('preservim/vim-markdown')
    let g:vim_markdown_folding_disabled = 1
    let g:vim_markdown_conceal = 1
    let g:vim_markdown_emphasis_multiline = 0
    let g:vim_markdown_strikethrough = 1
    let g:vim_markdown_new_list_item_indent = 4

call minpac#add('luochen1990/rainbow')
  let g:rainbow_active = 1
  let g:rainbow_conf = {}
  let g:rainbow_conf.ctermfgs = ['darkblue', 'darkgreen', 'darkred', 'darkgray', 'darkmagenta']
  let g:rainbow_conf.operators = '_,_'
  let g:rainbow_conf.parentheses = ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold']
  let g:rainbow_conf.separately = { '*': {} }

call minpac#add('andymass/vim-matchup')
  let g:matchup_transmute_enabled = 1
  nnoremap <Leader>mw <Cmd>MatchupWhereAmI?<Cr>


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
  let g:ctrlp_match_current_file = 0

  if s:grep ==# 'rg'
    let g:ctrlp_user_command = 'rg %s -i --files --no-heading --max-depth 10'
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

call minpac#add('tacahiroy/ctrlp-funky', {'rev': 'main'})
  let g:ctrlp_funky_debug = 0
  let g:ctrlp_funky_use_cache = 0
  let g:ctrlp_funky_matchtype = 'path'
  let g:ctrlp_funky_sort_by_mru = 0
  let g:ctrlp_funky_syntax_highlight = 0
  let g:ctrlp_funky_filter_conversions = { 'yaml.ansible': 'ansible' }

  let g:ctrlp_funky_nudists = ['php']

  nnoremap [Space]fu :CtrlPFunky<Cr>
  nnoremap [Space]uu :execute 'CtrlPFunky ' . fnameescape(expand('<cword>'))<Cr>

call minpac#add('ryanoasis/vim-devicons')
  let g:webdevicons_enable_ctrlp = 1
"}}}

call minpac#add('jremmen/vim-ripgrep')

call minpac#add('tacahiroy/vim-colors-isotake')
  colorscheme isotake

if has('python3')
  call minpac#add('SirVer/ultisnips')
    let g:UltiSnipsExpandTrigger = "<C-i>"
    let g:UltiSnipsListSnippets = "<C-l>"
    let g:UltiSnipsJumpForwardTrigger = "<C-f>"
    let g:UltiSnipsJumpBackwardTrigger = "<C-b>"

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

if filereadable(expand('~/.vimrc.plugins'))
  source ~/.vimrc.plugins
endif

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()
"}}}
" set completeopt=preview,menuone,noinsert,noselect
set completeopt+=preview

" Super simple note taking {{{
let g:tacahiroy_note_path = expand('~/dev/memo')
command! -nargs=1 InsertNoteTemplate call <SID>ins_note_template(<q-args>)
command! -nargs=0 NewNote call <SID>create_new_note()
nnoremap [Space]mc :NewNote<Cr>
nnoremap [Space]ml :execute 'CtrlP ' . g:tacahiroy_note_path<Cr><F5>
"}}}

function! s:current_syntax_name()
  let synid = synID(line('.'), col('.'), 1)
  let synname = synIDattr(synid, 'name')
  let syntransname = synIDattr(synIDtrans(synid), 'name')

  if synname == syntransname
    echo printf('%s', synname)
  else
    echo printf('%s -> %s', synname, syntransname)
  endif
endfunction
command! -nargs=0 CurrentSyntaxName call <SID>current_syntax_name()

" plug: camelcasemotion
  map <silent> W <plug>CamelCaseMotion_w
  map <silent> B <plug>CamelCaseMotion_b
  map <silent> E <plug>CamelCaseMotion_e
  sunmap W
  sunmap B
  sunmap E
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
set backupskip& backupskip+=/tmp/*,/private/tmp/*,*.bac,COMMIT_EDITMSG,svn-commit.[0-9]*.tmp
set belloff=backspace,cursor,esc,insertmode
if exists('+breakindent')
  set breakindent
  set breakindentopt=sbr
end
set cedit=<C-x>
set clipboard=
set cmdheight=1
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
for s in ['/bin/bash', '/usr/bin/bash', '/bin/dash', '/bin/ash', '/bin/sh']
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
set updatetime=500
set viminfo='64,<100,s10,n~/.viminfo
set virtualedit=block,onemore
set termwinkey=<C-g>
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

function! SetStatusline()
  let stl = ''

  " statusline config
  let stl = '#%n|'
  let stl .= '%<%t%*|%m%r%h%w'
  let stl .= '%{&expandtab ? "" : ">"}%{&l:tabstop}'
  let stl .= '%{search("\\t", "cnw") ? "!" : ""}'
  let stl .= '%{(empty(&mouse) ? "" : "m")}'
  let stl .= '%{(&list ? "L" : "")}'
  let stl .= '%{(empty(&clipboard) ? "" : "c")}'
  let stl .= '%{(&paste ? "p" : "")}'
  let stl .= '%{(&spell ? "s" : "")}'
  let stl .= '|%{&textwidth}'

  if exists('*LinterStatus')
    let stl .= '%{LinterStatus()}'
  endif

  if exists('*FugitiveStatusline')
    let stl .= '%#Type#'
    let stl .= '%{winwidth(0) > 100 ? fugitive#statusline() : ""}'
    let stl .= '%*'
  endif

  if exists('*lsp#get_server_status')
    let stl .= '|%{winwidth(0) > 100 ? lsp#get_server_status() : ""}'
  endif

  " right side from here
  let stl .= ' %='
  " Cwd
  let stl .= '%#CursorLineNr#'
  let stl .= '%{winwidth(0) > 100 ? (get(g:, "show_cwd", 0) ? Cwd() : "") : ""}'
  " ft:fenc:ff
  let stl .= '%*'
  let stl .= '%{&filetype}:'
  let stl .= '%{(&l:fileencoding != "" ? &l:fileencoding : &encoding) . ":" . &fileformat}'
  let stl .= '%-10(%#MoreMsg#%l%#Title#/%L:%c %)%P%*'

  return stl
endfunction
set statusline=%!SetStatusline()


" }}}
" * mappings "{{{
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
cnoremap <C-o> <C-d>

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
nnoremap sj $%
vnoremap sj $%
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

" window navigations (I use Colemak)
nnoremap <silent> sh <C-w>h
nnoremap <silent> se <C-w>k
nnoremap <silent> si <C-w>l
nnoremap <silent> sn <C-w>j

nnoremap <silent> <Return> :<C-u>call <SID>append_blank_line()<Cr>

" show/hide line number wisely: this needs Vim 7.3 or above
function! s:toggle_line_number()
  if v:version <= 703 | return | endif

  let b:prev_num_state = get(b:, 'prev_num_state', {})

  if &nu || &rnu
    " to be off
    let b:prev_num_state = { 'nu': &nu, 'rnu': &rnu }
    let &nu = 0
    let &rnu = 0
  else
    " restore previous setting
    let &nu = get(b:prev_num_state, 'nu', 1)
    let &rnu = get(b:prev_num_state, 'rnu', 1)
  endif
endfunction

" mappings for toggle something
nnoremap <silent> [Toggle]m :let &mouse = empty(&mouse) ? 'a' : ''<Cr>
nnoremap <silent> [Toggle]p :set paste!<Cr>
nnoremap <silent> [Toggle]l :set list!<Cr>
nnoremap <silent> [Toggle]n :<C-u>silent call <SID>toggle_line_number()<Cr>
nnoremap <silent> [Toggle]r :set relativenumber!<Cr>
nnoremap <silent> [Toggle]b :let &background = &background ==# 'dark' ? 'light' : 'dark'<Cr>
nnoremap <silent> [Toggle]sp :set invspell<Cr>
nnoremap <silent> [Toggle]sw :let g:show_cwd = abs(get(g:, 'show_cwd', 0) - 1)<Cr>

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
nnoremap <Leader>G :<C-u>g/
nnoremap <Leader>V :<C-u>v/
nnoremap <Leader>s :<C-u>s/
nnoremap <Leader>S :<C-u>%s/
xnoremap <Leader>s :s/

nnoremap <Leader>ta :Tabularize<Space>/
xnoremap <Leader>ta :Tabularize<Space>/

nnoremap <Leader>te :<C-u>tabe<Space>
" clears search highlight
nnoremap <silent> <C-l> <Cmd>nohlsearch<Cr>

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

" Converting a word under cursor to uppercase / lowercase
inoremap <Leader><Leader>a <Esc>b:call <SID>toggle_case(1)<Cr>gi
inoremap <Leader><Leader>x <Esc>b:call <SID>toggle_case(0)<Cr>gi
" Capitalise the first letter
inoremap <Leader><Leader>c <Esc>bvUgi

inoremap <Leader><Leader>k (<Esc>A)

" Copy absolute path to current file to clipboard
command! -nargs=0 CopyCurrentFilePath2CB let @* = fnamemodify(@%, ':p')
command! -nargs=0 AbsolutePath echomsg fnamemodify(@%, ':p')
command! -nargs=0 RelativePath echomsg substitute(fnamemodify(@%, ':p'), getcwd() . '/', '', '')

" search visual-ed text
vnoremap * y/<C-R>"<Cr>

" like Eclipse's Alt+Up/Down
function! s:move_block(d) range
  let [sign, cnt] = a:d is# 'u' ? ['-', 2] : ['+', a:lastline-a:firstline+1]
  execute printf('%d,%dmove%s%d', a:firstline, a:lastline, sign, cnt)
endfunction
vnoremap <C-p> :call <SID>move_block('u')<Cr>==gv
vnoremap <C-n> :call <SID>move_block('d')<Cr>==gv
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

command! -nargs=0 PtPython vert terminal ++close ptpython

if has('multi_byte_ime') || has('xim')
  set iminsert=0 imsearch=0
  inoremap <silent> <Esc> <Esc>:<C-u>set iminsert=0<Cr>
endif

" * autocmds "{{{
augroup Tacahiroy
  autocmd BufRead,BufNewFile */tasks/*.yml,*/vars/*.yml,*/defaults/*.yml,*/handlers/*.yml set filetype=yaml.ansible

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

  autocmd BufRead,BufNewfile *.conf setfiletype conf

  " ShellScript
  autocmd FileType sh,zsh setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab


  autocmd FileType php setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab

  autocmd FileType make setlocal list
  autocmd FileType make setlocal iskeyword+=-
  autocmd BufRead,BufNewFile Jenkinsfile,*.jenkins,*.jenkinsfile setfiletype groovy
  autocmd FileType groovy,Jenkinsfile setlocal autoindent smartindent

  augroup PersistentUndo
    autocmd!
    autocmd BufWritePre
          \ COMMIT_EDITMSG,*.bak,*.bac setlocal noundofile
  augroup END

  function! s:insert_today_for_md_changelog()
    call append(line('.') - 1, strftime('%Y-%m-%d'))
    call append(line('.') - 1, repeat('=', 10))
  endfunction

  autocmd FileType markdown inoremap <buffer> <Leader>tt <Esc>:<C-u>call <SID>insert_today_for_md_changelog()<Cr>:startinsert<Cr>
  autocmd FileType markdown set autoindent
  autocmd FileType markdown set tabstop=4 shiftwidth=4 conceallevel=2
  let g:markdown_fenced_languages = ['python', 'bash=sh']
  let g:markdown_syntax_conceal = 0

  autocmd FileType gitcommit setlocal spell

  autocmd FileType help,qf,ref-* nnoremap <buffer> <silent> qq <C-w>c

  autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
  autocmd FileType vim if &iskeyword !~# '&' | setlocal iskeyword+=& | endif

  autocmd FileType c setlocal tabstop=4 softtabstop=4 shiftwidth=4

  autocmd FileType go setlocal tabstop=4 shiftwidth=4 softtabstop=4 noexpandtab

  if v:true || exists('*lexima#add_rule')
    autocmd VimEnter * call lexima#add_rule({'char': '(', 'at': '\%#\w', 'input': '('})
    autocmd VimEnter * call lexima#add_rule({'char': ';', 'at': '\%#)',  'leave': ')', 'input': ';'})
    autocmd VimEnter * call lexima#add_rule({'char': '{', 'at': '\%#\w', 'input': '{'})
    autocmd VimEnter * call lexima#add_rule({'char': '}', 'at': '\%#)',  'leave': ')', 'input': ' {'})
    autocmd VimEnter * call lexima#add_rule({'char': '[', 'at': '\%#\w', 'input': '['})
    autocmd VimEnter * call lexima#add_rule({'char': '"', 'at': '\%#\w', 'except': '\%#[\t ]*$', 'input': '"'})
    autocmd VimEnter * call lexima#add_rule({'char': "'", 'at': '\%#\w', 'except': '\%#[\t ]*$', 'input': "'"})
  endif
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
" __END__ {{{
" vim: fen fdm=marker ts=2 sts=2 sw=2 tw=0
