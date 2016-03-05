function! vocabulary_trainer#TrainVocabulary()
    let file = expand(input('File: ', '', 'file'))
    let vocabulary_list = s:read_vocabulary(file)
    call s:query_user(vocabulary_list)
endfunction

function! s:read_vocabulary(file)
    let vocabulary_list = []
    for line in readfile(a:file)
        let entry = s:new_entry(line)
        if !empty(entry)
            call add(vocabulary_list, entry)
        endif
    endfor
    return vocabulary_list
endfunction

function! s:new_entry(line)
    if a:line =~? '\v^\s*$'
        return []
    endif
    let pair = split(a:line, '\t')
    if len(pair) == 2
        return [s:strip_space(pair[0]), s:strip_space(pair[1])]
    else
        return []
    endif
endfunction

function! s:strip_space(s)
    return substitute(substitute(a:s, '\v^\s+', '', ''), '\v\s+$', '', '')
endfunction

function! s:query_user(vocabulary_list)
    for entry in a:vocabulary_list
        let answer = s:prompt(entry)
        if s:is_correct(answer, entry)
            echohl CorrectAnswer | echo answer | echohl None
        else
            echohl WrongAnswer | echo answer | echohl None
        endif
    endfor
endfunction

function! s:prompt(entry)
    return s:strip_space(input('> ' . a:entry[0] . "\n"))
endfunction

function! s:is_correct(answer, entry)
    return a:answer ==? a:entry[1]
endfunction

hi CorrectAnswer ctermfg=Green ctermbg=Black guifg=Green guibg=Black
hi WrongAnswer ctermfg=Red ctermbg=Black guifg=Red guibg=Black

" ==== strip_space ===================================================

call Testthat("strip_space works",
    \ s:strip_space('') == '',
    \ s:strip_space(' ') == '',
    \ s:strip_space('  a') == 'a',
    \ s:strip_space('a  ') == 'a',
    \ s:strip_space('  a  ') == 'a',
    \ s:strip_space('  a b  ') == 'a b')

" ==== new_entry =====================================================

call Testthat("new_entry works",
    \ s:new_entry('') == [],
    \ s:new_entry("a\t") == [],
    \ s:new_entry("\tb") == [],
    \ s:new_entry("a\tb") == ['a', 'b'],
    \ s:new_entry("  a  \t  b  ") == ['a', 'b'])
