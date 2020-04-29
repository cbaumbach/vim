" ==== BOILERPLATE ===================================================
set nocompatible
if has('syntax')
    syntax on
endif
filetype plugin indent on
if &t_Co >= 256 || has('gui_running')
    if localtime() % 2 == 0
        colorscheme blue
    else
        colorscheme green
    endif
else
    colorscheme elflord
endif
execute pathogen#infect()
runtime macros/matchit.vim
runtime utils/testing.vim

" ==== SETTINGS ======================================================
set autoindent
set encoding=utf-8
" Recognize Unity format (http://www.throwtheswitch.org/unity)
let &errorformat = '%*[.]%f:%l:%*[^:]:%*[^:]:%m,' . &errorformat
set expandtab
set formatoptions=cjloqr
set grepformat=%f:%l:%c:%m
set grepprg=ack\ --nogroup\ --column\ $*
set hidden
set history=200
set hlsearch
nohlsearch  " turn off highlighting turned on by 'set hlsearch'
set ignorecase
set incsearch
runtime! ftplugin/man.vim
set keywordprg=:Man
set laststatus=2
set list
set listchars=conceal:\ ,tab:»\ ,trail:·
set matchtime=5
set pastetoggle=<f9>
set shiftwidth=4
set shortmess+=I
set showmatch
set sidescroll=1
set smartcase
set softtabstop=4
set nostartofline
runtime utils/statusline.vim
runtime utils/tabline.vim
set tabstop=4
set textwidth=70
set tildeop
set notimeout
set ttimeout
set nowrap

" ---- EASYMOTION ----------------------------------------------------
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
let s:alphabet = 'abcdefghijklmnopqrstuvwxyz'
let s:grouping_character = ';'
let g:EasyMotion_keys = s:alphabet . toupper(s:alphabet) . s:grouping_character
let g:EasyMotion_verbose = 0
let g:EasyMotion_show_prompt = 0
let g:EasyMotion_prompt = 'Query Char: '

" ---- MISCELLANEOUS -------------------------------------------------
let g:remove_trailing_whitespace = 1

" ==== FUNCTIONS =====================================================

" Unlike %, ensures that 0 <= Mod(k, n) < n even if k < 0.
function! Mod(k, n)
    return ((a:k % a:n) + a:n) % a:n
endfunction

" Unlike :next/:previous, which will get stuck when they reach the
" last/first file in the argument list, CycleArgs will wrap around.
function! CycleArgs(offset)
    if a:offset == 0 || argc() < 1
        return
    endif
    execute 'argument ' . (Mod(argidx() + a:offset, argc()) + 1)
endfunction

function! ToggleAutoWrap()
    let fo = &l:formatoptions
    if fo =~ 't'
        let &l:formatoptions = substitute(fo, 't', '', 'g')
        echo 'auto-wrap off'
    else
        let &l:formatoptions .= 't'
        echo 'auto-wrap on'
    endif
endfunction

function! ToggleModifiable()
    let &l:modifiable = ! &l:modifiable
    if &l:modifiable && ! &write
        let &write = 1
    endif
    call UpdateStatusLine()
endfunction

function! ToggleReadonly()
    let &l:readonly = ! &l:readonly
    call UpdateStatusLine()
endfunction

function! UpdateStatusLine()
    " Set global option to force statusline update
    let &readonly = &readonly  " no-op
endfunction

function! Trim(s)
    return substitute(substitute(a:s, '^\s*', '', ''), '\s*$', '', '')
endfunction

function! InsertFilename()
    let path = Trim(input('File: ', '', 'file'))
    if path == '' | echo | return | endif
    let old_contents = getreg('')
    call setreg('', path)
    normal p
    call setreg('', old_contents)
    if CursorAtEndOfLine()
        startinsert!
    else
        normal l
        startinsert
    endif
endfunction

function! CursorAtEndOfLine()
    return col('.') == col('$') - 1
endfunction

