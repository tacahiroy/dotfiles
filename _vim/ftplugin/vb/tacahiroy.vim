" Language: Visual Basic
" Description: Visual Basic filetype plugin
" Maintainer: Tacahiroy
" Last Change: 13-May-2010.

if exists('b:did_vb_tacahiroy_ftplugin')
  finish
endif
let b:did_vb_tacahiroy_ftplugin = 1


function! s:vbpChoice(dir)
  let res = globpath(a:dir, "*.vbp")
  if len(res) == 0
    echo "vbp(s) is not found."
    return ''
  endif

  let vbps = split(res, "\n")
  if len(vbps) == 1
    return vbps[0]
  endif

  let i = 1
  for vbp in vbps
    let vbps[i] = printf("%2d: %s", i, vbp)
    let i += 1
  endfor

  let choice = ""
  while len(choice) == 0
    let ans = inputlist(vbps)
    if ans == 0
      return ''
    endif

    if ans !~# '^\d\{1,2}$'
      continue
    endif
    let choice = get(vbps, ans - 1, "")
  endwhile

  return substitute(choice, '^\s*\d\+\s*:', '', '')
endfunction


if ! exists(":Vbp")
  command! -buffer -nargs=0 Vbp let vbp = s:vbpChoice(".") | if 0 < len(vbp) | call system(' start "" ' . vbp) | endif
endif

if ! exists("no_plugin_maps") && ! exists("no_vb_maps")
  nmap <buffer><F5> :Vbp<Cr>
endif

setlocal commentstring='%s

setlocal expandtab tabstop=4 shiftwidth=4 softtabstop=4

" monstermethod support
" let g:mm_begin_vb = '^[\t ]*\%(\%(private\|protected\|friend\|public\)[\t ]\+\)\?' .
"                      \ '\%(sub\|function\)[\t ]\+\(\S\+\)('
" let g:mm_end_vb = '^[\t ]*end[\t ]\+\%(sub\|function\)[\t ]*'

" autocmd! CursorHold <buffer> nested let b:mmi = Tyoss.getMonsterMethodInfo('vb')
autocmd BufEnter <buffer> setlocal updatetime=500

if ! exists('b:undo_ftplugin')
  let b:undo_ftplugin = ''
else
  let b:undo_ftplugin = '|'
endif

let b:undo_ftplugin .= 'setlocal updatetime<'

"__END__

