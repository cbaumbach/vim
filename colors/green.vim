if &t_Co != 256
    echomsg "Error: color scheme requires a 256-color terminal"
    finish
endif

set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'green'

hi Comment ctermfg=028 ctermbg=000 cterm=none
hi Normal  ctermfg=082 ctermbg=000 cterm=none
hi Search  ctermfg=013 ctermbg=000 cterm=none
hi String  ctermfg=045 ctermbg=000 cterm=none
hi Visual  ctermfg=000 ctermbg=082 cterm=none
hi Window  ctermfg=013 ctermbg=000 cterm=none

" EasyMotion
hi EasyMotionShade  ctermfg=022
hi EasyMotionTarget ctermfg=082

" Disable bold font
hi ModeMsg cterm=none
hi MoreMsg cterm=none

" Git commit diff
hi DiffAdded   ctermfg=045 ctermbg=000
hi DiffRemoved ctermfg=009 ctermbg=000

runtime colors/common/link_other_groups.vim
