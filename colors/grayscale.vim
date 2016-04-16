set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'grayscale'

hi Normal   ctermfg=White    ctermbg=Black    guifg=White    guibg=Black
hi Discreet ctermfg=DarkGray ctermbg=Black    guifg=DarkGray guibg=Black
hi Contrast ctermfg=Black    ctermbg=White    guifg=Black    guibg=White
hi Inactive ctermfg=Black    ctermbg=DarkGray guifg=Black    guibg=DarkGray
hi Emphasis ctermfg=White    ctermbg=DarkGray guifg=White    guibg=DarkGray
hi EasyMotionTarget ctermfg=Green     ctermbg=none guifg=Green     guibg=none
hi EasyMotionShade  ctermfg=DarkGray  ctermbg=none guifg=DarkGray  guibg=none

runtime colors/link_groups.vim
