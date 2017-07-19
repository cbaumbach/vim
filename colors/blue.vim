if &t_Co < 256 && !has("gui_running")
    echomsg "Error: color scheme requires a terminal with at least 256 colors"
    finish
endif

set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'blue'

hi Comment ctermfg=012 guifg=#0087ff ctermbg=000 guibg=#000000 cterm=none gui=none
hi Normal  ctermfg=014 guifg=#00dfff ctermbg=000 guibg=#000000 cterm=none gui=none
hi Search  ctermfg=013 guifg=#ff00ff ctermbg=000 guibg=#000000 cterm=none gui=none
hi String  ctermfg=082 guifg=#5fff00 ctermbg=000 guibg=#000000 cterm=none gui=none
hi Visual  ctermfg=015 guifg=#ffffff ctermbg=025 guibg=#005faf cterm=none gui=none
hi Window  ctermfg=013 guifg=#ff00ff ctermbg=000 guibg=#000000 cterm=none gui=none

" EasyMotion
hi EasyMotionShade  ctermfg=008 guifg=#808080
hi EasyMotionTarget ctermfg=082 guifg=#5fff00
hi EasyMotionTarget2First ctermfg=082 guifg=#5fff00
hi EasyMotionTarget2Second ctermfg=082 guifg=#5fff00

" Disable bold font
hi ModeMsg cterm=none gui=none
hi MoreMsg cterm=none gui=none

" Git commit diff
hi DiffAdded   ctermfg=010 guifg=#00ff00 ctermbg=000 guibg=#000000
hi DiffRemoved ctermfg=009 guifg=#ff0000 ctermbg=000 guibg=#000000

runtime colors/common/link_other_groups.vim
