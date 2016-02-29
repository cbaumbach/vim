" {{{ Boilerplate
set nocompatible  " reset early to avoid side-effects
if has('syntax')
    syntax on  " start with default color settings
endif
filetype plugin indent on
colorscheme grayscale
runtime utils/testing.vim
execute pathogen#infect()
runtime utils/tmux.vim
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
set matchtime=5
set printoptions=formfeed:y
set shortmess+=I
let &showbreak = '> '
set showmatch
set sidescroll=1
set smartcase
let &softtabstop = g:preferred_tab_width
let &shiftwidth = g:preferred_tab_width
set spelllang=en_us
set splitbelow
set splitright
set switchbuf=usetab,newtab
runtime utils/tabline.vim
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

" Source current file.
nnoremap ss :source %<cr>

" Trigger reloading of filetype-specific files.
nnoremap rr :let &l:filetype = &l:filetype<cr>

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

" Toggle Error highlighting group.
nnoremap <silent> <leader>e :hi! link Error Normal<cr>
nnoremap <silent> <leader>E :hi! link Error Contrast<cr>

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
