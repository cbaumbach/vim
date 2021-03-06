let s:prompt = '>'
let s:buffer_width = 20

function! vocabulary_trainer#Train(...)
    let d = s:parse_arguments(a:000)
    call s:prepare_buffer(d)
    call s:prompt_for_translation()
endfunction

function! s:prepare_buffer(d)
    let buffer = s:make_new_buffer()
    call s:move_to_buffer(buffer)
    let b:vocabulary_list = s:read_vocabulary_list(a:d['file'])
    let b:question = a:d['question']
    let b:answer = a:d['answer']
    let b:current_entry = 0
endfunction

function! s:parse_arguments(args)
    let number_of_arguments = len(a:args)
    if number_of_arguments == 0
        let file = s:prompt_for_vocabulary_file()
        let right_to_left = 0
    elseif number_of_arguments == 1
        let file = a:args[0]
        let right_to_left = 0
    else
        let file = a:args[0]
        let right_to_left = (a:args[1]) ? 1 : 0
    endif
    let d = {}
    let d['file'] = file
    let d['question'] = (right_to_left ? 1 : 0)
    let d['answer'] = 1 - d['question']
    return d
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
