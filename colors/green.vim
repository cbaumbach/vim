if &t_Co < 256 && !has("gui_running")
    echomsg "Error: color scheme requires a terminal with at least 256 colors"
    finish
endif

set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'green'

hi Comment ctermfg=028 guifg=#008700 ctermbg=000 guibg=#000000 cterm=none gui=none
hi Normal  ctermfg=082 guifg=#5fff00 ctermbg=000 guibg=#000000 cterm=none gui=none
hi Search  ctermfg=013 guifg=#ff00ff ctermbg=000 guibg=#000000 cterm=none gui=none
hi String  ctermfg=045 guifg=#00dfff ctermbg=000 guibg=#000000 cterm=none gui=none
hi Visual  ctermfg=000 guifg=#000000 ctermbg=082 guibg=#5fff00 cterm=none gui=none
hi Window  ctermfg=013 guifg=#ff00ff ctermbg=000 guibg=#000000 cterm=none gui=none

" EasyMotion
hi EasyMotionShade  ctermfg=022 guifg=#005f00
hi EasyMotionTarget ctermfg=082 guifg=#5fff00
hi EasyMotionTarget2First ctermfg=082 guifg=#5fff00
hi EasyMotionTarget2Second ctermfg=082 guifg=#5fff00

" Disable bold font
hi ModeMsg cterm=none gui=none
hi MoreMsg cterm=none gui=none

" Git commit diff
hi DiffAdded   ctermfg=045 guifg=#00dfff ctermbg=000 guibg=#000000
hi DiffRemoved ctermfg=009 guifg=#ff0000 ctermbg=000 guibg=#000000

runtime colors/common/link_other_groups.vim
