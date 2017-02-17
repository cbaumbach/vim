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

" Widely applicable definitions
hi Comment ctermfg=022 ctermbg=000 cterm=none
hi Normal  ctermfg=002 ctermbg=000 cterm=none
hi Search  ctermfg=011 ctermbg=000 cterm=none
hi Visual  ctermfg=011 ctermbg=022 cterm=none

" Special cases
hi StatusLineNC ctermfg=000 ctermbg=022 cterm=none
hi String       ctermfg=049 ctermbg=000 cterm=none
hi TabLine      ctermfg=003 ctermbg=000 cterm=none
hi VertSplit    ctermfg=022 ctermbg=022 cterm=none

" EasyMotion
hi EasyMotionShade  ctermfg=022
hi EasyMotionTarget ctermfg=011

" Disable bold font
hi ModeMsg cterm=none
hi MoreMsg cterm=none

runtime colors/common/link_other_groups.vim
