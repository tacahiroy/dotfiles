" $HOME/.vimrc
" Maintainer: TaCahiroy <tacahiroy*DELETE-ME*@gmail.com>

scriptencoding utf-8
set cpo&vim

autocmd!

if isdirectory($HOME . '/.vim')
  let $DOTVIM = $HOME . '/.vim'
else
  let $DOTVIM = $HOME . '/vimfiles'
endif

set nocompatible
set verbose=0


" * functions "{{{1
" convert path separator
" unix <-> dos
function! s:cps(path, style)
  let styles = {'dos':  ['/', '\'],
    \           'unix': ['\', '/']}

  if ! has_key(styles, a:style)
    return a:path
  endif

  return substitute(a:path, styles[a:style][0], styles[a:style][1], 'g')
endfunction

" tag information show in command window
function! s:previewTagLight(w)
  let t = taglist('^'.a:w.'$')
  let current = expand('%:t')

  for item in t
    " [filename] tag definition
    if -1 < stridx(item.filename, current)
      echohl Search | echomsg printf('%-36s', '[' . s:cps(item.filename, 'unix') . ']') | echohl None
    else
      echomsg printf('%-36s', '[' . substitute(s:cps(item.filename, 'unix'), '\s\s*$', '', '') . ']')
    endif
endfunction
nnoremap <silent> ,ta :call <SID>previewTagLight(expand('<cword>'))<Cr>

" from kana's: get SID_PREFIX
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_')
endfunction

function! s:first_line(file)
  let lines = readfile(a:file, '', 1)
  return 1 <= len(lines) ? lines[0] : ''
endfunction

" VCS branch name  "{{{2
" from kana's
" Returns the name of the current branch of the given directory.
" BUGS: git is only supported.
let s:_vcs_branch_name_cache = {}  " dir_path = [branch_name, key_file_mtime]

function! s:vcs_branch_name(dir)
  let cache_entry = get(s:_vcs_branch_name_cache, a:dir, 0)
  if cache_entry is 0
        \ || cache_entry[1] < getftime(s:_vcs_branch_name_key_file(a:dir))
    unlet cache_entry
    let cache_entry = s:_vcs_branch_name(a:dir)
    let s:_vcs_branch_name_cache[a:dir] = cache_entry
  endif

  return cache_entry[0]
endfunction

function! s:_vcs_branch_name_key_file(dir)
  return a:dir . '/.git/HEAD'
endfunction

function! s:_vcs_branch_name(dir)
  let head_file = s:_vcs_branch_name_key_file(a:dir)
  let branch_name = ''

  if filereadable(head_file)
    let ref_info = s:first_line(head_file)
    if ref_info =~ '^\x\{40}$'
      let remote_refs_dir = a:dir . '/.git/refs/remotes/'
      let remote_branches = split(glob(remote_refs_dir . '**'), "\n")
      call filter(remote_branches, 's:first_line(v:val) ==# ref_info')
      if 1 <= len(remote_branches)
        let branch_name = 'remote: '. remote_branches[0][len(remote_refs_dir):]
      endif
    else
      let branch_name = matchlist(ref_info, '^ref: refs/heads/\(\S\+\)$')[1]
      if branch_name == ''
        let branch_name = ref_info
      endif
    endif
  endif

  return [branch_name, getftime(head_file)]
endfunction
" }}}

if executable('ruby') "{{{2 RubyInstantExec
  " RubyInstantExec
  " preview interpreter's output(Tip #1244) improved
  function! s:RubyInstantExec() range
    if &filetype !=# 'ruby'
      echomsg 'filetype is not "ruby".'
      return
    endif

    if ! exists('g:src')
      let g:src = 'vimrie.tmp'
    endif
    let buf_name = 'RubyInstantExec Result'

    " put current buffer's content in a temp file
    silent execute printf(':%d,%dw! >> %s', a:firstline, a:lastline, g:src)

    " open the preview window
    silent execute ':pedit! ' . escape(buf_name, '\ ')
    " change to preview window
    wincmd P

    setlocal buftype=nofile
    setlocal noswapfile
    setlocal syntax=none
    setlocal bufhidden=delete

    " replace current buffer with ruby's output
    silent execute printf(':%%!ruby %s 2>&1', g:src)
    " change back to the source buffer
    wincmd p

    call delete(g:src)
  endfunction

  nmap <silent> <Space>r :call <SID>RubyInstantExec()<Cr>
  vmap <silent> <Space>r :call <SID>RubyInstantExec()<Cr>
endif
"}}}
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
set autoindent
set nocindent
set nosmartindent
set autoread
set backspace=indent,eol,start
set backup
set backupext=.bac
set backupdir=$DOTVIM/backups
set backupskip& backupskip+=*.bac,COMMIT_EDITMSG,hg-editor-*.txt,svn-commit.tmp,svn-commit.[0-9]*.tmp
set cmdheight=2
set completefunc=
set noequalalways
set expandtab smarttab
set fileencodings=ucs-bom,utf-8,iso-2022-jp,euc-jp,cp932
set fileformats=dos,unix,mac
set helplang=en,ja
set hidden
set history=3000
set hlsearch
set ignorecase
set incsearch
set linebreak
set linespace=1
set nolist
set listchars=tab:>-,trail:-,extends:>,precedes:<,eol:<
set laststatus=2
set lazyredraw
set modeline
set number
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
set wildignore=*.exe
set wildmenu
set wildmode=list:longest
set nowrapscan

set t_Co=256

set guioptions& guioptions=ciM

set formatoptions&
let &formatoptions .= 'mM'
let &formatoptions = substitute(&formatoptions, '[or]', '', 'g')

" statusline {{{
" [#bufnr]filename [modified?][enc:ff][filetype]
let &statusline = "[#%n]%<%f %m%r%h%w%y"
let &statusline .= "["
let &statusline .= "%{(&l:fileencoding != '' ? &l:fileencoding : &encoding).':'.&fileformat}"
let &statusline .= "]"
let &statusline .= "(%#Function#%{" . s:SID_PREFIX() .  "vcs_branch_name(getcwd())}%*)"
" monstermethod.vim support
let &statusline .= "%{exists('b:mmi.name') && 0<len(b:mmi.name) ? ' -- '.b:mmi.name.'('.b:mmi.lines.'L)' : ''}"
let &statusline .= "%=%-16(\ %l/%LL,%c\ %)%P"
" }}}

set matchpairs+=<:>
"let g:loaded_matchparen = 0
highlight MatchParen term=reverse ctermbg=LightRed gui=NONE guifg=fg guibg=LightRed
" }}}


" * map "{{{
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" like C or D
nnoremap Y y$
nnoremap s <Nop>
nnoremap <silent>cn :cnext<Cr>
nnoremap <silent>cp :cprevious<Cr>
nnoremap j gj
nnoremap k gk
nnoremap vv <C-v>
nnoremap <C-]> <C-]>zz
nnoremap <C-t> <C-t>zz
nnoremap <silent> <Space>n :bnext<Cr>
nnoremap <silent> <Space>N :bprevious<Cr>
nnoremap <silent> sn :tabnext<Cr>
nnoremap <silent> sp :tabprevious<Cr>

nnoremap <silent> <Space>o :copen<Cr>

if has('win32')
  nnoremap <silent> <Space>e :<C-u>silent execute ":!start explorer \"" . s:cps(expand("%:p:h"), "dos") . "\""<Cr>
  nnoremap <silent> <Space>E :<C-u>silent execute ":!start cmd /k cd \"" . s:cps(expand("%:p:h"), "dos") . "\""<Cr>
endif

" inspired by vimrc.ujihisa
nnoremap <Space>w :<C-u>write<Cr>
nnoremap <Space>q :<C-u>quit<Cr>
nnoremap <Space>W :<C-u>write!<Cr>
nnoremap <Space>Q :<C-u>quit!<Cr>

nnoremap <Space>j <C-d>
nnoremap <Space>k <C-u>

nnoremap <silent> <Space>_ :<C-u>edit $MYVIMRC<Cr>
nnoremap <silent> <Space>s_ :<C-u>source $MYVIMRC<Cr>

nnoremap <silent> <Esc> <Esc>:<C-u>silent nohlsearch<Cr>
nnoremap <silent> sh <C-w>h
nnoremap <silent> sk <C-w>k
nnoremap <silent> sl <C-w>l
nnoremap <silent> sj <C-w>j
nnoremap <MiddleMouse> <Nop>
nnoremap <2-MiddleMouse> <Nop>

nnoremap <Space>utf8 :<C-u>e ++enc=utf-8<Cr>
nnoremap <Space>cp932 :<C-u>e ++enc=cp932<Cr>

" preview tag
nnoremap <silent> <Space>x <C-w>}
nnoremap <silent> <Space>X :pclose<Cr>

" cancel completion
imap <expr> <silent> <S-Esc> pumvisible() ? "\<C-e>" : "\<Esc>:<C-u>setlocal iminsert=0\<Cr>"
imap <expr> <Cr> pumvisible() ? "\<C-y>\<Cr>" : "\<Cr>"

inoremap <silent> ,dd <C-R>=exists('b:dd') ? b:dd : ''<Cr>
inoremap <silent> ,dt <C-R>=strftime('%Y.%m.%d')<Cr>
inoremap <silent> ,ti <C-R>=strftime('%H:%M')<Cr>
inoremap <silent> ,fn <C-R>=expand('%')<Cr>
inoremap jj <Esc>

" selected text search
vnoremap * y/<C-R>"<Cr>
vnoremap < <gv
vnoremap > >gv

if executable('tidy')
  vnoremap <leader>ty :!tidy -xml -i -shiftjis -wrap 0 -q -asxml<Cr>
  nnoremap <leader>ty :<C-u>1,$!tidy -xml -i -shiftjis -wrap 0 -q -asxml<Cr>
endif

vmap ,s <Plug>Vsurround
vmap ,S <Plug>VSurround

let g:surround_{char2nr('k')} = "「\r」"
let g:surround_{char2nr('K')} = "『\r』"
let g:surround_indent = 0
let g:xml_tag_completion_map = ''
"}}}


" syntax: vim.vim
let g:vimsyntax_noerror = 1


" * something "{{{
augroup MySomething
  autocmd!
  autocmd BufRead,BufNewFile *.js set filetype=javascript.jquery
  " vimball
  autocmd BufRead *.vba source $DOTVIM/plugin/dotvi/vimballPlugin.vi

  autocmd BufEnter * execute ':lcd ' . escape(expand('%:p:h'), ' ')

  autocmd BufReadPre * let g:updtime = &l:updatetime
  autocmd BufLeave,BufWinLeave * if exists('g:updtime') | let &l:updatetime = g:updtime | endif

  autocmd BufReadPost * if ! search('\S', 'cnw') | let &l:fileencoding = &encoding | endif
  " restore cursor position
  autocmd BufReadPost * if line("'\"") | execute "normal '\"" | endif
augroup END

" http://vim-users.jp/2009/11/hack96/ {{{
autocmd FileType *
\   if &l:omnifunc == ''
\ |   setlocal omnifunc=syntaxcomplete#Complete
\ | endif
" }}}

augroup MyAutoCmd
  autocmd!
augroup END

autocmd MyAutoCmd FileType qf,help nnoremap <buffer> <silent> q <C-w>c
autocmd FileType javascript* setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType ruby,rspec let &path .= "," . s:cps($RUBYLIB, 'unix')
" MS Excel
autocmd FileType excel
  \  setlocal noexpandtab tabstop=10 shiftwidth=10 softtabstop=10 list

" inspired by vimrc.ujihisa
autocmd FileType irb inoremap <buffer> <silent> <Cr> <Esc>:<C-u>ruby v=VIM::Buffer.current;v.append(v.line_number, '#=> ' + eval(v[v.line_number]).inspect)<Cr>jo
nnoremap <Space>irb :<C-u>new<Cr>:setfiletype irb<Cr>

autocmd FileType rspec
\   compiler rspec
\| setlocal syntax=ruby
\| setlocal omnifunc=rubycomplete#Complete

autocmd FileType vim,snippet setlocal tabstop=2 shiftwidth=2 softtabstop=2

autocmd FileType html,xhtml,xml,xslt,mathml,svg
\| setlocal tabstop=2 shiftwidth=2 softtabstop=2

let g:xml_no_auto_nesting = 1
let g:xml_use_xhtml = 1
let g:xml_tag_completion_map = ''

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS tabstop=2 shiftwidth=2 softtabstop=2

let g:loaded_sql_completion = 1
autocmd FileType sql,plsql
\  setlocal tabstop=4 shiftwidth=4 softtabstop=4
\| nnoremap <buffer> <silent> <C-Return> :DBExecSQLUnderCursor<Cr>
\| vnoremap <buffer> <silent> <C-Return> :DBExecVisualSQL<Cr>

let g:sqlutil_align_comma = 1
let g:sqlutil_align_where = 1
let g:sqlutil_keyword_case = '\U'
let g:dbext_default_type = 'ORA'

autocmd FileType javascript,javascript.jquery,html,xhtml
\  setlocal makeprg=jsl\ -conf\ D:/usr/bin/jsl.default.conf\ -nologo\ -nofilelisting\ -nosummary\ -nocontext\ -process\ %
\| setlocal errorformat=%f(%l):\ %m

autocmd Filetype c compiler gcc
autocmd Filetype cpp compiler gcc
autocmd Filetype c setl makeprg=gcc\ -Wall\ %\ -o\ %:r.o
autocmd Filetype cpp setl makeprg=g++\ -Wall\ %\ -o\ %:r.o
autocmd Filetype c nmap <buffer> <Space>m :<C-u>w<Cr>:make<Cr>
autocmd Filetype cpp nmap <buffer> <Space>m :<C-u>w<Cr>:make<Cr>
"}}}


" * plugins "{{{
" plug: tacahiroy
let g:tacahiroy_maintainer = 'Yoshihara'

"" plug: Syntastic
"" http://github.com/scrooloose/syntastic/
"let g:syntastic_enable_signs = 1
"let g:syntastic_auto_loc_list = 1

" plug: NeocomplCache {{{
let g:NeoComplCache_EnableAtStartup = 1
let g:NeoComplCache_TagsAutoUpdate = 1
"let g:NeoComplCache_EnableCamelCaseCompletion = 1
let g:NeoComplCache_EnableUnderbarCompletion = 1
let g:NeoComplCache_CachingDisablePattern = '\(\.vimprojects\|\[Scratch\]\|\.vba\|\.aspx\)'
let g:NeoComplCache_EnableQuickMatch = 0
let g:NeoComplCache_MinKeywordLength = 2
let g:NeoComplCache_MinSyntaxLength = 2
let g:NeoComplCache_DictionaryFileTypeLists = {
    \ 'default':  $DOTVIM.'/dict/gene.txt',
    \ 'rb':       $DOTVIM.'/dict/n.dict',
    \ 'sql':      $DOTVIM.'/dict/n.dict',
    \ 'vbnet':    $DOTVIM.'/dict/n.dict',
    \ 'vb':       $DOTVIM.'/dict/n.dict',
    \ }
let g:NeoComplCache_PluginCompletionLength = {
  \ 'snipMate_complete':  1,
  \ 'buffer_complete':    1,
  \ 'include_complete':   2,
  \ 'syntax_complete':    2,
  \ 'filename_complete':  2,
  \ 'keyword_complete':   2,
  \ 'omni_complete':      1,
  \ }
let g:NeoComplCache_IncludePath = {
  \ 'ruby': '.,D:/usr/ruby2',
  \ 'vbnet': '.',
  \ }
let g:NeoComplCache_IncludeExpr = {
  \ 'ruby': 'substitute(v:fname,''\\.'',''/'',''g'')',
  \ }
let g:NeoComplCache_IncludePattern = {
  \ 'ruby': '^require',
  \ }

inoremap <expr> <C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
"inoremap <expr> <silent> <C-g> neocomplcache#undo_completion()
inoremap <expr> <C-l> &filetype == 'vim' ? "\<C-x><C-v><C-p>" : neocomplcache#manual_omni_complete()
"inoremap <expr> <C-n> pumvisible() ? "\<C-n>" : neocomplcache#manual_keyword_complete()
" }}}

" plug: NERD Commenter
let g:NERDMenuMode = 0

" plug: ns9's fuzzyfinder "{{{
let g:fuf_modesDisable = ['mrucmd']
let g:fuf_ignoreCase = 1
let g:fuf_keyOpen = '<Return>'
let g:fuf_keyOpenSplit = '<S-Return>'
let g:fuf_keyOpenVsplit = '<C-Return>'
let g:fuf_abbrevMap = {}
let g:fuf_mrufile_maxItem = 100
let g:fuf_file_exclude = '\v\~$|\.(o|exe|bak|swp|sln|suo|scc|bak|resx|vspscc)$' .
                       \ '|(^|[/\\])(\.hg|\.git|\.bzr|[\.|_]svn|bin|build)($|[/\\])' .
                       \ '|^((AssemblyInfo\.vb)|(Global\.asax.*)|(tags))$'

nnoremap <silent> <Space>ff :FufFile<Cr>
nnoremap <silent> <Space>fb :FufBuffer<Cr>
nnoremap <silent> <Space>fa :FufBookmark<Cr>
nnoremap <silent> <Space>fm :FufMruFile<Cr>
"}}}

" plug: Align
let g:DrChipTopLvlMenu = ''
let g:Align_xstrlen = 0

" plug: QFixHowm {{{
augroup QFixHowm
  autocmd!
  "Howmコマンドキーマップ
  let QFixHowm_Key = ','
  "Howmコマンドの2ストローク目キーマップ
  let QFixHowm_KeyB = ','
  "MRUのサマリー表示
  let QFixHowm_MRU_SummaryMode = 0
  " 折りたたみ
  let QFixHowm_Folding = 0
  " 折りたたみパターン
  "let QFixHowm_FoldingPattern = '^\\s\\s[=.*[]'
  let QFixHowm_FoldingPattern = ''

  " preview off
  let g:QFix_PreviewEnable = 0
  let g:QFixHowm_SchedulePreview = 0
  " close preview window after howm_memo opened
  let g:QFix_CloseOnJump = 1

  "howm_dirはファイルを保存したいディレクトリを設定。
  let howm_dir = 'D:/home/Administrator/howm'
  "let howm_filename = '%Y/%m/%Y-%m-%d-%H%M%S.howm'
  "一日一ファイルで使用する
  let howm_filename = '%Y/%m/%Y-%m-%d-000000.howm'
  let howm_fileencoding = 'cp932'
  let howm_fileformat = 'dos'

  "let g:MyGrepcmd = '"#prg#" #defopt# #recopt# #opt# #useropt# /g:#searchWordFile# #searchPath#'
  "let mygrepprg = 'findstr'
  "let g:MyGrepcmd_fix = '/s /n '
  "let g:MyGrepcmd_fix_ignore = '/s /n /i'
  let g:MyGrepcmd = '"#prg#" #defopt# #recopt# #opt# #useropt# --file=#searchWordFile# #searchPath#'
  let mygrepprg = 'egrep'
  let g:MyGrepcmd_fix = '-nHr'
  let g:MyGrepcmd_fix_ignore = '-inHr'

  let MyGrep_ShellEncoding = 'cp932'

  "ブラウザの指定
  if has('win32')
    " Firefox
    let MyOpenURI_cmd  = '!start "D:/usr/Mozilla Firefox/firefox.exe" -new-tab %s'
  elseif has('unix')
    let MyOpenURI_cmd = 'call system("firefox %s &")'
  endif
augroup END
" }}}

" plug: prtdialog
let g:prd_fontList  = 'M+1VM+IPAG_circle:h10:cDEFAULT'
let g:prd_fontList .= ',M+2VM+IPAG_circle:h10:cDEFAULT'
let g:prd_fontList .= ',VL_ゴシック:h10:cDEFAULT'
let g:prd_fontList .= ',Takaoゴシック:h10:cDEFAULT'
let g:prd_fontList .= ',Takao明朝:h10:cDEFAULT'
let g:prd_fontList .= ',ＭＳ_明朝:h10:cDEFAULT'
"}}}


if has('multi_byte_ime') || has('xim')
  set iminsert=0 imsearch=0
  imap <silent> <Esc> <Esc>:<C-u>set iminsert=0<Cr>
endif


" * commands {{{
" open loaded buffer with new tab.
command! -nargs=1 -complete=buffer NTab :999tab sbuffer <args>
command! Big wincmd _ | wincmd |

if ! exists(':DiffOrig')
  command! DiffOrig
        \ vnew | setlocal buftype=nofile | read# | 0d_ | diffthis | wincmd p | diffthis
endif

command! -nargs=0 Dioff  :windo diffoff
command! -nargs=0 Dithis :windo diffthis
" }}}

if filereadable(expand('~/.vimrc.mine'))
  source ~/.vimrc.mine
endif

if filereadable($DOTVIM . '/ftplugin/tacahiroy/tacahiroy.vim')
  source $DOTVIM/ftplugin/tacahiroy/tacahiroy.vim
endif

set runtimepath+=$DOTVIM/sandbox

" __END__ {{{
" vim: ts=2 sts=2 sw=2 fdm=marker

