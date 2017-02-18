if &t_Co != 256
    echomsg "Error: color scheme requires a 256-color terminal"
    finish
endif

set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'blue'

hi Comment ctermfg=012 ctermbg=000 cterm=none
hi Normal  ctermfg=045 ctermbg=000 cterm=none
hi Search  ctermfg=011 ctermbg=000 cterm=none
hi String  ctermfg=082 ctermbg=000 cterm=none
hi Visual  ctermfg=011 ctermbg=025 cterm=none
hi Window  ctermfg=013 ctermbg=000 cterm=none

" EasyMotion
hi EasyMotionShade  ctermfg=008
hi EasyMotionTarget ctermfg=011

" Disable bold font
hi ModeMsg cterm=none
hi MoreMsg cterm=none

runtime colors/common/link_other_groups.vim