let s:saved_cpo = &cpoptions
set cpoptions&vim

let s:lcov_coverage_files = get(g:,
      \ 'lcov_coverage_files', ['lcov.info', 'coverage.lcov'] )

augroup lcov
  autocmd!
  autocmd BufNewFile,BufRead *.lcov set filetype=lcov
  for s:filename in s:lcov_coverage_files
    let s:autocmd = 'autocmd BufNewFile,Bufread ' . s:filename . ' set filetype=lcov'
    execute s:autocmd
  endfor
augroup END

let &cpoptions = s:saved_cpo
unlet s:saved_cpo
