setlocal indentexpr=GetRIndent()
setlocal indentkeys=0{,0},0),0#,!,o,O,e

function! GetRIndent()
    let this_line = getline(line('.'))
    let prev_line = s:previous_non_blank_line()
    let prev_indent = s:indent_from_string(prev_line, &shiftwidth)
    let relative_indent = s:relative_indent(prev_line, this_line)
    return (prev_indent + relative_indent) * &shiftwidth
endfunction

function! s:previous_non_blank_line()
    let prev = line('.') - 1
    while prev > 0
        let line = getline(prev)
        if line =~? '\v\S'
            return line
        endif
        let prev -= 1
    endwhile
    return ''
endfunction

function! s:indent_from_string(s, shiftwidth)
    let spaces = 0
    for c in s:string_to_list_of_char(a:s)
        if c == ' '
            let spaces += 1
        else
            break
        endif
    endfor
    return spaces / a:shiftwidth
endfunction

function! s:string_to_list_of_char(s)
    return split(a:s, '\zs')
endfunction

function! s:relative_indent(prev, this)
    if s:has_net_surplus_of_closed_delimiters(a:this)
            \ && s:has_net_surplus_of_open_delimiters(a:prev)
        return 0
    elseif s:has_net_surplus_of_closed_delimiters(a:this)
        return -1
    elseif s:has_net_surplus_of_closed_delimiters(a:prev)
            \ && ! s:has_trailing_comma(a:prev)
        return -1
    elseif s:has_net_surplus_of_open_delimiters(a:prev)
        return +1
    elseif s:has_control_flow_with_simple_expression(a:prev, a:this)
        return +1
    elseif s:has_else(a:this)
        return -1
    endif
    return 0
endfunction

function! s:has_net_surplus_of_open_delimiters(line)
    let open  = {'(':0,'[':0,'{':0}
    let close = {')':0,']':0,'}':0}
    let tr = {'(':')','[':']','{':'}',
            \ ')':'(',']':'[','}':'{'}
    for i in range(strlen(a:line))
        let ch = a:line[i]
        if !has_key(open, ch) && !has_key(close, ch)
            continue
        endif
        if has_key(close, ch) && open[tr[ch]] > 0
            let open[tr[ch]] -= 1
        elseif has_key(open, ch)
            let open[ch] += 1
        endif
    endfor
    for c in values(open)
        if c > 0
            return 1
        endif
    endfor
    return 0
endfunction

function! s:has_net_surplus_of_closed_delimiters(line)
    let open  = {'(':0,'[':0,'{':0}
    let close = {')':0,']':0,'}':0}
    let tr = {'(':')','[':']','{':'}',
            \ ')':'(',']':'[','}':'{'}
    for i in range(strlen(a:line))
        let ch = a:line[i]
        if !has_key(open, ch) && !has_key(close, ch)
            continue
        endif
        if has_key(close, ch) && open[tr[ch]] > 0
            let open[tr[ch]] -= 1
        elseif has_key(close, ch)
            let close[ch] += 1
        else
            let open[ch] += 1
        endif
    endfor
    for c in values(close)
        if c > 0
            return 1
        endif
    endfor
    return 0
endfunction

function! s:has_control_flow_with_simple_expression(prev, this)
    let keywords = ['if', 'else', 'for', 'while', 'repeat']
    for kw in keywords
        if a:prev =~? '\v<' . kw . '>\s*(\([^)]*\))?\s*$'
            if a:this !~? '\v^\s*\{\s*$'
                return 1
            endif
        endif
    endfor
    return 0
endfunction

function! s:has_trailing_comma(s)
    return a:s =~? '\v,$'
endfunction

function! s:has_else(s)
    return a:s =~ 'else'
endfunction

function! CountDelimiters(line)
    let delimiters = {'(':0,')':0,'[':0,']':0,'{':0,'}':0}
    for i in range(strlen(a:line))
        let ch = a:line[i]
        if has_key(delimiters, ch)
            let delimiters[ch] += 1
        endif
    endfor
    return delimiters
endfunction

" ==== indent_from_string ============================================

call Testthat('indent_from_string works',
    \ s:indent_from_string('', 2) == 0,
    \ s:indent_from_string('x', 2) == 0,
    \ s:indent_from_string(' x', 2) == 0,
    \ s:indent_from_string('  x', 2) == 1,
    \ s:indent_from_string('   x', 2) == 1,
    \ s:indent_from_string('    x', 2) == 2,
    \ s:indent_from_string('     x', 2) == 2)

" ==== relative_indent ===============================================

call Testthat('Indent more if prev line has surplus of open delimiters.',
    \ s:relative_indent('(x,', 'y') == +1,
    \ s:relative_indent('{', 'y') == +1,
    \ s:relative_indent('f(g(x),', 'y') == +1)