function! SetSearchPatternToVisualSelection(cmdtype)
    let temp = @"
    normal! gvy
    let @/ = '\V' . substitute(escape(@", a:cmdtype . '\'), '\n', '\\n', 'g')
    let @" = temp
endfunction

function! ToggleGermanPostfix()
    if !exists("b:german_postfix")
        let b:german_postfix = 0
    endif
    if b:german_postfix
        iunmap <buffer> ae
        iunmap <buffer> oe
        iunmap <buffer> ue
        iunmap <buffer> AE
        iunmap <buffer> OE
        iunmap <buffer> UE
        iunmap <buffer> sz
        let &l:timeout = 0
        let b:german_postfix = 0
    else
        inoremap <buffer> ae <c-k>a:
        inoremap <buffer> oe <c-k>o:
        inoremap <buffer> ue <c-k>u:
        inoremap <buffer> AE <c-k>A:
        inoremap <buffer> OE <c-k>O:
        inoremap <buffer> UE <c-k>U:
        inoremap <buffer> sz <c-k>ss
        let &l:timeout = 1
        let b:german_postfix = 1
    endif
endfunction

function! WipeoutBuffer()
    let alternate_file = bufnr('#')
    bprevious
    bwipeout #
    if alternate_file != -1
        execute 'buffer' alternate_file
    endif
endfunction

function! RemoveWhitespaceAtEndOfLine()
    if !&binary
        let old_cursor_position = getpos(".")
        silent! %s/\s\+$//ge
        call setpos(".", old_cursor_position)
    endif
endfunction

function! RemoveEmptyLinesAtEndOfFile()
    if !&binary
        let old_cursor_position = getpos(".")
        silent! v/\_s*\S/d
        call setpos(".", old_cursor_position)
    endif
endfunction

function! RemoveTrailingWhitespace()
    if !exists('b:remove_trailing_whitespace')
        let b:remove_trailing_whitespace = g:remove_trailing_whitespace
    endif
    if !&binary && b:remove_trailing_whitespace
        call RemoveWhitespaceAtEndOfLine()
        call RemoveEmptyLinesAtEndOfFile()
    endif
endfunction

function! ToggleRemoveTrailingWhitespace()
    if !exists('b:remove_trailing_whitespace')
        let b:remove_trailing_whitespace = g:remove_trailing_whitespace
    endif
    if b:remove_trailing_whitespace
        let b:remove_trailing_whitespace = 0
        echo 'keep trailing whitespace'
    else
        let b:remove_trailing_whitespace = 1
        echo 'no trailing whitespace'
    endif
endfunction

function! ShowHighlightingGroup()
    if !exists('*synstack')
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunction

" ==== MAPPINGS ======================================================
let mapleader = '-'

" ---- USED ALL THE TIME ---------------------------------------------
inoremap jk <esc>
nnoremap <silent> <c-l> :nohlsearch<cr><c-l>
inoremap <c-u> <esc>vb~gi
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h') . '/' : '%%'
cnoremap <c-p> <up>
cnoremap <c-n> <down>
cnoremap <c-b> <left>
cnoremap <c-f> <right>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
nnoremap <silent> <c-n> :bnext<cr>
" <nul> = C-Space
nnoremap <silent> <nul> :call CycleArgs(1)<cr>

" ---- FREQUENTLY ----------------------------------------------------
nnoremap ` '
nnoremap ' `
onoremap ` '
onoremap ' `
inoremap <c-f> <esc>:call InsertFilename()<cr>
nnoremap <leader>l :call ToggleAutoWrap()<cr>
nnoremap <leader><space> :call ToggleRemoveTrailingWhitespace()<cr>
nnoremap <silent> <leader>M :call ToggleModifiable()<cr>
nnoremap <silent> <leader>R :call ToggleReadonly()<cr>
nnoremap <silent> <c-x>k :call WipeoutBuffer()<cr>
" Trigger EasyMotion with C-c C-Space
nmap <c-c><nul> <plug>(easymotion-s)

" ---- SOMETIMES -----------------------------------------------------
nnoremap <leader>b :ls<cr>:buffer<space>
nnoremap <silent> <leader>. :lcd %:p:h<cr>
nnoremap <silent> <c-\> :call ToggleGermanPostfix()<cr>
inoremap <silent> <c-\> <c-o>:call ToggleGermanPostfix()<cr>
xnoremap * :<c-u>call SetSearchPatternToVisualSelection('/')<cr>/<c-r>=@/<cr><cr>
xnoremap # :<c-u>call SetSearchPatternToVisualSelection('?')<cr>?<c-r>=@/<cr><cr>
nnoremap <leader>h :tab help<space>
nnoremap & :&&<cr>
xnoremap & :&&<cr>

" ---- ALMOST NEVER --------------------------------------------------
nnoremap <silent> <leader>r :let &l:filetype = &l:filetype<cr>
nnoremap <silent> <leader>t <c-w><c-]><c-w>T<cr>
nnoremap <leader>cs :source $VIMRUNTIME/syntax/hitest.vim<cr>
nnoremap <leader>= :call ShowHighlightingGroup()<cr>

" ==== COMMANDS ======================================================
command! WW w !sudo tee % >/dev/null
command! Tags !ctags -R --exclude=.git --exclude=venv

" ==== AUTOCOMMANDS ==================================================
if has('autocmd')

    augroup general
        autocmd!
        autocmd BufWritePre * call RemoveTrailingWhitespace()
    augroup END

    augroup filetype_vim
        autocmd!
        autocmd FileType vim nnoremap <silent> <buffer> <leader>ss :write<cr>:source %<cr>
    augroup END

    augroup filetype_c
        autocmd!
        autocmd FileType c,cpp setlocal comments=sr:/*,mb:\ ,e:*/,://,fb:-,fb:+
        autocmd FileType c,cpp setlocal commentstring=//\ %s
        autocmd FileType c,cpp setlocal nocindent
        autocmd FileType c,cpp setlocal autowrite
    augroup END

    augroup filetype_sql
        autocmd!
        autocmd FileType sql setlocal commentstring=--\ %s
    augroup END

    augroup filetype_man
        autocmd!
        autocmd FileType man,help setlocal nolist
    augroup END

endif
