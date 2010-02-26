" Description: vim configuration file
" Maintainer: tacahiroy <tacahiroy<*DELETE-ME*>@gmail.com>
" Last Change: 26-Feb-2010.

if exists('g:loaded_vimrc')
  finish
endif
let g:loaded_vimrc = 1

if isdirectory($HOME.'/vimfiles')
  let $DOTVIM = $HOME.'/vimfiles'
else
  let $DOTVIM = $HOME.'/.vim'
endif

" remove all autocommands for the current group
autocmd!

set nocompatible
set verbose=0

syntax enable
filetype plugin indent on

set encoding=cp932
set termencoding=cp932

set ambiwidth=double
set autoindent
set autoread
set backspace=indent,eol,start
set backup
set backupext=.bac
set backupdir=$DOTVIM/backups
set backupskip+=*.bac,COMMIT_EDITMSG,hg-editor-*.txt,svn-commit.tmp,svn-commit.[0-9]*.tmp
set cmdheight=2
set completefunc=
set expandtab smarttab
set fileencodings=ucs-bom,utf-8,unicode,utf-16,default,ujis,cp932
set fileformats=dos,unix,mac
set hidden
set history=5000
set hlsearch
set ignorecase
set incsearch
set lazyredraw
set laststatus=2
set linespace=1 linebreak
set listchars=tab:>-,trail:-,extends:>,precedes:<,eol:<
set nolist
set number ruler
set previewheight=8
set shellslash
set shiftround
set showbreak=\ \ \ \ \ 
set showmatch matchtime=1
set showtabline=1
set nosmartcase
set smartindent
set swapfile
set directory=$DOTVIM/swaps
set switchbuf=useopen,usetab
set synmaxcol=300
set tags=./tags,tags;
set title
set titlestring=Vim:\ %F\ %h%r%m
set titlelen=255
set tabstop=2 shiftwidth=2 softtabstop=2
set viminfo='64,<100,s10,n~/.viminfo
set virtualedit=block
set wildmenu
set wildmode=list:longest
set nowrapscan

set guioptions+=M

" formatoptions
let &formatoptions .= 'mM'
let &formatoptions = substitute(&formatoptions, '[or]', '', 'g')

" [#bufnr]filename [modified?][enc:ff][filetype]
let g:lside = "[#%n]%<%f %m%r%h%w"
let g:lside .= "%#FileTypeOnStatusLine#%y%*"
let g:lside .= "%{'['.(&l:fileencoding !='' ? &l:fileencoding : &encoding).':'.&fileformat.']'}"
let g:rside = "%=%-16(\ %l/%LL,%vC\ %)%P"

let &statusline = g:lside . g:rside

set matchpairs+=<:>
"let g:loaded_matchparen = 0
hi MatchParen term=reverse ctermbg=11 gui=NONE guifg=fg guibg=LightCyan

" * command {{{
command! -nargs=1 -complete=buffer NTab :999tab sbuffer <args>
command! Big wincmd _ | wincmd |
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
nnoremap <silent> <Space>bn :bnext<Cr>
nnoremap <silent> <Space>bp :bprevious<Cr>
nnoremap <silent> sn :tabnext<Cr>
nnoremap <silent> sp :tabprevious<Cr>

nnoremap <silent> <Space>o :copen<Cr>

" inspired by vimrc.ujihisa
nnoremap <Space>w :w<Cr>
nnoremap <Space>q :q<Cr>
nnoremap <Space>W :w!<Cr>
nnoremap <Space>Q :q!<Cr>

nnoremap <silent> <Space>_ :<C-u>edit ~/.vimrc<Cr>

nnoremap <silent> <Esc> <Esc>:<C-u>silent nohlsearch<Cr>
nnoremap <silent> sh <C-w>h
nnoremap <silent> sk <C-w>k
nnoremap <silent> sl <C-w>l
nnoremap <silent> sj <C-w>j
nnoremap <MiddleMouse> <Nop>
nnoremap <2-MiddleMouse> <Nop>

" tag preview
nnoremap <silent> <Space>x <C-w>}
nnoremap <silent> <Space>X :pclose<Cr>

" plug: filtering.vim
"nnoremap <Space>f :call Gather(expand('<cword>'), 0)<CR>:echo<CR>

" cancel completion
imap <expr> <silent> <S-Esc> pumvisible() ? "\<C-e>" : "\<Esc>:<C-u>setlocal iminsert=0\<Cr>"
imap <expr> <Cr> pumvisible() ? "\<C-y>\<Cr>" : "\<Cr>"

inoremap <silent> ,dd <C-R>=exists('b:dd') ? b:dd : ''<Cr>
inoremap <silent> ,dt <C-R>=strftime('%Y.%m.%d')<Cr>
inoremap <silent> ,ti <C-R>=strftime('%H:%M')<Cr>
inoremap <silent> ,fn <C-R>=expand('%')<Cr>
inoremap <M-f> <Right>
inoremap <M-b> <Left>
inoremap <M-a> <Home>
inoremap <M-e> <End>

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

