function! CustomStatusLine()
    let s = ' %f'
    if &modified || !&modifiable
        let s .= ' %m'
    endif
    if &readonly
        let s .= ' %r'
    endif
    let s .= ' %= '
    let s .= '%c'
    let max_row = line('$')
    let max_digits_in_row_number = strlen(max_row)
    let s .= ' %' . max_digits_in_row_number . 'l/%L'
    return s
endfunction

set statusline=%!CustomStatusLine()
