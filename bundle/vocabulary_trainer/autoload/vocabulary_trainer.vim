let s:vocabulary_trainer_buffer = 'VOCABULARY_TRAINER'
let s:number_of_sessions = 0
let s:question_prefix = '? '
let s:answer_prefix = '> '

function! vocabulary_trainer#TrainVocabulary()
    let s:number_of_sessions += 1
    let file = expand(input('File: ', '', 'file'))
    call s:move_to_vocabulary_trainer_buffer(file)
    call s:determine_direction_of_translation()
    let b:vocabulary_list = s:read_vocabulary_list(file)
    let b:current_entry = 0
    call s:prompt_for_translation(b:current_entry)
endfunction

function! s:determine_direction_of_translation()
    let right_to_left = s:trim(input(
        \ "Direction of translation?\n" .
        \ "[1] LEFT column to RIGHT column\n" .
        \ "[2] RIGHT column to LEFT column\n" .
        \ s:answer_prefix, '1')) ==? '1'
    redraw
    if right_to_left
        let b:question = 0
        let b:answer = 1
    else
        let b:question = 1
        let b:answer = 0
    endif
endfunction

function! s:read_vocabulary_list(file)
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
        return [s:trim(pair[0]), s:trim(pair[1])]
    else
        return []
    endif
endfunction

function! s:trim(s)
    return substitute(substitute(a:s, '\v^\s+', '', ''), '\v\s+$', '', '')
endfunction

function! s:move_to_vocabulary_trainer_buffer(filename)
    let buffer_name = s:vocabulary_trainer_buffer . '_' . s:number_of_sessions
    let buffer_is_new = ! bufexists(buffer_name)
    let win = bufwinnr(buffer_name)
    if win == -1
        execute 'vsplit ' . buffer_name
    else
        execute win . 'wincmd w'
    endif
    if buffer_is_new
        setlocal buftype=nofile
        setlocal filetype=vocabulary_trainer
        inoremap <buffer> <cr> <esc>:call <sid>is_correct()<cr>
        nnoremap <buffer> <silent> q :bwipeout<cr>
        call append(0, 'File: ' . a:filename)
    endif
endfunction

function! s:prompt_for_translation(entry)
    if a:entry >= len(b:vocabulary_list)
        call append(line('$'), ['', 'Done.'])
        normal! gg
        return
    endif
    let question = b:vocabulary_list[a:entry][b:question]
    call append(line('$'), s:question_prefix . question)
    execute "normal! Go> \<esc>"
    startinsert!
endfunction

function! s:is_correct()
    let this_line = getline(line('.'))
    let answer = s:trim(substitute(this_line, '\v^[>\s]*', '', ''))
    let correct_answer = b:vocabulary_list[b:current_entry][b:answer]
    if answer ==? correct_answer
        execute "normal! A +\<esc>"
    else
        execute "normal! A -\<esc>"
    endif
    let b:current_entry += 1
    call s:prompt_for_translation(b:current_entry)
endfunction

" ==== trim ==========================================================

call Testthat("trim works",
    \ s:trim('') == '',
    \ s:trim(' ') == '',
    \ s:trim('  a') == 'a',
    \ s:trim('a  ') == 'a',
    \ s:trim('  a  ') == 'a',
    \ s:trim('  a b  ') == 'a b')

" ==== new_entry =====================================================

call Testthat("new_entry works",
    \ s:new_entry('') == [],
    \ s:new_entry("a\t") == [],
    \ s:new_entry("\tb") == [],
    \ s:new_entry("a\tb") == ['a', 'b'],
    \ s:new_entry("  a  \t  b  ") == ['a', 'b'])