let g:surround_{char2nr("k")} = "「\r」"
let g:surround_{char2nr("K")} = "『\r』"
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

  autocmd BufEnter * execute ':lcd '.escape(expand('%:p:h'), ' ')

  autocmd BufReadPre * let g:updtime = &l:updatetime
  autocmd BufLeave,BufWinLeave * if exists('g:updtime') | let &l:updatetime = g:updtime | endif

  autocmd BufReadPost * if ! search("\\S", 'cnw') | let &l:fileencoding = &encoding | endif
  " restore cursor position
  autocmd BufReadPost * if line("'\"") | execute "normal '\"" | endif
augroup END

autocmd FileType qf,help nnoremap <buffer> <silent> q :quit<Cr>
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType javascript* setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType ruby,rspec let &path .= "," . g:convPathSep($RUBYLIB, 'unix')
" MS Excel
autocmd FileType excel setlocal tabstop=10 list

" inspired by vimrc.ujihisa
augroup MyIRB
  autocmd!
  autocmd FileType irb inoremap <buffer> <silent> <Cr> <Esc>:<C-u>ruby v=VIM::Buffer.current;v.append(v.line_number, '#=> ' + eval(v[v.line_number]).inspect)<Cr>jo
  nnoremap <Space>irb :<C-u>new<Cr>:setfiletype irb<Cr>
augroup END

augroup Rspec
  autocmd!
  autocmd FileType rspec
    \  compiler rspec
    \| setlocal syntax=ruby
    \| setlocal omnifunc=rubycomplete#Complete
augroup END

autocmd FileType vim,snippet setlocal tabstop=2 shiftwidth=2 softtabstop=2

augroup MarkUp
  autocmd!
  autocmd FileType html,xhtml,xml,xslt,mathml,svg
    \| setlocal tabstop=2 shiftwidth=2 softtabstop=2

  let g:xml_no_auto_nesting = 1
  let g:xml_use_xhtml = 1
  let g:xml_tag_completion_map = ''
augroup END

autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS tabstop=2 shiftwidth=2 softtabstop=2

let g:loaded_sql_completion = 1
augroup SQL
  autocmd!
  autocmd FileType sql,plsql
    \  setlocal tabstop=4 shiftwidth=4 softtabstop=4
    \| nnoremap <buffer> <silent> <C-Return> :DBExecSQLUnderCursor<Cr>
    \| vnoremap <buffer> <silent> <C-Return> :DBExecVisualSQL<Cr>

  let g:sqlutil_align_comma = 1
  let g:sqlutil_align_where = 1
  let g:sqlutil_keyword_case = "\\U"
  let g:dbext_default_type = 'ORA'
augroup END

augroup JS
  autocmd!
  autocmd FileType javascript,javascript.jquery,html,xhtml
    \  setlocal makeprg=jsl\ -conf\ D:/usr/bin/jsl.default.conf\ -nologo\ -nofilelisting\ -nosummary\ -nocontext\ -process\ %
    \| setlocal errorformat=%f(%l):\ %m
augroup END
"}}}


