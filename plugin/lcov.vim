let s:saved_cpo = &cpoptions
set cpoptions&vim

if exists('g:loaded_lcov')
  finish
endif
let g:loaded_lcov= 1

let g:lcov_sign_group_name = 'lcov'
" ALE sets a dummy sign at line 1 with default priority of 30, and it
" might block our sign from showing, so set the priority to 35 (>30)
" to override ALE dummy sign
let g:lcov_sign_priority      = get(g:, 'lcov_sign_priority',    35)
let g:lcov_highlight_line     = get(g:, 'lcov_highlight_line',    0)
let g:lcov_highlight_linenum  = get(g:, 'lcov_highlight_linenum', 1)
let g:lcov_highlight_marker_uncovered = get(g:, 'lcov_highlight_marker_uncovered', ' ')
let g:lcov_highlight_marker_covered   = get(g:, 'lcov_highlight_marker_covered', ' ')

let g:lcov_proj_root_markers = get(g:,
      \ 'lcov_proj_root_markers', ['.git', '.hg'] )
let g:lcov_coverage_files = get(g:,
      \ 'lcov_coverage_files', ['lcov.info', 'coverage.lcov'] )
let g:lcov_coverage_report_path = get(g:,
      \ 'lcov_coverage_report_path', 'coverage/index.html')

let g:lcov_build_script     = get(g:, 'lcov_build_script', 'make coverage-gen')
let g:lcov_build_script_dir = get(g:, 'lcov_build_script_dir', '')

"
" Define commands
"
command! -nargs=*  LcovShow   :call lcov#ShowCoverage({'br':1, 'da':1})
command! -nargs=*  LcovShowDa :call lcov#ShowCoverage({'br':0, 'da':1})
command! -nargs=*  LcovShowBr :call lcov#ShowCoverage({'br':1, 'da':0})
command! -nargs=*  LcovHide   :call lcov#HideCoverage(<f-args>)
command! -nargs=*  LcovGen    :call lcov#GenerateCoverage(<f-args>)
command! -nargs=*  LcovClear  :call lcov#ClearSigns(<f-args>)

command! -nargs=*  LcovReport :call lcov#OpenReport(<f-args>)

" test only
command! -nargs=*  LcovSign :call lcov#SignRow(<f-args>)
command! -nargs=*  LcovDA :call lcov#TestDA(<f-args>)

" reuse section movement ']C' and '[C' to jump to next/previous
" uncovered section
nnoremap <buffer> <silent> ]C :<C-U>call lcov#NextUncovered(0)<cr>
nnoremap <buffer> <silent> [C :<C-U>call lcov#NextUncovered(1)<cr>

" adjust signcolumn when colorscheme changed
augroup Lcov
  autocmd!
  autocmd ColorScheme * call <SID>DefineHighlights()
augroup END

call lcov#signcolors#DefineHighlights()
call lcov#signcolors#DefineSigns()

let &cpoptions = s:saved_cpo
unlet s:saved_cpo
