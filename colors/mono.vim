" :h highlight-groups
" :nnoremap -cs :so $VIMRUNTIME/syntax/hitest.vim<cr>
" :nnoremap ss :w<cr>:so %<cr>
set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'mono'

" Basic highlighting groups
hi Normal     ctermfg=LightGray ctermbg=Black     guifg=LightGray guibg=Black
hi Underlined ctermfg=LightGray ctermbg=Black     guifg=LightGray guibg=Black     term=underline cterm=underline gui=underline
hi Visual     ctermfg=Black     ctermbg=LightGray guifg=Black     guibg=LightGray
hi IncSearch  ctermfg=Magenta   ctermbg=Black     guifg=Magenta   guibg=Black
hi Search     ctermfg=Magenta   ctermbg=Black     guifg=Magenta   guibg=Black

" EasyMotion
hi EasyMotionTarget ctermfg=Green    ctermbg=NONE guifg=Green    guibg=NONE
hi EasyMotionShade  ctermfg=DarkGray ctermbg=NONE guifg=DarkGray guibg=NONE

" Diff
hi DiffAdded   ctermfg=Green ctermbg=Black guifg=Green guibg=Black
hi DiffRemoved ctermfg=Red   ctermbg=Black guifg=Red   guibg=Black

hi! link Comment     Normal
hi! link Constant    Normal
hi! link DiffChange  Normal
hi! link DiffText    Visual
hi! link Directory   Normal
hi! link Error       Visual
hi! link ErrorMsg    Visual
hi! link helpHyperTextJump Search
hi! link Identifier  Normal
hi! link MatchParen  Normal
hi! link MoreMsg     Normal
hi! link NonText     Normal
hi! link Pmenu       Visual
hi! link PmenuSel    Search
hi! link PreProc     Normal
hi! link Special     Normal
hi! link SpecialKey  Normal
hi! link Statement   Normal
hi! link StatusLine  Visual
hi! link TabLine     Underlined
hi! link TabLineFill Normal
hi! link TabLineSel  Visual
hi! link Title       Normal
hi! link Todo        Search
hi! link Type        Normal
hi! link VertSplit   Normal
hi! link WarningMsg  Normal
