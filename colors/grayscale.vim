set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'grayscale'

hi Normal     ctermfg=White    ctermbg=Black    guifg=White    guibg=Black
hi Discreet   ctermfg=DarkGray ctermbg=Black    guifg=DarkGray guibg=Black
hi Contrast   ctermfg=Black    ctermbg=White    guifg=Black    guibg=White
hi IncSearch  ctermfg=Magenta                   guifg=Magenta
hi Inactive   ctermfg=Black    ctermbg=DarkGray guifg=Black    guibg=DarkGray
hi StatusLine ctermfg=Black    ctermbg=White    guifg=Black    guibg=White     cterm=NONE gui=NONE
hi Emphasis ctermfg=White    ctermbg=DarkGray guifg=White    guibg=DarkGray
hi EasyMotionTarget ctermfg=Green     ctermbg=NONE guifg=Green     guibg=NONE
hi EasyMotionShade  ctermfg=DarkGray  ctermbg=NONE guifg=DarkGray  guibg=NONE
hi ModeMsg cterm=NONE gui=NONE
hi MoreMsg cterm=NONE gui=NONE

hi! link Comment     Discreet
hi! link Constant    Normal
hi! link DiffAdd     Contrast
hi! link DiffChange  Contrast
hi! link DiffDelete  Normal
hi! link DiffText    Emphasis
hi! link Error       Contrast
hi! link FoldColumn  Normal
hi! link Folded      Discreet
hi! link Function    Normal
hi! link HelpNote    Contrast
hi! link Identifier  Normal
hi! link LineNr      Discreet
hi! link MatchParen  Discreet
hi! link NonText     Discreet
hi! link PreProc     Discreet
hi! link Search      Contrast
hi! link Special     Normal
hi! link SpecialKey  Discreet
hi! link Statement   Normal
hi! link String      Discreet
hi! link TabLineFill Normal
hi! link TabLine     Inactive
hi! link TabLineSel  Contrast
hi! link Type        Normal
hi! link VimOption   Normal
hi! link Visual      Contrast
