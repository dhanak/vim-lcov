let s:saved_cpo = &cpoptions
set cpoptions&vim


" if no proj root found, return the directory of the file
" in the current buffer
function! lcov#utils#find_proj_root_dir(...) abort
  let l:f = expand('%:p:h')
  if a:0 > 0
    let l:f = a:1
  endif

  let l:markers = copy(g:lcov_proj_root_markers)

  " NOTE: there are likely duplicate entries in l:markers
  let l:tried = {} " keep track of searched markers
  for l:marker in l:markers
    if has_key(l:tried, l:marker) | continue | endif
    let l:tried[l:marker] = 1

    let l:found_marker = finddir(l:marker.'/..', expand('%:p:h').';')
    if len(l:found_marker) == 0
      let l:found_marker = findfile(l:marker, expand('%:p:h').';')
    endif

    if !(empty(l:found_marker))
      return fnamemodify(l:found_marker, ':p:h')
    endif
  endfor
  return expand('%:p:h')
endfunction

function! lcov#utils#find_coverage_file() abort
  let l:root_dir = lcov#utils#find_proj_root_dir()
  for l:f in g:lcov_coverage_files
    let l:path = join([l:root_dir, l:f], '/')
    if filereadable(l:path)
      return l:path
    endif
  endfor
  return v:null
endfunction

let &cpoptions = s:saved_cpo
unlet s:saved_cpo
