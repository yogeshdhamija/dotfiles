source ~/.config/vim/functions.vim

call SourceFileIfExists("~/.vimrc.local.loadbefore")
call SourceFileIfExists(".vim/vimrc.local.loadbefore")

source ~/.config/vim/plugins.vim
source ~/.config/vim/settings.vim

function! StartTerminal() abort
    terminal ++curwin
endfunction

function! MoveUp() abort
    norm 10k
endfunction

function! MoveDown() abort
    norm 10j
endfunction

" Remaps
    nnoremap          `           <Cmd>call MarksHelper()<CR>
    nnoremap          <C-j>       <Cmd>call MoveDown()<CR>
    nnoremap          <C-k>       <Cmd>call MoveUp()<CR>
    xnoremap          <C-c>       "+y
    xnoremap          <D-c>       "+y
    inoremap          <C-v><C-v> <C-R>+
    inoremap          <D-v><D-v> <C-R>+
    xmap              ga         <Plug>(EasyAlign)
    nmap              ga         <Plug>(EasyAlign)
    inoremap          <C-R>      <C-R><C-O>
    xnoremap          v          <Cmd>call ExpandSelection()<CR>
    xnoremap          V          <Cmd>call ShrinkSelection()<CR>

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

" Leader shortcuts
    nnoremap \q <cmd>call QuickAction()<CR>
    xnoremap \q <cmd>call RangeQuickAction()<CR>
    nnoremap \c <Esc><Cmd>noh<CR>
    nnoremap \o <Cmd>echo ":edit"<CR><Cmd>Files<CR>
    nnoremap \b <Cmd>echo ":buffers"<CR><Cmd>Buffers<CR>
    nnoremap \w <Cmd>Windows<CR>
    nmap \a \q
    xmap \a \q
    nnoremap \h <cmd>call Hover()<CR>
    inoremap \h <cmd>call SignatureHelp()<CR>
    nnoremap \e <Cmd>call Error()<CR>
    call CreateSplitMappings("n",         "\\d",  "-")
    call CreateSplitMappings("nnore",     "\\gd", "<cmd>call Definition()<CR>")
    call CreateSplitMappings("nnore",     "\\gD", "<cmd>call Declaration()<CR>")
    call CreateSplitMappings("nnore",     "\\gr", "<cmd>call References()<CR>")
    call CreateSplitMappings("nnore",     "\\gi", "<cmd>call Implementations()<CR>")
    call CreateSplitMappings("nnore",     "\\t", "<cmd>call StartTerminal()<CR>")

" Commands
    command!          ONLY            only
    command!          DELMARKS        delmarks a-zA-Z0-9 | echo ":delmarks a-zA-Z0-9"
    command!          RENAME          call ChangeSymbolName()
    command! -range=% FORMAT          call AutoFormat()
    command!          ERRORS          call DisplayErrors()
    command!          ERRS            ERRORS
    command!          CD              silent cd %:p:h | redraw! | echo ":cd %:p:h"
    command!          CP              let @+ = expand("%:p") | redraw! | echo ":let @+ = expand('%:p')"
    command! -nargs=? GITLOG          Git log --graph --oneline --pretty=format:'%h -%d %s (%cs) <%an>' <args>
    command! -nargs=? GLOG            GITLOG <args>
    command! -range=% GITHISTORY      <line1>,<line2>BCommits
    command! -range=% GHISTORY        <line1>,<line2>GITHISTORY
    command!          PDF             w | call WriteToPdf()
    command!          SWAP            call SwapWithNextParameter()
    command!          PREVSWAP        call SwapWithPreviousParameter()

call SourceFileIfExists("~/.vimrc.local")
call SourceFileIfExists(".vim/vimrc.local")
