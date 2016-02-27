" Adapted from 'Learn Vimscript the Hard Way' by Steve Losh.

setlocal foldmethod=expr
setlocal foldexpr=GetRFold(v:lnum)

function! GetRFold(lnum)
    let this_line = getline(a:lnum)
    if this_line =~? '\v^\s*$'
        return '-1'
    endif
    let this_indent = IndentLevel(a:lnum)
    if this_line =~? '\v^\s*}\s*$'
        return this_indent + 1
    endif
    let next_indent = IndentLevel(NextNonBlankLine(a:lnum))
    if next_indent <= this_indent
        return this_indent
    else
        return '>' . next_indent
    endif
endfunction

function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
    let number_of_lines = line('$')
    let line_number = a:lnum + 1
    while line_number <= number_of_lines
        if getline(line_number) =~? '\v\S'
            return line_number
        endif
        let line_number += 1
    endwhile
    let no_next_non_blank_line = -2
    return no_next_non_blank_line
endfunction
