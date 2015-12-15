" COLORS:
"
" white         15  #ffffff
" black          0  #000000
" light gray     7  #c0c0c0
" gray           8  #808080
" dark gray    234  #1c1c1c

" {{{ Boilerplate
set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'grayscale'
" }}}
" {{{ General groups
hi ColorColumn      ctermfg=0  guifg=#000000 ctermbg=15  guibg=#ffffff cterm=none gui=none term=none
hi Conceal          ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi Cursor           ctermfg=0  guifg=#000000 ctermbg=15  guibg=#ffffff cterm=none gui=none term=none
hi CursorIM         ctermfg=0  guifg=#000000 ctermbg=15  guibg=#ffffff cterm=none gui=none term=none
hi CursorColumn     ctermfg=0  guifg=#000000 ctermbg=15  guibg=#ffffff cterm=none gui=none term=none
hi CursorLine       ctermfg=0  guifg=#000000 ctermbg=15  guibg=#ffffff cterm=none gui=none term=none
hi Directory        ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi DiffAdd          ctermfg=0  guifg=#000000 ctermbg=15  guibg=#ffffff cterm=none gui=none term=none
hi DiffChange       ctermfg=8  guifg=#808080 ctermbg=234 guibg=#1c1c1c cterm=none gui=none term=none
hi DiffText         ctermfg=15 guifg=#c0c0c0 ctermbg=234 guibg=#1c1c1c cterm=none gui=none term=none
hi DiffDelete       ctermfg=0  guifg=#000000 ctermbg=0   guibg=#ffffff cterm=none gui=none term=none
hi ErrorMsg         ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi VertSplit        ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi Folded           ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi FoldColumn       ctermfg=7  guifg=#c0c0c0 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi SignColumn       ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi IncSearch        ctermfg=0  guifg=#000000 ctermbg=7   guibg=#808080 cterm=none gui=none term=none
hi LineNr           ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi CursorLineNr     ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi MatchParen       ctermfg=0  guifg=#000000 ctermbg=7   guibg=#808080 cterm=none gui=none term=none
hi ModeMsg          ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi MoreMsg          ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi NonText          ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi Normal           ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi Pmenu            ctermfg=15 guifg=#ffffff ctermbg=8   guibg=#808080 cterm=none gui=none term=none
hi PmenuSel         ctermfg=8  guifg=#808080 ctermbg=15  guibg=#ffffff cterm=none gui=none term=none
hi PmenuSbar        ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi PmenuThumb       ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi Question         ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi Search           ctermfg=0  guifg=#000000 ctermbg=7   guibg=#808080 cterm=none gui=none term=none
hi SpecialKey       ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi SpellBad         ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi SpellCap         ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi SpellLocal       ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi SpellRare        ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi StatusLine       ctermfg=15 guifg=#ffffff ctermbg=8   guibg=#808080 cterm=none gui=none term=none
hi StatusLineNC     ctermfg=15 guifg=#ffffff ctermbg=8   guibg=#808080 cterm=none gui=none term=none
hi TabLine          ctermfg=0  guifg=#000000 ctermbg=8   guibg=#808080 cterm=none gui=none term=none
hi TabLineFill      ctermfg=15 guifg=#ffffff ctermbg=8   guibg=#808080 cterm=none gui=none term=none
hi TabLineSel       ctermfg=15 guifg=#ffffff ctermbg=8   guibg=#808080 cterm=none gui=none term=none
hi Title            ctermfg=0  guifg=#000000 ctermbg=8   guibg=#808080 cterm=none gui=none term=none
hi Visual           ctermfg=15 guifg=#ffffff ctermbg=8   guibg=#808080 cterm=none gui=none term=none
hi VisualNOS        ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi WarningMsg       ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi WildMenu         ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" }}}
" {{{ Syntax groups
hi Comment          ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none

hi Constant         ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi String           ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Character      ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Number         ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Boolean        ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Float          ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none

hi Identifier       ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Function       ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none

hi Statement        ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Conditional    ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Repeat         ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Label          ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Operator       ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Keyword        ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Exception      ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none

hi PreProc          ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Include        ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Define         ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Macro          ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi PreCondit      ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none

hi Type             ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi StorageClass   ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Structure      ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" hi Typedef        ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none

hi Special          ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi Special          ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi SpecialChar      ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi Tag              ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi Delimiter        ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi SpecialComment   ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi Debug            ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none

hi Underlined       ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=underline gui=underline term=none
hi Ignore           ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi Error            ctermfg=0  guifg=#000000 ctermbg=15  guibg=#ffffff cterm=none gui=none term=none
hi Todo             ctermfg=0  guifg=#000000 ctermbg=15  guibg=#ffffff cterm=none gui=none term=none

hi helpHyperTextJump ctermfg=8 guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi helpBar          ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi helpStar         ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi helpIgnore       ctermfg=0  guifg=#000000 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi helpNote         ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none

hi vimParenSep      ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi vimOption        ctermfg=15 guifg=#ffffff ctermbg=0   guibg=#000000 cterm=none gui=none term=none
hi vimString        ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none

hi perlString       ctermfg=8  guifg=#808080 ctermbg=0   guibg=#000000 cterm=none gui=none term=none
" }}}