" * plugins "{{{
" plug: tacahiroy
let g:tacahiroy_maintainer = 'Yoshihara'

" plug: Syntastic
" http://github.com/scrooloose/syntastic/
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1

" plug: NeocomplCache {{{
let g:NeoComplCache_EnableAtStartup = 1
let g:NeoComplCache_TagsAutoUpdate = 1
let g:NeoComplCache_EnableCamelCaseCompletion = 1
let g:NeoComplCache_EnableUnderbarCompletion = 1
let g:NeoComplCache_CachingDisablePattern = '\(\.vimprojects\|\.aspx\)'
let g:NeoComplCache_EnableQuickMatch = 0
let g:NeoComplCache_MinKeywordLength = 2 
let g:NeoComplCache_MinSyntaxLength = 2 
let g:NeoComplCache_DictionaryFileTypeLists = {
    \ 'default':  $DOTVIM.'/dict/gene.txt',
    \ 'sql':      $DOTVIM.'/dict/nefoap.dict',
    \ 'vbnet':    $DOTVIM.'/dict/nefoap.dict',
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
  \ }
let g:NeoComplCache_IncludeExpr = {
  \ 'ruby': 'substitute(v:fname,''\\.'',''/'',''g'')',
  \ }
let g:NeoComplCache_IncludePattern = {
  \ 'ruby': '^require',
  \ }

"imap <silent> <C-l> <Plug>(neocomplcache_snippets_expand)
"smap <silent> <C-l> <Plug>(neocomplcache_snippets_expand)
inoremap <expr> <C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
inoremap <expr> <silent> <C-g> neocomplcache#undo_completion()
inoremap <expr> <C-l> &filetype == 'vim' ? "\<C-x><C-v><C-p>" : neocomplcache#manual_omni_complete()
" }}}

" plug: NERD Commenter
let g:NERDMenuMode = 0

" plug: ns9's fuf "{{{
let g:fuf_modesDisable = ['mrucmd']
let g:fuf_ignoreCase = 1
let g:fuf_keyOpen = '<Return>'
let g:fuf_keyOpenSplit = '<S-Return>'
let g:fuf_keyOpenVsplit = '<C-Return>'
let g:fuf_abbrevMap = {}
let g:fuf_mrufile_maxItem = 100

nnoremap <silent> <Space>fd :FufDir<Cr>
nnoremap <silent> <Space>ff :FufFile<Cr>
nnoremap <silent> <Space>fb :FufBuffer<Cr>
nnoremap <silent> <Space>fa :FufBookmark<Cr>
nnoremap <silent> <Space>fm :FufMruFile<Cr>
nnoremap <silent> <Space><C-]> :FufTagWithCursorWord!<Cr>
"}}}

" plug: Align
let g:DrChipTopLvlMenu = ''
let g:Align_xstrlen = 0

" plug: QFixHowm {{{
augroup QFixHowm
  autocmd!
  "Howmコマンドキーマップ
  let QFixHowm_Key = '<Space>'
  "Howmコマンドの2ストローク目キーマップ
  let QFixHowm_KeyB = ''
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
    " Internet explorer
    "let MyOpenURI_cmd = '!start "C:/Program Files/Internet Explorer/iexplore.exe" %s'
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
let g:prd_fontList .= ',UmePlus_Gothic:h10:cDEFAULT'
let g:prd_fontList .= ',ＭＳ_明朝:h10:cDEFAULT'
"}}} plugins


" * functions "{{{
" tag information show in command window
function! g:convPathSep(path, style)
  let styles = {'dos': ['/', "\\"],
    \           'unix': ["\\", '/']}

  if ! has_key(styles, a:style)
    return a:path
  endif

  return substitute(a:path, styles[a:style][0], styles[a:style][1], 'g')
endfunction

function! s:previewTagCasual(w)
  let t = taglist('^'.a:w.'$')
  let current = expand('%:t')

  for item in t
    " [filename] tag definition
    if -1 < stridx(item.filename, current)
      echohl Search | echomsg printf('%-36s', '['.substitute(item.filename, "\\", '/', 'g').']') | echohl None
    else
      echomsg printf('%-36s', '['.substitute(item.filename, "\\", '/', 'g').']')
    endif
    echohl Function | echomsg substitute(substitute(item.cmd,"/^[\t ]*",'',''),"[\t ]*$/",'','') | echohl None
  endfor
endfunction
nnoremap <silent> ,ta :call <SID>previewTagCasual(expand('<cword>'))<Cr>

if executable('ruby') "{{{
  " RubyInstantExec
  " preview interpreter's output(Tip #1244) improbed
  function! s:RubyInstantExec() range
    if &filetype !=# 'ruby'
      echomsg 'please execute command, ":setfiletype ruby<Cr>".'
      return
    endif

    " recycle buffer
    if !exists('g:src')
      let g:src = 'vimrie.tmp'
    endif
    let buf_name = 'RubyInstantExec Result'

    " put current buffer's content in a temp file
    silent execute printf(': %d,%dw! >> %s', a:firstline, a:lastline, g:src)

    " open the preview window
    silent execute ':pedit! ' . escape(buf_name, "\\ ")
    " change to preview window
    wincmd P

    setlocal buftype=nofile
    setlocal noswapfile
    setlocal syntax=none
    setlocal bufhidden=delete

    " replace current buffer with ruby's output
    silent execute printf(':%%!ruby %s %s %s 2>&1', g:rie.ruby_opts, g:src, g:rie.args)
    " change back to the source buffer
    wincmd p

    call delete(g:src)
  endfunction

  vmap <silent> <Space>r :call <SID>RubyInstantExec()<Cr>
  nmap <silent> <Space>r mzggVG<Space>r`z:delm z<Cr>
endif
"}}}
"}}}


if has('multi_byte_ime') || has('xim')
  set iminsert=0 imsearch=0
  imap <silent> <Esc> <Esc>:<C-u>set iminsert=0<Cr>
endif

if ! exists(':DiffOrig')
  command! DiffOrig
        \ vnew | setlocal buftype=nofile | read# | 0d_ | diffthis | wincmd p | diffthis
endif

command! Dioff  :windo diffoff
command! Dithis :windo diffthis

if filereadable(expand('~/.vimrc.mine'))
  source ~/.vimrc.mine
endif

if filereadable($DOTVIM.'/ftplugin/tacahiroy/tacahiroy.vim')
  source $DOTVIM/ftplugin/tacahiroy/tacahiroy.vim
endif

set runtimepath+=$HOME/vimfiles/sandbox

" vim: ts=2 sts=2 sw=2 fdm=marker
" __END__

