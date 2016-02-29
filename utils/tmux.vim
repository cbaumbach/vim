" Integration with tmux

function! s:setup()
    if !exists("b:target_pane")
        let b:target_pane = input("tmux target pane: ")
    endif
endfunction

function! s:send(text)
    " This works with tmux v2.0 but not with v1.6.
    " call system("tmux -L default load-buffer -", a:text)
    " The following works in both versions.
    call system("cat - | tmux -L default load-buffer -", a:text)
    call system("tmux -L default paste-buffer -d -t " . b:target_pane)
endfunction

function! s:send_lines(number_of_lines) abort
    call s:setup()
    " Save contents and type of unnamed register.
    let register_content = getreg('"')
    let register_type = getregtype('"')
    " Copy number_of_lines lines into unnamed register.
    execute "normal! " . a:number_of_lines . "yy"
    " Send contents of unnamed register to target pane.
    call s:send(@")
    " Reinsert old contents and type into unnamed register.
    call setreg('"', register_content, register_type)
    " Advance number_of_lines lines.
    silent! execute "normal! " . a:number_of_lines . "j"
endfunction

function! s:send_paragraph() abort
    call s:setup()
    " Save contents and type of unnamed register.
    let register_content = getreg('"')
    let register_type = getregtype('"')
    normal! yip
    call s:send(@")
    " Reinsert old contents and type into unnamed register.
    call setreg('"', register_content, register_type)
    " Advance to next paragraph.
    normal! }
    " Advance by another line unless we're at the of the buffer.
    if line(".") != line("$")
        normal! j
    endif
endfunction

function! s:send_op(type, ...) abort
    call s:setup()
    let saved_selection = &selection
    let &selection = "inclusive"
    " Save contents and type of unnamed register.
    let register_content = getreg('"')
    let register_type = getregtype('"')
    if a:type == "char"
        silent execute "normal! `[v`]y"
    elseif a:type == "line"
        silent execute "normal! `[V`]y"
    elseif a:type == "block"
        silent execute "normal! `[\<c-v>`]y"
    else  " called from visual mode
        silent execute "normal! gvy"
    endif
    call setreg('"', @", 'l')  " set register to linewise mode
    call s:send(@")
    let &selection = saved_selection
    " Reinsert old contents and type into unnamed register.
    call setreg('"', register_content, register_type)
endfunction

nnoremap <silent> cn :<c-u>call <sid>send_lines(v:count1)<cr>
nnoremap <silent> cc :call <sid>send_paragraph()<cr>
xnoremap <silent> cc :<c-u>call <sid>send_op("from-visual")<cr>`]l
nnoremap <silent> co :set operatorfunc=<sid>send_op<cr>g@
