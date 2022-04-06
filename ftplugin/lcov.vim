let s:saved_cpo = &cpoptions
set cpoptions&vim

function! s:JumpTo(motion) abort
  let l:count = v:count1
  let l:saved = @/
  mark '
  while l:count > 0
    silent! execute a:motion
    let l:count -= 1
  endwhile
  call histdel('/', -1)
  let @/ = l:saved
endfunction

nnoremap <script> <silent> <buffer> ]] :<C-U>call <SID>JumpTo('/'.'\v^SF:')<cr>
nnoremap <script> <silent> <buffer> [[ :<C-U>call <SID>JumpTo('?'.'\v^SF:')<cr>
nnoremap <script> <silent> <buffer> ][ :<C-U>call <SID>JumpTo('/'.'\vend_of_record')<cr>
nnoremap <script> <silent> <buffer> [] :<C-U>call <SID>JumpTo('?'.'\vend_of_record')<cr>

setlocal foldenable
setlocal foldmethod=expr
setlocal foldexpr=lcov#SourceFileFolds(v:lnum)
setlocal foldlevel=0
setlocal foldcolumn=0

let &cpoptions = s:saved_cpo
unlet s:saved_cpo
