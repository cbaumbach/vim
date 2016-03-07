" Define custom tabline.

function! CustomTabLine()
    let labels = s:compute_labels()
    let this_tab = tabpagenr() - 1
    let tabline = ''
    for tab in range(len(labels))
        let tabline .= (tab == this_tab) ? '%#TabLineSel#' : '%#TabLine#'
        let tabline .= ' ' . labels[tab] . ' '
    endfor
    let tabline .= '%#TabLineFill#%T'
    return tabline
endfunction

function! s:compute_labels()
    let number_of_tabs = tabpagenr('$')
    let natural_labels = Map(function("s:tab_label"), range(1, number_of_tabs))
    let natural_width = Map(function("strlen"), natural_labels)
    let width_taken_by_surrounding_spaces = number_of_tabs * 2
    let net_available_width = &columns - width_taken_by_surrounding_spaces
    if Sum(natural_width) <= net_available_width
        return natural_labels
    endif
    let adjusted_width = s:adjust_width(natural_width, net_available_width)
    let adjusted_labels = s:adjust_labels(natural_labels, adjusted_width)
    return adjusted_labels
endfunction

function! Map(fn, list)
    let new_list = deepcopy(a:list)
    call map(new_list, string(a:fn) . '(v:val)')
    return new_list
endfunction

function! s:tab_label(tab)
    let buffer_name = bufname(tabpagebuflist(a:tab)[tabpagewinnr(a:tab) - 1])
    if buffer_name == ''
        let buffer_name = '[No Name]'
    endif
    return buffer_name
endfunction

function! Sum(list)
    let sum = 0
    for x in a:list
        let sum += x
    endfor
    return sum
endfunction

function! s:adjust_width(natural_width, available_width)
    let number_of_tabs = len(a:natural_width)
    let width = []
    for tab in range(number_of_tabs)
        call add(width, 0)
    endfor
    let tab = 0
    let amount = a:available_width
    while amount > 0
        if width[tab] < a:natural_width[tab]
            let width[tab] += 1
            let amount -= 1
        endif
        let tab = (tab + 1) % number_of_tabs
    endwhile
    return width
endfunction

function! s:adjust_labels(natural_labels, width)
    let labels = []
    for i in range(len(a:width))
        let start_position = strlen(a:natural_labels[i]) - a:width[i]
        call add(labels, strpart(a:natural_labels[i], start_position, a:width[i]))
    endfor
    return labels
endfunction

set tabline=%!CustomTabLine()
