let s:saved_cpo = &cpoptions
set cpoptions&vim

function! lcov#signcolors#DefineHighlights() abort
  if &background ==# 'dark'
    if &t_Co >= 256
      highlight LcovNotCoveredDefault ctermbg=52 guibg=#5f0000
      highlight link LcovBranchNotCoveredDefault LcovNotCoveredDefault
      highlight LcovCoveredDefault ctermbg=lightgreen guibg=#005f00
    else
      highlight LcovNotCoveredDefault ctermbg=darkred guibg=#5f0000
      highlight LcovBranchNotCoveredDefault ctermbg=darkred guibg=#5f0000
      highlight LcovCoveredDefault ctermbg=lightgreen guibg=#005f00
    endif
  else
    if &t_Co >= 256
      highlight LcovNotCoveredDefault ctermbg=224 guibg=#ffd7d7
      highlight LcovBranchNotCoveredDefault ctermbg=223 guibg=#ffd7af
      highlight LcovCoveredDefault ctermbg=lightgreen guibg=#005f00
    else
      highlight LcovNotCoveredDefault ctermbg=gray guibg=#ffcccc
      highlight link LcovBranchNotCoveredDefault LcovNotCoveredDefault
      highlight LcovCoveredDefault ctermbg=lightgreen guibg=#005f00
    endif
  endif
  highlight default link LcovNotCovered LcovNotCoveredDefault
  highlight default link LcovBranchNotCovered LcovBranchNotCoveredDefault
  highlight default link LcovCovered LcovCoveredDefault
endf

function! lcov#signcolors#DefineSigns() abort

  " Uncovered lines
  let l:sign_options = {
        \ 'texthl':'LcovNotCovered',
        \ 'text': g:lcov_highlight_marker_uncovered}
  if g:lcov_highlight_line
    let l:sign_options['linehl'] = 'LcovNotCovered'
  endif
  if g:lcov_highlight_linenum
    let l:sign_options['numhl'] = 'LcovNotCovered'
  endif
  call sign_define('LcovSignNotCovered',l:sign_options)
  call sign_define('LcovSignBranchNotCovered',l:sign_options)

  " Covered lines
  let l:sign_options = {
        \ 'texthl':'LcovCovered',
        \ 'text': g:lcov_highlight_marker_covered}
  if g:lcov_highlight_line
    let l:sign_options['linehl'] = 'LcovCovered'
  endif
  if g:lcov_highlight_linenum
    let l:sign_options['numhl'] = 'LcovCovered'
  endif
  call sign_define('LcovSignCovered',l:sign_options)
  call sign_define('LcovSignBranchCovered',l:sign_options)

endfunction

let &cpoptions = s:saved_cpo
unlet s:saved_cpo
