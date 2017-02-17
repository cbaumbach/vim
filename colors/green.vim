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

hi Normal     ctermfg=002 ctermbg=000 cterm=none
hi Discreet   ctermfg=022 ctermbg=000 cterm=none
hi Contrast   ctermfg=011 ctermbg=022 cterm=none
hi Filled     ctermfg=000 ctermbg=022 cterm=none
hi Inactive   ctermfg=003 ctermbg=000 cterm=none
hi IncSearch  ctermfg=022 ctermbg=011 cterm=none
hi Yellow     ctermfg=011 ctermbg=000 cterm=none
hi Magenta    ctermfg=013 ctermbg=000 cterm=none
hi String     ctermfg=049 ctermbg=000 cterm=none

" Yellow query character on dark green background.
hi EasyMotionTarget ctermfg=011
hi EasyMotionShade  ctermfg=022

" Disable bold font.
hi ModeMsg cterm=none
hi MoreMsg cterm=none

hi! link Comment      Discreet
hi! link Constant     Normal
hi! link DiffAdd      Contrast
hi! link DiffChange   Contrast
hi! link DiffDelete   Normal
hi! link DiffText     Magenta
hi! link Error        Contrast
hi! link ErrorMsg     Magenta
hi! link FoldColumn   Normal
hi! link Folded       Discreet
hi! link Function     Normal
hi! link HelpNote     Contrast
hi! link Identifier   Normal
hi! link LineNr       Discreet
hi! link MatchParen   Yellow
hi! link NonText      Discreet
hi! link PreProc      Normal
hi! link Search       Yellow
hi! link Special      Normal
hi! link SpecialKey   Discreet
hi! link Statement    Normal
hi! link StatusLine   Contrast
hi! link StatusLineNC Filled
hi! link TabLine      Inactive
hi! link TabLineFill  Normal
hi! link TabLineSel   Contrast
hi! link Type         Normal
hi! link VertSplit    Filled
hi! link VimOption    Normal
hi! link Visual       Contrast
hi! link WarningMsg   Magenta
