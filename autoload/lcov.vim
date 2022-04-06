let s:saved_cpo = &cpoptions
set cpoptions&vim


function! lcov#SignRow(...) abort
  let l:lnum = a:1
  let l:uncovered = a:2
  let l:group = g:lcov_sign_group_name
  let l:name = l:uncovered == 0 ? 'LcovSignNotCovered' : 'LcovSignCovered'
  let l:buf = ''
  let l:priority = 9999 " high enough not to be blocked by other signs
  call sign_place(0, l:group, l:name, l:buf,
        \ {'lnum': l:lnum, 'priority': l:priority})
endfunction

let b:uncovered_sections = v:null
let b:covered_sections = v:null

function! lcov#BuildSections() abort
  let b:uncovered_sections = [ ]
  let b:covered_sections = [ ]
endfunction

function! lcov#OutHandler(channel, msg) abort
  " echom a:msg
endfunction

function! lcov#ErrorHandler(channel, msg) abort
  " echom a:msg
endfunction

function! lcov#CloseHandler(channel) abort
  while ch_status(a:channel, {'part': 'out'}) ==# 'buffered'
    let l:msg = ch_read(a:channel)
  endwhile
  echo 'Lcov: coverage data generation done.'
  call lcov#ShowCoverage()
endfunction

function! lcov#GenerateCoverage() abort
  let l:root_dir = lcov#utils#find_proj_root_dir()
  let l:lcov_build_script_dir =
        \ join([l:root_dir, g:lcov_build_script_dir], '/')
  let l:cmd = ['sh', '-c',
        \ 'cd '. l:lcov_build_script_dir. ' && ' . g:lcov_build_script]
  echom 'Building coverage: '. join(l:cmd, ' ')
  let l:job = job_start(l:cmd, {
        \ 'close_cb': 'lcov#CloseHandler',
        \ 'out_cb': 'lcov#OutHandler',
        \ 'err_cb': 'lcov#ErrorHandler'
        \ })
endfunction

function! lcov#ShowCoverage(...) abort
  let l:options = {'br':1, 'da':1}
  if a:0 > 0
    let l:options = a:1
  endif
  call lcov#ClearSigns()
  let l:lcovFile = lcov#utils#find_coverage_file()
  if l:lcovFile ==# v:null
    echom 'No coverage trace file found'
    return
  endif
  let l:lines = readfile(l:lcovFile)
  let l:f = expand('%:p')
  let l:data = lcov#parser#ParseCoverageData(l:lines, l:f)
  if len(l:data) == 0
    echo 'No coverage data found.' | return
  endif
  let [l:das, l:bas] = l:data
  if l:options['da'] == 1
    for l:line in l:das
      let l:name = l:line['hit'] == 0 ? 'LcovSignNotCovered' : 'LcovSignCovered'
      let l:buf = ''
      call sign_place(0, g:lcov_sign_group_name, l:name, l:buf,
            \ {'lnum': l:line['lnum'], 'priority': g:lcov_sign_priority})
    endfor
  endif
  if l:options['br'] == 1
    for l:line in l:bas
      let l:name = l:line['hit'] == 0 ? 'LcovSignBranchNotCovered' : 'LcovSignBranchCovered'
      let l:buf = ''
      " some lcov generator gives zero value (e.g. coverage.py lcov )
      " maybe I should let it throw out the error?
      if l:line['lnum'] == 0 | let l:line['lnum'] = 1 | endif
      call sign_place(0, g:lcov_sign_group_name, l:name, l:buf,
            \ {'lnum': l:line['lnum'], 'priority': g:lcov_sign_priority + 5})
    endfor
  endif
endfunction

function! lcov#HideCoverage() abort
  call sign_unplace(g:lcov_sign_group_name, {'buffer': ''})
endfunction

function! lcov#ClearSigns() abort
  call sign_unplace(g:lcov_sign_group_name, {'buffer': ''})
endfunction

function! lcov#TestDA(...) abort
  let l:lcovFile = lcov#utils#find_coverage_file()
  let l:lines = readfile(l:lcovFile)
  let l:f = a:0 == 0 ? expand('%:p') : a:1
  let [l:das, l:bas] = lcov#parser#ParseCoverageData(l:lines, l:f)
  " echo l:das
  for l:line in l:das
    let l:name = l:line['hit'] == 0 ? 'LcovSignNotCovered' : 'LcovSignCovered'
    let l:buf = ''
    call sign_place(0, g:lcov_sign_group_name, l:name, l:buf,
          \ {'lnum': l:line['lnum'], 'priority': g:lcov_sign_priority})
  endfor
endfunction

function! lcov#GetNextUncoveredSection(
      \ lnum, uncovered_sections, backwards) abort
  return [0, 0]
endfunction

" NextUncovered(backwards) search and moves the cursor to the next
" (v:count1)-th uncovered section from current cursor position.
" if argument 'backwards' evaluates to true then it is searching/moving
" backwards/upwards in the buffer
function! lcov#NextUncovered(backwards) abort
  let l:count = v:count1
  " FIXME: `mark '` better be left to the mapping definitions
  mark '
  while l:count > 0
    let l:lnum = line('.')
    let l:found = lcov#GetNextUncoveredSection(
          \ l:lnum, b:uncovered_sections, a:backwards)
    if l:found == [0, 0] | break | endif
    call setpos('.', [0, l:found[0], l:found[1], 0])
    let l:count -= 1
  endwhile
endfunction

" folding in lcov file is simple, each section is a fold
" a section starts with `SF:<source file>`
" a section ends with the next `end_of_record`
" there is only one level of folding
function! lcov#SourceFileFolds(lnum) abort
  let l:line = getline(a:lnum)
  if l:line =~# '^SF:'
    return '>1'
  elseif l:line ==# 'end_of_record'
    return '<1'
  else
    return '='
  endif
endfunction

function! lcov#OpenReport() abort
  let l:root_dir = lcov#utils#find_proj_root_dir()
  let l:path = join([l:root_dir, g:lcov_coverage_report_path], '/')
  if filereadable(l:path)
    silent exec "!open '" . l:path . "'"
    redraw!
  else
    echo 'Not report found at: ' . l:path
  endif
endfunction

let &cpoptions = s:saved_cpo
unlet s:saved_cpo