call Testthat('Indent more if prev contains a control flow keyword followed by a simple expression.',
    \ s:relative_indent('if (x)', 'y') == +1,
    \ s:relative_indent('else', 'y') == +1,
    \ s:relative_indent('for (x)', 'y') == +1,
    \ s:relative_indent('while (x)', 'y') == +1,
    \ s:relative_indent('repeat', 'y') == +1)

call Testthat('Indent less if prev line has surplus of closed delimiters.',
    \ s:relative_indent('x)', 'y') == -1,
    \ s:relative_indent("x) {", 'y') == -1)

call Testthat('Use same indent if prev line ends in comma.',
    \ s:relative_indent('x),', 'y') == 0)

call Testthat('Indent less if this line ends in closing delimiter.',
    \ s:relative_indent('f()', '}') == -1,
    \ s:relative_indent('f()', ')') == -1)

call Testthat('Use same indent if prev line ends in an opening and this line in the matching closing delimiter.',
    \ s:relative_indent('(', ')') == 0,
    \ s:relative_indent('[', ']') == 0,
    \ s:relative_indent('{', '}') == 0)

call Testthat('Use same indent if prev line is a complete expressions in itself.',
    \ s:relative_indent('x', 'y') == 0,
    \ s:relative_indent('f()', 'y') == 0)

call Testthat('Indent less if this line starts with "else".',
    \ s:relative_indent('x', 'else') == -1,
    \ s:relative_indent('x', 'else {') == -1,
    \ s:relative_indent('x', '} else') == -1,
    \ s:relative_indent('x', '} else {') == -1)

" ==== has_net_surplus_of_open_delimiters ============================

call Testthat('all lines have open delimiters',
    \ s:has_net_surplus_of_open_delimiters('('),
    \ s:has_net_surplus_of_open_delimiters('), foo('),
    \ s:has_net_surplus_of_open_delimiters(') {'))

call Testthat('no lines have open delimiters',
    \ ! s:has_net_surplus_of_open_delimiters('foo()'))

" ==== has_net_surplus_of_closed_delimiters ==========================

call Testthat('all lines have closed delimiters',
    \ s:has_net_surplus_of_closed_delimiters(')'),
    \ s:has_net_surplus_of_closed_delimiters('), foo('),
    \ s:has_net_surplus_of_closed_delimiters('), foo(), bar('),
    \ s:has_net_surplus_of_closed_delimiters(') {'))

call Testthat('no lines have closed delimiters',
    \ ! s:has_net_surplus_of_closed_delimiters('foo()'),
    \ ! s:has_net_surplus_of_closed_delimiters('foo() ('))

" ==== CountDelimiters ===============================================

call Testthat('CountDelimiters works',
    \ CountDelimiters('')['('] == 0,
    \ CountDelimiters('(')['('] == 1,
    \ CountDelimiters('((')['('] == 2)

" ==== has_control_flow_with_simple_expression =======================

call Testthat('all have control flow keyword followed by simple expression',
    \ s:has_control_flow_with_simple_expression('if (x)', 'y'),
    \ s:has_control_flow_with_simple_expression('else', 'y'),
    \ s:has_control_flow_with_simple_expression('for (x)', 'y'),
    \ s:has_control_flow_with_simple_expression('while (x)', 'y'),
    \ s:has_control_flow_with_simple_expression('repeat', 'y'))

call Testthat('none have control flow keyword followed by simple expression',
    \ ! s:has_control_flow_with_simple_expression('if (x) {', 'y'),
    \ ! s:has_control_flow_with_simple_expression('if (x)', '{'),
    \ ! s:has_control_flow_with_simple_expression('else {', 'y'),
    \ ! s:has_control_flow_with_simple_expression('else', '{'),
    \ ! s:has_control_flow_with_simple_expression('for (x) {', 'y'),
    \ ! s:has_control_flow_with_simple_expression('for (x)', '{'),
    \ ! s:has_control_flow_with_simple_expression('while (x) {', 'y'),
    \ ! s:has_control_flow_with_simple_expression('while (x)', '{'),
    \ ! s:has_control_flow_with_simple_expression('repeat {', 'y'),
    \ ! s:has_control_flow_with_simple_expression('repeat', '{'))

" ==== has_trailing_comma ============================================

call Testthat('has_trailing_comma works',
    \ s:has_trailing_comma(','),
    \ s:has_trailing_comma('x),'))

" ==== has_else ======================================================

call Testthat('has_else works',
    \ s:has_else('else'),
    \ s:has_else('} else'),
    \ s:has_else('else {'),
    \ s:has_else('} else {'))
