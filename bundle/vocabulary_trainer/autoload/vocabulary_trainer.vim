let s:question = 0
let s:answer = 1

function! vocabulary_trainer#TrainVocabulary()
    let file = expand(input('File: ', '', 'file'))
    call s:determine_direction_of_translation()
    let vocabulary_list = s:read_vocabulary(file)
    call s:query_user(vocabulary_list)
endfunction

function! s:determine_direction_of_translation()
    let right_to_left = input(
        \ "Direction of translation?\n" .
        \ "[1] LEFT column to RIGHT column\n" .
        \ "[2] RIGHT column to LEFT column\n" .
        \ '> ', '1')
    redraw
    if right_to_left ==? '1'
        let s:question = 0
        let s:answer = 1
    else
        let s:question = 1
        let s:answer = 0
    endif
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
    return s:strip_space(input(s:prompt_string(a:entry)))
endfunction

function! s:prompt_string(entry)
    return '> ' . a:entry[s:question] . "\n"
endfunction

function! s:is_correct(answer, entry)
    return a:answer ==? a:entry[s:answer]
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

" ==== prompt_string =================================================

call Testthat("prompt_string works",
    \ s:prompt_string(['a', '']) == "> a\n")

" ==== is_correct ====================================================

call Testthat("is_correct works",
    \ s:is_correct('a', ['', 'a']),
    \ s:is_correct('', ['', '']),
    \ !s:is_correct('a', ['', 'b']))
