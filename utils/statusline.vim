function! CustomStatusLine()
    let s = '%f'
    if &modified || !&modifiable
        let s .= ' %m'
    endif
    if &readonly
        let s .= ' %r'
    endif
    let s .= '%=%l/%L'
    return s
endfunction

set statusline=%!CustomStatusLine()
