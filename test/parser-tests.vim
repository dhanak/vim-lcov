let s:suite = themis#suite('lcov test suite')
let s:assert = themis#helper('assert')

function! s:suite.before_each()
endfunction

function! s:suite.after_each()
endfunction

function! s:suite.test_parse_lcov_empty()
  let l:lines = split('', "\n")
  let l:got = lcov#parser#ParseCoverageData(l:lines, 'somefilename')
  let l:expected = []
  call s:assert.equals(l:got, l:expected)
endfunction

function! s:suite.test_parse_lcov_file_not_exists()
  let l:data = "TN:\n
        \SF:internal/log.go\n
        \DA:11,0\n
        \DA:19,0\n
        \DA:20,0\n
        \DA:21,0\n
        \SF:internal/utils.go\n
        \DA:11,0\n
        \DA:19,0\n
        \DA:20,0\n
        \DA:21,0\n
        \DA:22,0"
  let l:lines = split(l:data, "\n")
  let l:got = lcov#parser#ParseCoverageData(l:lines, 'somefilename')
  let l:expected = []
  call s:assert.equals(l:got, l:expected)
endfunction

function! s:suite.test_parse_lcov_da_only()
  let l:data = "TN:\n
        \SF:internal/log.go\n
        \DA:11,0\n
        \DA:19,0\n
        \DA:20,0\n
        \DA:21,0\n
        \DA:22,0
        \end_of_record"
  let l:lines = split(l:data, "\n")
  let l:got = lcov#parser#ParseCoverageData(l:lines, 'path/to/internal/log.go')
  let l:expected = [[
        \  {'lnum': 11, 'hit': 0},
        \  {'lnum': 19, 'hit': 0},
        \  {'lnum': 20, 'hit': 0},
        \  {'lnum': 21, 'hit': 0},
        \  {'lnum': 22, 'hit': 0},
        \  ],[]]
  call s:assert.equals(l:got, l:expected)
endfunction

function! s:suite.test_parse_lcov_ba_only()
  let l:data = "TN:\n
        \SF:internal/utils.go\n
        \DA:11,0\n
        \DA:19,0\n
        \DA:20,0\n
        \end_of_record\n
        \SF:internal/log.go\n
        \BRDA:4,0,0,-\n
        \BRDA:4,0,1,-\n
        \BRDA:4,0,2,3\n
        \BRDA:4,0,3,2\n
        \BRDA:4,0,4,-"
  let l:lines = split(l:data, "\n")
  let l:got = lcov#parser#ParseCoverageData(l:lines, 'path/to/internal/log.go')
  let l:expected = [[],[
        \  {'lnum': 4, 'hit': 0},
        \  {'lnum': 4, 'hit': 0},
        \  {'lnum': 4, 'hit': 3},
        \  {'lnum': 4, 'hit': 2},
        \  {'lnum': 4, 'hit': 0},
        \  ]]
  call s:assert.equals(l:got, l:expected)
endfunction

function! s:suite.test_parse_lcov_typical()
  let l:data = "TN:\n
        \SF:internal/utils.go\n
        \DA:11,0\n
        \DA:19,0\n
        \DA:20,0\n
        \end_of_record\n
        \SF:internal/log.go\n
        \BRDA:4,0,0,-\n
        \BRDA:4,0,1,-\n
        \BRDA:4,0,2,3\n
        \BRDA:4,0,3,2\n
        \BRDA:4,0,4,-\n
        \DA:11,0\n
        \DA:19,0\n
        \DA:20,0\n
        \end_of_record"
  let l:lines = split(l:data, "\n")
  let l:got = lcov#parser#ParseCoverageData(l:lines, 'path/to/internal/log.go')
  let l:expected = [
        \ [
          \  {'lnum': 11, 'hit': 0},
          \  {'lnum': 19, 'hit': 0},
          \  {'lnum': 20, 'hit': 0},
          \ ],
          \ [
            \  {'lnum': 4, 'hit': 0},
            \  {'lnum': 4, 'hit': 0},
            \  {'lnum': 4, 'hit': 3},
            \  {'lnum': 4, 'hit': 2},
            \  {'lnum': 4, 'hit': 0},
            \  ]]
  call s:assert.equals(l:got, l:expected)
endfunction
