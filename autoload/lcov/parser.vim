let s:saved_cpo = &cpoptions
set cpoptions&vim

" TODO: make it Vim9

function! lcov#parser#ParseCoverageData(lines, filepath) abort
  let l:das = []
  let l:bas = []

  let l:idx = -1
  for l:line in a:lines
    let l:idx += 1

    " find the source file of current file
    if l:line[0:2] !=# 'SF:' | continue | endif
    if stridx(a:filepath, l:line[3:]) < 0 | continue | endif

    " start collecting data until reaching `end_of_record`
    while l:idx < len(a:lines)
      let l:line = a:lines[l:idx]
      if l:line ==# 'end_of_record' | break | endif
      if l:line[0:2] ==# 'DA:'
        let [l:lnum, l:hit] = split(l:line[3:], ',')[0:1]
        let l:das += [{'lnum': str2nr(l:lnum), 'hit': str2nr(l:hit)}]
      elseif l:line[0:4] ==# 'BRDA:'
        let [l:lnum, l:blocknum, l:brnum, l:token] = split(l:line[5:], ',')
        let l:bas += [{
              \ 'lnum': str2nr(l:lnum),
              \ 'hit': l:token ==# '-' ? 0 : str2nr(l:token)}]
      endif
      let l:idx += 1
    endwhile
    return [l:das, l:bas]
  endfor

  " return [l:das, l:bas]
  return []
endfunction


let &cpoptions = s:saved_cpo
unlet s:saved_cpo
