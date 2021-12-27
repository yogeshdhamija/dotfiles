source ~/.config/vim/functions.vim

source ~/.config/nvim/vscode-neovim-config.loadbefore.vim

call SourceFileIfExists("~/.vimrc.local.loadbefore")
call SourceFileIfExists(".vim/vimrc.local.loadbefore")

source ~/.config/vim/plugins.vim
source ~/.config/vim/settings.vim

" Remaps
    xnoremap <C-c> "+y
    xnoremap <D-c> "+y
    xnoremap <C-v> "+p
    xnoremap <D-v> "+p
    xmap     ga    <Plug>(EasyAlign)
    nmap     ga    <Plug>(EasyAlign)
    inoremap <C-R> <C-R><C-O>
    augroup dirvish_config
        autocmd!
        autocmd FileType dirvish silent! unmap <buffer> q
        autocmd FileType dirvish
                    \ nnoremap <silent><buffer> t ddO<Esc>:let @"=substitute(@", '\n', '', 'g')<CR>:r ! find "<C-R>"" -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d<CR>:noh<CR>
    augroup END

" Leader shortcuts
    nnoremap z= <Cmd>CocAction<CR>
    xnoremap z= <Esc>:'<,'>CocAction<CR>
    nnoremap \c <Esc><Cmd>noh<CR>
    nnoremap \o <Cmd>Files<CR>
    nnoremap \b <Cmd>Buffers<CR>
    nnoremap \w <Cmd>Windows<CR>
    nnoremap \a <Cmd>CocList commands<CR>
    xnoremap \a <Cmd>CocList commands<CR>
    nnoremap \h <Cmd>call CocActionAsync("doHover") \| call CocActionAsync("showSignatureHelp")<CR>
    inoremap \h <Cmd>call CocActionAsync("doHover") \| call CocActionAsync("showSignatureHelp")<CR>
    nnoremap \e <Cmd>call CocActionAsync("diagnosticInfo")<CR>
    call CreateSplitMappings("n",         "\\d",  "-")
    call CreateSplitMappings("nnore",     "\\gd", "<Cmd>call CocActionAsync('jumpDefinition')<CR>")
    call CreateSplitMappings("nnore",     "\\gr", "<Cmd>call CocActionAsync('jumpReferences')<CR>")
    call CreateSplitMappings("nnore",     "\\gi", "<Cmd>call CocActionAsync('jumpImplementation')<CR>")
    if has('nvim')
        call CreateSplitMappings("nnore", "\\t",  ":terminal<CR>:startinsert<CR>")
    else
        call CreateSplitMappings("nnore", "\\t",  ":terminal ++curwin<CR>")
    endif

" Commands
    command!          Only only
    command!          ONLY Only
    command!          DelMarks delmarks a-zA-Z0-9
    command!          DELMARKS DelMarks
    command!          Rename call CocActionAsync("rename")
    command!          RENAME Rename
    command! -range=% Format <line1>mark < | <line2>mark > | call CocAction("formatSelected", "V")
    command! -range=% FORMAT <line1>,<line2>Format
    command!          Errors CocList --normal diagnostics
    command!          ERRORS Errors
    command!          ERRS Errors
    command!          CD silent cd %:p:h | redraw! | echo ":cd %:p:h" 
    command!          CP let @+ = expand("%:p") | redraw! | echo ":let @+ = expand('%:p')" 
    command! -nargs=? GITLOG Git log --graph --oneline --pretty=format:'%h -%d %s (%cs) <%an>' <args>
    command! -nargs=? GLOG GITLOG <args>
    command!          GITHISTORY BCommits
    command!          GHISTORY GITHISTORY
    command!          PDF w | call WriteToPdf()

source ~/.config/nvim/vscode-neovim-config.vim

call SourceFileIfExists("~/.vimrc.local")
call SourceFileIfExists(".vim/vimrc.local")
