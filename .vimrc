" plugins for vim dev
silent! packadd! vim-textobj-user
silent! packadd! vim-textobj-function
silent! packadd! vim-textobj-function-vim-extra

silent! packadd! vader.vim

silent! packadd! yadk

filetype off
filetype plugin off
set nofoldenable


" make this development version of plugin higher in &rtp and higher priority
" than the public version I might have installed under ~/.vim
let &runtimepath =  expand('<sfile>:p:h') . ',' . &runtimepath
let &runtimepath =  expand('<sfile>:p:h') . '/after,' . &runtimepath
" let &runtimepath =  expand('<sfile>:p:h') . '/ftdetect,' . &runtimepath
" let &runtimepath =  expand('<sfile>:p:h') . '/ftplugin,' . &runtimepath
" let &runtimepath =  expand('<sfile>:p:h') . '/syntax,' . &runtimepath

set foldenable
filetype on
filetype plugin on
filetype indent on
syntax on
