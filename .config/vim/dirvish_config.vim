augroup dirvish_config
    autocmd!
    autocmd FileType dirvish silent! unmap <buffer> q
    autocmd FileType dirvish silent! unmap <buffer> i
    autocmd FileType dirvish silent! unmap <buffer> I
    autocmd FileType dirvish silent! unmap <buffer> o
    autocmd FileType dirvish silent! unmap <buffer> O
    autocmd FileType dirvish silent! unmap <buffer> a
    autocmd FileType dirvish silent! unmap <buffer> A
    autocmd FileType dirvish silent! unmap <buffer> p
    autocmd FileType dirvish silent! unmap <buffer> x
    autocmd FileType dirvish silent! unmap <buffer> .
    autocmd FileType dirvish silent! unmap <buffer> cd
    autocmd FileType dirvish silent! unmap <buffer> dax
    autocmd FileType dirvish silent! unmap <buffer> /

    autocmd FileType dirvish set conceallevel=0
    autocmd BufEnter,CursorMoved * if exists("b:dirvish") | set conceallevel=0 | endif

    autocmd FileType dirvish nnoremap <silent><buffer> t 0C<Esc>:let @"=substitute(@", '\n', '', 'g')<CR>:r ! find "<C-R>"" -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d<CR>:noh<CR>

    autocmd BufEnter,CursorMoved * if exists("b:dirvish") | execute 'match Type /\v[^\/]+\/?$/' | else | match none | endif
    autocmd BufEnter,CursorMoved * if exists("b:dirvish") | execute '3match Conditional /\v[^\/]+$/' | else | 3match none | endif
    autocmd BufEnter,CursorMoved * if exists("b:dirvish") | execute '2match LineNr |'.substitute(expand('%'), getcwd(), '', '')[1:].'|' | else | 2match none | endif
augroup END
