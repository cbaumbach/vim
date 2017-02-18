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
set printoptions=formfeed:y
set shortmess+=I
let &showbreak = '> '
set showmatch
set sidescroll=1
set smartcase
let &softtabstop = g:preferred_tab_width
let &shiftwidth = g:preferred_tab_width
runtime utils/statusline.vim
runtime utils/tabline.vim
let &tabstop = g:preferred_tab_width
set textwidth=70
set nowrap
" }}}
" {{{ Mappings
let mapleader = '-'
let localmapleader = '\'

" {{{ Emulate emacs' ace-jump-mode with EasyMotion
" Don't install default mappings.
let g:EasyMotion_do_mapping = 0
" Ignore case when matching query character.
let g:EasyMotion_smartcase = 1
" Enlarge set of target characters.  Use ; for grouping.
let g:EasyMotion_keys = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ;'
" Don't report jump summary.
let g:EasyMotion_verbose = 0
" Don't prompt for target character.
let g:EasyMotion_show_prompt = 0
" Set query character prompt.
let g:EasyMotion_prompt = 'Query Char: '
" Trigger by c-c c-space (nul represents c-space).
nmap <c-c><nul> <plug>(easymotion-s)
" }}}
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
" {{{ Show highlighting groups for word under cursor.
nnoremap <leader>= :call <SID>Show_highlighting_group()<cr>
function! <SID>Show_highlighting_group()
    if !exists('*synstack')
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction
" }}}
" {{{ Show colors for all highlight groups.
nnoremap <leader>cs :source $VIMRUNTIME/syntax/hitest.vim<cr>
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

function! Update_statusline()
    " No-op: set variable to its current value
    let &readonly = &readonly
endfunction

" Toggle modifiable and read-only flags.
nnoremap <silent> <leader>M :setlocal modifiable!<cr>:call Update_statusline()<cr>
nnoremap <silent> <leader>R :setlocal readonly!<cr>:call Update_statusline()<cr>

" Trigger reloading of filetype-specific files.
nnoremap rr :let &l:filetype = &l:filetype<cr>

" Toggle paste mode.
nnoremap <f9> :set paste<cr>i
inoremap <f9> <c-o>:set paste<cr>
set pastetoggle=<f9>

" Remove highlighting.
nnoremap <silent> <leader>a :nohlsearch<cr>

" Open up help in new tab.
nnoremap <leader>h :tab help<space>

" Follow tag in new tab.
nnoremap <silent> <c-t> <c-w><c-]><c-w>T<cr>

" Change to directory of current file.
nnoremap <leader>. :lcd %:p:h<cr>

" Select buffer from list.
nnoremap <leader>b :ls<cr>:b<space>
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
        autocmd FileType vim setlocal foldmethod=marker foldlevel=0
        " Source current vim script.
        autocmd FileType vim nnoremap <buffer> ss :write<cr>:source %<cr>
    augroup END

    augroup filetype_c
        autocmd!
        autocmd FileType c,cpp setlocal comments=sr:/*,mb:\ ,e:*/,://,fb:-,fb:+
        autocmd FileType c,cpp setlocal formatoptions-=t
        autocmd FileType c,cpp setlocal autowrite
    augroup END

endif
" }}}
