" {{{ Boilerplate
set nocompatible  " reset early to avoid side-effects
if has('syntax')
    syntax on  " start with default color settings
endif
filetype plugin indent on
colorscheme grayscale
execute pathogen#infect()
" }}}
" {{{ Integration with tmux
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
" }}}
" {{{ Options
let g:preferred_tab_width = 4

set autoindent
set backspace=indent,eol,start
set cmdwinheight=1  " see also help for cmdwin
set directory=$HOME/tmp//
set encoding=utf-8
set expandtab
set fillchars=stl:\ ,stlnc:-,vert:\|,fold:-,diff:-
set foldlevelstart=0
set formatoptions=roqlct
set hidden
set hlsearch
nohlsearch  " turn off highlighting turned on by 'set hlsearch'
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=conceal:\ ,tab:»\ ,trail:·
set printoptions=formfeed:y
set shortmess+=I
set showbreak=…
set sidescroll=1
set smartcase
let &softtabstop = g:preferred_tab_width
let &shiftwidth = g:preferred_tab_width
set spelllang=en_us
set splitbelow
set splitright
set switchbuf=usetab,newtab
let &tabstop = g:preferred_tab_width
set textwidth=70
set nowrap
" }}}
" {{{ Mappings
let mapleader = '-'
let localmapleader = '\'

" {{{ Toggle auto-wrapping.
nnoremap <leader>l :call Toggle_auto_wrapping()<cr>
function! Toggle_auto_wrapping()
    let fo = &l:formatoptions
    try
        echohl ModeMsg
        if fo =~ '[ct]'
            let &l:formatoptions = substitute(fo, '[ct]', '', 'g')
            echo 'auto-wrapping off'
        else
            let &l:formatoptions .= 'ct'
            echo 'auto-wrapping on'
        endif
    finally
        echohl None
    endtry
endfunction
" }}}
" {{{ Unify tab settings.
command! -nargs=* SetTabs call Set_tabs()
function! Set_tabs()
    let ts = 1 * input('set tabstop = softtabstop = shiftwidth = ')
    if ts > 0
        let &l:tabstop     = ts
        let &l:softtabstop = ts
        let &l:shiftwidth  = ts
    endif
    redraw                     " clear echo area
    call Summarize_tabs()
endfunction

function! Summarize_tabs()
    try
        echohl ModeMsg
        echon 'tabstop='     . &l:tabstop     . ' '
        echon 'softtabstop=' . &l:softtabstop . ' '
        echon 'shiftwidth='  . &l:shiftwidth  . ' '
        if !&l:expandtab | echon 'no' | endif
        echon 'expandtab'
    finally
        echohl None
    endtry
endfunction
" }}}
" {{{ Show highlighting groups for word under cursor.
nnoremap <leader>= :call <SID>Show_highlighting_group()<cr>
function! <SID>Show_highlighting_group()
    if !exists('*synstack')
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction
" }}}
" {{{ Close current window/tab (in that order).
nnoremap <silent> <c-w>c :call Close_it()<cr>
function! Close_it()
    if tabpagenr('$') == 1 | q | else | tabclose | endif
endfunction
" }}}
" {{{ Produce landscape printout.
command! -nargs=* LandscapeHardcopy call Landscape_hardcopy()
function! Landscape_hardcopy()
    execute 'set printoptions=portrait:n | hardcopy | set printoptions=portrait:y<cr>'
endfunction
" }}}
" {{{ Remove trailing whitespace
function! Remove_trailing_whitespace()
    if !&binary
        let old_cursor_position = getpos(".")
        silent! %s/\s\+$//ge
        call setpos(".", old_cursor_position)
        " normal! ``
    endif
endfunction
" }}}
" {{{ Remove empty lines at the end of the file
function! Remove_empty_lines_at_end_of_file()
    if !&binary
        let old_cursor_position = getpos(".")
        silent! v/\_s*\S/d
        call setpos(".", old_cursor_position)
    endif
endfunction
" }}}

" Alternatives to <esc> for getting back into normal mode:
" <c-[> or <c-c> or jk.
inoremap jk <esc>

" Disable arrow keys.
noremap  <left>  <nop>
noremap  <right> <nop>
noremap  <up>    <nop>
noremap  <down>  <nop>
noremap! <left>  <nop>
noremap! <right> <nop>
noremap! <up>    <nop>
noremap! <down>  <nop>

" Edit configuration file in new tab.
nnoremap <leader>ee :tabedit $MYVIMRC<cr>
" Source configuration file.
nnoremap <leader>ss :source $MYVIMRC<cr>

" Toggle paste mode.
nnoremap <silent> <localleader>p :set paste<cr>i
inoremap <localleader>p <c-o>:set paste<cr>
set pastetoggle=<localleader>p

" Remove highlighting.
nnoremap <silent> <leader>a :nohlsearch<cr>

" Open up help in new tab.
nnoremap <leader>h :tab help |" this comment protects a trailing space

" Add an extra space between any two characters.
nnoremap <leader><space> !!perl -pe 's/(.)/\1 /g; s/  *$//'<cr>

" Follow tag in new tab.
nnoremap <silent> <c-t> <c-w><c-]><c-w>T<cr>

" Toggle list mode.
nnoremap <leader>L :setlocal list!<cr>

" Change to directory of current file.
nnoremap <leader>cd :lcd %:p:h<cr>:pwd<cr>

" Display tabular data in a readable way.
command! -nargs=* PrettyTable .,$!column -t -s'<tab>'
" }}}
" {{{ Autocommands
if has('autocmd')

    augroup general
        autocmd!
        autocmd BufWritePre * call Remove_trailing_whitespace()
        autocmd BufWritePre * call Remove_empty_lines_at_end_of_file()
    augroup END

    augroup filetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker
    augroup END

    augroup filetype_c
        autocmd!
        autocmd FileType c,cpp setlocal comments=sr:/*,mb:\ ,e:*/,://,fb:-,fb:+
        autocmd FileType c,cpp setlocal formatoptions-=t
        autocmd FileType c,cpp setlocal foldmethod=syntax
    augroup END

endif
" }}}
