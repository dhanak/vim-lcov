let s:saved_cpo = &cpoptions
set cpoptions&vim

if exists('b:current_syntax')
  finish
endif

syntax match    lcovNumber  '\v\d+'
highlight link  lcovNumber  Number

syntax match    lcovColumn  '\v[^:]:[^:]'ms=s+1,me=e-1 contained
syntax match    lcovColumn  '\v[^:]:$'ms=s+1 contained
highlight link  lcovColumn  Delimiter

syntax match    lcovComma   ','
highlight link  lcovComma   Delimiter

" TN:<test name>
syntax match    lcovTN          '\v^TN:' contains=lcovColumn
syntax match    lcovTestName    /\v^TN\:.*$/hs=s+3 contains=lcovTN,lcovColumn
highlight link  lcovTN          Keyword
highlight link  lcovTestName    Label

" SF:<absolute path to the source file>
syntax match    lcovSF          '\v^SF:' contains=lcovColumn
syntax match    lcovSourceFile  /\v^SF:.*$/hs=s+3 contains=lcovSF,lcovColumn
highlight link  lcovSF          Keyword
highlight link  lcovSourceFile  String

" FN:<line number of function start>,<function name>
syntax match    lcovFN          '\v^FN:' contains=lcovColumn
syntax match    lcovFunction    '\v,[^\d].*$' contains=lcovComma
highlight link  lcovFN          Keyword
highlight link  lcovFunction    Function

" FNDA:<execution count>,<function name>
syntax match    lcovFNDA    '\v^FNDA:' contains=lcovColumn
highlight link  lcovFNDA    Keyword

" FNF:<number of functions found>
syntax match    lcovFNF     '\v^FNF:' contains=lcovColumn
highlight link  lcovFNF     Keyword

" FNH:<number of function hit>
syntax match    lcovFNH     '\v^FNH:' contains=lcovColumn
highlight link  lcovFNH     Keyword

" BRDA:<line number>,<block number>,<branch number>,<taken>
syntax match    lcovTaken   '\v,(-|\d+)$'hs=s+1 contains=lcovComma
syntax match    lcovBRDA    '\v^BRDA:.*$'he=s+4 contains=lcovColumn,lcovComma,lcovNumber,lcovTaken
highlight link  lcovBRDA    Keyword
highlight link  lcovTaken   String

" BRF:<number of branches found>
syntax match    lcovBRF   '\v^BRF:' contains=lcovColumn
highlight link  lcovBRF   Keyword

" BRH:<number of branches hit>
syntax match    lcovBRH   '\v^BRH:' contains=lcovColumn
highlight link  lcovBRH   Keyword

" DA:<line number>,<execution count>[,<checksum>]
syntax match    lcovDA    '\v^DA:.*$'he=s+3 contains=lcovColumn,lcovComma,lcovNumber
highlight link  lcovDA    Keyword

" LH:<number of lines with a non-zero execution count>
syntax match    lcovLH    '\v^LH:' contains=lcovColumn
highlight link  lcovLH    Keyword

" LF:<number of instrumented lines>
syntax match    lcovLF    '\v^LF:' contains=lcovColumn
highlight link  lcovLF    Keyword

" end_of_record
syntax keyword lcovSectionEnd end_of_record
highlight link lcovSectionEnd Statement

let b:current_syntax = 'lcov'

let &cpoptions = s:saved_cpo
unlet s:saved_cpo
