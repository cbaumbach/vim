" {{{ Boilerplate
set nocompatible  " reset early to avoid side-effects
if has('syntax')
    syntax on  " start with default color settings
endif
filetype plugin indent on
colorscheme blue
runtime utils/testing.vim
execute pathogen#infect()
runtime utils/tmux.vim
runtime! ftplugin/man.vim
" }}}
" {{{ Options
let g:preferred_tab_width = 4

set autoindent
set backspace=indent,eol,start
if !isdirectory($HOME . '/tmp')
    call mkdir($HOME . '/tmp')
endif
let &cpoptions = substitute(&cpoptions, '\Ca', '', 'g')
set directory=$HOME/tmp//
set encoding=utf-8
" Prepend a pattern that matches unity failure messages.
let &errorformat = '%*[.]%f:%l:%*[^:]:%*[^:]:%m,' . &errorformat
set expandtab
set fillchars=stl:\ ,stlnc:-,vert:\|,fold:-,diff:-
set foldlevelstart=99  " always start with all folds opened
set formatoptions=troql
set hidden
set hlsearch
nohlsearch  " turn off highlighting turned on by 'set hlsearch'
set ignorecase
set incsearch
set laststatus=2
set list
set listchars=conceal:\ ,tab:»\ ,trail:·
set matchtime=5
let &shiftwidth = g:preferred_tab_width
set shortmess+=I
let &showbreak = '> '
set showmatch
set sidescroll=1
set smartcase
let &softtabstop = g:preferred_tab_width
set nostartofline
runtime utils/statusline.vim
runtime utils/tabline.vim
let &tabstop = g:preferred_tab_width
set textwidth=70
set nowrap
" }}}
" {{{ Mappings
" {{{ Various mappings
let mapleader = '-'
let localmapleader = '\'

" Alternative to esc, c-[, and c-c.
inoremap jk <esc>

" Show colors for all highlight groups.
nnoremap <leader>cs :source $VIMRUNTIME/syntax/hitest.vim<cr>

" Reload filetype-specific files.
nnoremap <silent> <leader>r :let &l:filetype = &l:filetype<cr>

" Toggle paste mode.
nnoremap <f9> :set paste<cr>i
inoremap <f9> <c-o>:set paste<cr>
set pastetoggle=<f9>

" Remove search highlighting and refresh the screen.
nnoremap <silent> <c-l> :nohlsearch<cr><c-l>

" Follow tag in new tab.
nnoremap <silent> <c-t> <c-w><c-]><c-w>T<cr>

" Change to directory of current file.
nnoremap <leader>. :lcd %:p:h<cr>

" Select buffer from list.
nnoremap <leader>b :ls<cr>:b<space>
" }}}
" {{{ EasyMotion
let g:EasyMotion_do_mapping = 0   " no default mappings
let g:EasyMotion_smartcase = 1    " ignore case of query character
" Define target characters.
let s:alphabet = 'abcdefghijklmnopqrstuvwxyz'
let s:grouping_character = ';'
let g:EasyMotion_keys = s:alphabet . toupper(s:alphabet) . s:grouping_character
let g:EasyMotion_verbose = 0      " no jump summary
let g:EasyMotion_show_prompt = 0  " no target character prompt
let g:EasyMotion_prompt = 'Query Char: '  " query character prompt
" Trigger by c-c c-space (nul represents c-space).
nmap <c-c><nul> <plug>(easymotion-s)
" }}}
" {{{ Auto-wrapping
nnoremap <leader>l :call Toggle_auto_wrapping()<cr>

function! Toggle_auto_wrapping()
    let fo = &l:formatoptions
    if fo =~ '[ct]'
        let &l:formatoptions = substitute(fo, '[ct]', '', 'g')
        echo 'auto-wrap off'
    else
        let &l:formatoptions .= 'ct'
        echo 'auto-wrap on'
    endif
endfunction
" }}}
" {{{ :highlight groups under cursor
nnoremap <leader>= :call <SID>Show_highlighting_group()<cr>

function! <SID>Show_highlighting_group()
    if !exists('*synstack')
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction
" }}}
" {{{ Toggle modifiable and readonly
nnoremap <silent> <leader>M :setlocal modifiable!<cr>:call Update_statusline()<cr>
nnoremap <silent> <leader>R :setlocal readonly!<cr>:call Update_statusline()<cr>

function! Update_statusline()
    let &readonly = &readonly  " no-op
endfunction
" }}}
" {{{ Switch buffer
command! -nargs=1 -complete=customlist,FindMatchingBuffers Buffer :buffer <args>
nnoremap <c-x>b :call Switch_buffer()<cr>

function! Switch_buffer()
    let buffer = input(':buffer ', '', 'customlist,FindMatchingBuffers')
    execute 'buffer ' . buffer
