" Integration with tmux

function! TMUX_setup()
    if !exists("b:tmux_target_pane")
        let b:tmux_target_pane = input("tmux target pane: ")
    endif
endfunction

function! TMUX_send(text)
    " This works with tmux v2.0 but not with v1.6.
    " call system("tmux -L default load-buffer -", a:text)
    " The following works in both versions.
    call system("cat - | tmux -L default load-buffer -", a:text)
    call system("tmux -L default paste-buffer -d -t " . b:tmux_target_pane)
endfunction

function! TMUX_send_lines(number_of_lines) abort
    call TMUX_setup()
    " Save contents and type of unnamed register.
    let register_content = getreg('"')
    let register_type = getregtype('"')
    " Copy number_of_lines lines into unnamed register.
    execute "normal! " . a:number_of_lines . "yy"
    " Send contents of unnamed register to target pane.
    call TMUX_send(@")
    " Reinsert old contents and type into unnamed register.
    call setreg('"', register_content, register_type)
    " Advance number_of_lines lines.
    silent! execute "normal! " . a:number_of_lines . "j"
endfunction

function! TMUX_send_paragraph() abort
    call TMUX_setup()
    " Save contents and type of unnamed register.
    let register_content = getreg('"')
    let register_type = getregtype('"')
    normal! yip
    call TMUX_send(@")
    " Reinsert old contents and type into unnamed register.
    call setreg('"', register_content, register_type)
    " Advance to next paragraph.
    normal! }
    " Advance by another line unless we're at the of the buffer.
    if line(".") != line("$")
        normal! j
    endif
endfunction

function! TMUX_send_op(type, ...) abort
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
    call TMUX_send(@")
    let &selection = saved_selection
    " Reinsert old contents and type into unnamed register.
    call setreg('"', register_content, register_type)
endfunction

nnoremap <silent> cn :<c-u>call TMUX_send_lines(v:count1)<cr>
nnoremap <silent> cc :call TMUX_send_paragraph()<cr>
xnoremap <silent> cc :<c-u>call TMUX_send_op("from-visual")<cr>`]l
nnoremap <silent> co :set operatorfunc=TMUX_send_op<cr>g@
