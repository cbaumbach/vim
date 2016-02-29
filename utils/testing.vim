let s:testing_buffer = 'FAILED_ASSERTIONS'
let s:testing_counter = 0

function! Testthat(what, ...)
    if bufwinnr(s:testing_buffer) == -1
        let s:testing_counter = 0
    endif
    let assertions = a:000
    for i in range(len(assertions))
        let s:testing_counter += 1
        if !assertions[i]
            call s:fail(a:what . ' [' . (i+1) . ']')
        endif
    endfor
endfunction

function! s:fail(msg)
    call s:move_to_testing_buffer()
    if getline(1) != 'Failed assertions:'
        execute "normal! ggiFailed assertions:\<cr>\<esc>"
    endif
    call append(line('$'), s:testing_counter . ': ' . a:msg)
endfunction

function! s:move_to_testing_buffer()
    let buffer_is_new = ! bufexists(s:testing_buffer)
    let win = bufwinnr(s:testing_buffer)
    if win == -1
        execute 'vsplit ' . s:testing_buffer
    else
        execute win . 'wincmd w'
    endif
    if buffer_is_new
        setlocal buftype=nofile
        setlocal filetype=testing
        nnoremap <buffer> q ggdGZZ
    endif
endfunction