endfunction

function! FindMatchingBuffers(ArgLead, CmdLine, CursorPos)
    let buffers = map(range(1, bufnr('$')), 'bufname(v:val)')
    let pattern = s:trim(a:ArgLead)
    if empty(pattern)
        let matching_buffers = buffers
    else
        let matching_buffers = filter(buffers, 'v:val =~? pattern')
    endif
    let leading_whitespace = matchstr(a:ArgLead, '^\s*')
    return map(matching_buffers, 'leading_whitespace . v:val')
endfunction
" }}}
" {{{ Show help in current window
nnoremap <leader>h :call Help()<cr>

function! Help()
    let topic = s:trim(input(':help ', '', 'help'))
    if empty(topic)
        echo
        return
    endif
    let target_window = winnr()
    let buffers = map(range(1, winnr('$')), 'winbufnr(v:val)')
    let window_settings = []
    for i in range(1, winnr('$'))
        execute i . 'wincmd w'
        call add(window_settings, winsaveview())
    endfor
    try
        execute ':help ' . topic
    catch /:E149/
        echohl ErrorMsg
        echo 'E149: Sorry, no help for ' . topic
        echohl None
        return
    endtry
    let help_buffer = bufnr('%')
    let cursor_line = getpos('.')[1]
    if winnr('$') > len(window_settings)
        " A new window was created.  Close it.
        hide
    elseif winnr() != target_window
        " The help buffer was opened in an existing window but not the
        " one we wanted.  From the documentation of :help we even know
        " that the window contained a help page buffer.
        "
        " Restore the accidentally changed window.
        execute 'buffer ' . buffers[winnr() - 1]
        call winrestview(window_settings[winnr() - 1])
    endif
    execute target_window . 'wincmd w'
    execute 'buffer ' . help_buffer
    execute 'normal! ' . cursor_line . 'G'
    normal! zt
    " Don't use special characters for tabs etc.
    setlocal nolist
endfunction

function! s:trim(s)
    return substitute(substitute(a:s, '^\s*', '', ''), '\s*$', '', '')
endfunction
" }}}
" {{{ Insert filename
inoremap <c-f> <esc>:call Insert_filename()<cr>

function! Insert_filename()
    let path = s:trim(input('File: ', '', 'file'))
    if path == '' | echo | return | endif
    let old_contents = getreg('')
    call setreg('', path)
    normal p
    call setreg('', old_contents)
    call s:normal_a()
endfunction

function! s:normal_a()
    if s:cursor_at_end_of_line()
        startinsert!
    else
        normal l
        startinsert
    endif
endfunction

function! s:cursor_at_end_of_line()
    return col('.') == col('$') - 1
endfunction
" }}}
" {{{ Restore alternate buffer
nnoremap <silent> <c-^> :call Switch_to_alternate_buffer()<cr>

function! Switch_to_alternate_buffer()
    if empty(bufname('#'))
        echohl ErrorMsg
        echo 'E23: No alternate file'
        echohl None
        return
    endif
    let b:window_settings = winsaveview()
    execute 'buffer ' . bufnr('#')
    if exists('b:window_settings')
        call winrestview(b:window_settings)
    endif
    let &l:filetype = &l:filetype
endfunction
" }}}
" }}}
" {{{ Autocommands
" {{{ Trailing whitespace
function! Remove_trailing_whitespace()
    if !&binary
        let old_cursor_position = getpos(".")
        silent! %s/\s\+$//ge
        call setpos(".", old_cursor_position)
    endif
endfunction
" }}}
" {{{ Blank lines at end of file
function! Remove_empty_lines_at_end_of_file()
    if !&binary
        let old_cursor_position = getpos(".")
        silent! v/\_s*\S/d
        call setpos(".", old_cursor_position)
    endif
endfunction
" }}}
if has('autocmd')

    augroup general
        autocmd!
        autocmd BufWritePre * call Remove_trailing_whitespace()
        autocmd BufWritePre * call Remove_empty_lines_at_end_of_file()
    augroup END

    augroup filetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker foldlevel=0
        autocmd FileType vim nnoremap <buffer> ss :write<cr>:source %<cr>
    augroup END

    augroup filetype_c
        autocmd!
        autocmd FileType c,cpp setlocal comments=sr:/*,mb:\ ,e:*/,://,fb:-,fb:+
        autocmd FileType c,cpp setlocal formatoptions-=t
        autocmd FileType c,cpp setlocal autowrite
    augroup END

    augroup filetype_R
        autocmd!
        autocmd FileType R setlocal makeprg=Rscript\ %
        autocmd FileType R nnoremap <buffer> ss :make<cr>
        autocmd FileType R setlocal autowrite
        autocmd FileType R setlocal foldmethod=manual
    augroup END

endif
" }}}
