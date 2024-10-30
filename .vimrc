if !has('nvim')
    " Other programs (Neovim, VSCode-Neovim, etc.), when loading vimrc,
    "   are responsible for providing their own functions. They could also
    "   source this same file, if they want, and override some of them.

    " These functions are those such as 'SourceFileIfExists()' and 'CustomFoldText()'
    "   which are used throughout this ~/.vimrc and other scripts sourced by it.
    source ~/.config/vim/functions.vim
endif

call SourceFileIfExists(".vim/vimrc.local.loadbefore")
call SourceFileIfExists("~/.vimrc.local.loadbefore")

source ~/.config/vim/plugins.vim
source ~/.config/vim/settings.vim

" Note: many commands and remaps use functions
"   such as 'AccessMarks()' and 'ExpandSelection()'.
"   Those functions can be overridden by other
"   programs (Neovim, VSCode-Neovim, etc.)
"   when they choose to load this same vimrc.
"
" The encouraged pattern here is that all mappings
"   should be declared in this ~/.vimrc and
"   functionality can be implemented depending on
"   the program by overriding functions.

" Remaps
    xnoremap <C-c>      "+y
    xnoremap <D-c>      "+y
    inoremap <C-v><C-v> <C-R>+
    inoremap <D-v><D-v> <C-R>+
    xmap     ga         <Plug>(EasyAlign)
    nmap     ga         <Plug>(EasyAlign)
    inoremap <C-R>      <C-R><C-O>
    inoremap <C-N>      <C-X><C-O>
    nnoremap `          <Cmd>call AccessMarks()<CR>
    nnoremap <C-j>      <Cmd>call MoveDown()<CR>
    nnoremap <C-k>      <Cmd>call MoveUp()<CR>
    xnoremap v          <Cmd>call ExpandSelection()<CR>
    xnoremap V          <Cmd>call ShrinkSelection()<CR>

    " Fix some terminal issues on iterm
        tnoremap          <S-Space>  <Space>
        tnoremap          <C-Space>  <Space>
        tnoremap          <S-BS>     <BS>
        tnoremap          <C-BS>     <BS>
        tnoremap          <S-CR>     <CR>
        tnoremap          <C-CR>     <CR>

" Leader shortcuts
    xnoremap \p "_dP
    nnoremap \c <Esc><Cmd>call ClearScreen()<CR>
    nnoremap \o <Cmd>call OpenFile()<CR>
    nnoremap \b <Cmd>call ListBuffers()<CR>
    nnoremap \w <Cmd>call ListWindows()<CR>
    nnoremap \q <cmd>call QuickAction()<CR>
    xnoremap \q <cmd>call QuickAction()<CR>
    nnoremap \a <cmd>call AllAction()<CR>
    xnoremap \a <cmd>call AllAction()<CR>
    nnoremap \h <cmd>call Hover()<CR>
    inoremap \h <cmd>call SignatureHelp()<CR>
    nnoremap \e <Cmd>call Error()<CR>
    nnoremap \m <cmd>call InlineAssistThroughAiMagic()<CR>
    xnoremap \m <cmd>call InlineAssistThroughAiMagic()<CR>
    inoremap \m <cmd>call InlineAssistThroughAiMagic()<CR>
    xnoremap \r y<cmd>call RunInTerminal(@")<CR>
    nnoremap \r yy<cmd>call RunInTerminal(@")<CR>
    call CreateSplitMappings("nnore",     "\\d",  "<cmd>call DirectoryBrowser()<CR>")
    call CreateSplitMappings("nnore",     "\\gd", "<cmd>call Definition()<CR>")
    call CreateSplitMappings("nnore",     "\\gD", "<cmd>call Declaration()<CR>")
    call CreateSplitMappings("nnore",     "\\gr", "<cmd>call References()<CR>")
    call CreateSplitMappings("nnore",     "\\gi", "<cmd>call Implementations()<CR>")
    call CreateSplitMappings("nnore",     "\\t", "<cmd>call StartTerminal()<CR>")
    call CreateSplitMappings("nnore",     "\\gf", "<cmd>call GoToFile()<CR>")

" Commands
    command!          ONLY            call Only()
    command!          DELMARKS        call DelMarks()
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
    command!          SWAP            call SwapWithNextParameter()
    command!          PREVSWAP        call SwapWithPreviousParameter()

function! DelMarks() abort
    execute "normal! :delmarks a-zA-Z0-9\<CR>"
endfunction

function! Only() abort
    execute "normal! :only\<CR>"
endfunction

function! StartTerminal() abort
    terminal ++curwin
endfunction

function! MoveUp() abort
    norm 10k
endfunction

function! MoveDown() abort
    norm 10j
endfunction

function! AllAction() abort
    call QuickAction()
endfunction

function! AccessMarks() abort
    call MarksHelper()
endfunction

function! DirectoryBrowser() abort
    norm -
endfunction

function! ClearScreen() abort
    set nohlsearch
endfunction

function! OpenFile() abort
    execute "normal! :Files\<CR>"
endfunction

function! ListBuffers() abort
    execute "normal! :Buffers\<CR>"
endfunction

function! ListWindows() abort
    execute "normal! :Windows\<CR>"
endfunction

function! GoToFile() abort
    execute "normal! gf"
endfunction

call SourceFileIfExists("~/.config/vim/dirvish_config.vim")

call SourceFileIfExists("~/.vimrc.local")
call SourceFileIfExists(".vim/vimrc.local")
