if exists('did_load_filetypes')
    finish
endif

" Don't look into any type of file to detect its filetype.
let g:ft_ignore_pat = '.*'

augroup filetypedetect
    autocmd!
    autocmd  BufRead,BufNewFile  *.c    setfiletype  c
    autocmd  BufRead,BufNewFile  *.h    setfiletype  c
    autocmd  BufRead,BufNewFile  *.cpp  setfiletype  cpp
    autocmd  BufRead,BufNewFile  *.css  setfiletype  css
    autocmd  BufRead    COMMIT_EDITMSG  setfiletype  gitcommit
    autocmd  BufRead,BufNewFile  *.js   setfiletype  javascript
    autocmd  BufRead,BufNewFile  *.R    setfiletype  R
    autocmd  BufRead,BufNewFile  *.sql  setfiletype  sql
    autocmd  BufRead,BufNewFile  *.tex  setfiletype  tex
    autocmd  BufRead,BufNewFile  *.vim  setfiletype  vim
    autocmd  BufRead,BufNewFile  vimrc  setfiletype  vim
    "
    " Any file that doesn't match one of the above patterns will get a
    " made up filetype and thus no filetype plugins will be loaded.
    "
    autocmd  BufRead,BufNewFile  *      setfiletype  ignored
augroup END
