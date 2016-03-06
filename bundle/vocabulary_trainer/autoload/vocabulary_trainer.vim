let s:vocabulary_trainer_buffer = 'VOCABULARY_TRAINER'
let s:number_of_sessions = 0
let s:question_prefix = '? '
let s:answer_prefix = '> '

function! vocabulary_trainer#TrainVocabulary()
    let s:number_of_sessions += 1
    let vocabulary_file = s:prompt_for_vocabulary_file()
    call s:move_to_vocabulary_trainer_buffer()
    call s:add_title(vocabulary_file)
    call s:determine_direction_of_translation()
    let b:vocabulary_list = s:read_vocabulary_list(vocabulary_file)
    let b:current_entry = 0
    call s:prompt_for_translation(b:current_entry)
endfunction

function! s:prompt_for_vocabulary_file()
    return expand(input('File: ', '', 'file'))
endfunction

function! s:add_title(filename)
    call append(0, 'File: ' . a:filename)
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

function! s:move_to_vocabulary_trainer_buffer()
    let buffer_name = s:vocabulary_trainer_buffer . '_' . s:number_of_sessions
    let buffer_is_new = ! bufexists(buffer_name)
    let win = bufwinnr(buffer_name)
    if win == -1
        execute 'vsplit ' . buffer_name
    else
        execute win . 'wincmd w'
    endif
    if buffer_is_new
        call s:set_buffer_options()
        call s:set_up_mappings()
    endif
endfunction

function! s:set_buffer_options()
    setlocal buftype=nofile
    setlocal filetype=vocabulary_trainer
endfunction

function! s:set_up_mappings()
    inoremap <buffer> <cr> <esc>:call <sid>is_correct()<cr>
    nnoremap <buffer> <silent> q :bwipeout<cr>
endfunction

function! s:prompt_for_translation(entry)
    if a:entry >= len(b:vocabulary_list)
        call s:mark_session_as_finished()
        return
    endif
    let question = b:vocabulary_list[a:entry][b:question]
    let prompt = s:question_prefix . question
    call append(line('$'), prompt)
    execute "normal! Go> \<esc>"
    startinsert!
endfunction

function! s:mark_session_as_finished()
    call append(line('$'), ['', 'Done.'])
    normal! gg
endfunction

function! s:is_correct()
    let answer = s:find_answer(getline(line('.')))
    let correct_answer = s:find_correct_answer()
    let marker = (answer ==? correct_answer) ? '+' : '-'
    execute 'normal! A ' . marker . "\<esc>"
    let b:current_entry += 1
    call s:prompt_for_translation(b:current_entry)
endfunction

function! s:find_answer(line)
    return s:trim(substitute(a:line, '\v^[>\s]*', '', ''))
endfunction!

function! s:find_correct_answer()
    return b:vocabulary_list[b:current_entry][b:answer]
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
