let s:prompt = '>'
let s:buffer_width = 20

function! vocabulary_trainer#TrainVocabulary()
    call s:set_up_buffer()
    call s:prompt_for_translation()
endfunction

function! s:set_up_buffer()
    let buffer = s:make_new_buffer()
    call s:move_to_buffer(buffer)
    redraw
    let vocabulary_file = s:prompt_for_vocabulary_file()
    call s:determine_direction_of_translation()
    let b:vocabulary_list = s:read_vocabulary_list(vocabulary_file)
    let b:current_entry = 0
endfunction

function! s:make_new_buffer()
    let buffer_name_prefix = 'VOCABULARY_TRAINER'
    let s:buffer_id = 1
    while 1
        let buffer_name = buffer_name_prefix . '_' . s:buffer_id
        if !bufexists(buffer_name)
            break
        endif
        let s:buffer_id += 1
    endwhile
    let create = 1
    return bufnr(buffer_name, create)
endfunction

function! s:prompt_for_vocabulary_file()
    return expand(input('File: ', '', 'file'))
endfunction

function! s:determine_direction_of_translation()
    let right_to_left = s:trim(input(
        \ "Direction of translation?\n" .
        \ "[1] LEFT column to RIGHT column\n" .
        \ "[2] RIGHT column to LEFT column\n" .
        \ s:prompt . ' ', '1')) ==? '1'
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

function! s:move_to_buffer(buffer)
    execute 'vertical sbuffer' a:buffer
    execute 'vertical resize' s:buffer_width
    call s:set_buffer_options()
    call s:set_up_mappings()
endfunction

function! s:set_buffer_options()
    setlocal buftype=nofile
    setlocal filetype=vocabulary_trainer
endfunction

function! s:set_up_mappings()
    inoremap <buffer> <cr> <esc>:call <sid>is_correct()<cr>
    nnoremap <buffer> <silent> q :bwipeout<cr>
endfunction

function! s:prompt_for_translation()
    if b:current_entry >= len(b:vocabulary_list)
        call s:mark_session_as_finished()
        return
    endif
    let question = b:vocabulary_list[b:current_entry][b:question]
    call append(line('$'), '? ' . question)
    if getline(1) =~? '\v^\s*$'
        execute '1delete'
    endif
    execute "normal! Go> \<esc>"
    startinsert!
endfunction

function! s:mark_session_as_finished()
    call append(line('$'), ['', 'Done.'])
    normal! G$
endfunction

function! s:is_correct()
    let answer = s:find_answer(getline(line('.')))
    let correct_answer = s:find_correct_answer()
    let marker = (answer ==? correct_answer) ? '+' : '-'
    execute 'normal! A ' . marker . "\<esc>"
    let b:current_entry += 1
    call s:prompt_for_translation()
endfunction

function! s:find_answer(line)
    let leading_prompt = '\v^' . '[' . s:prompt . ']'
    let line_without_leading_prompt = substitute(a:line, leading_prompt, '', '')
    return s:trim(line_without_leading_prompt)
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
