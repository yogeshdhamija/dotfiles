if !has('nvim')
    " Other programs (Neovim, VSCode-Neovim, etc.), when loading vimrc,
    "   are responsible for providing their own functions. They could also
    "   source this same file, if they want, and override some of them.

    " These functions are those such as 'SourceFileIfExists()' and 'CustomFoldText()'
    "   which are used throughout this ~/.vimrc and other scripts sourced by it.
    source ~/.config/vim/functions.vim
endif

call SourceProjectFileIfExists(".vim/vimrc.local.loadbefore")
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
    noremap <C-j>       <Cmd>call MoveDown()<CR>
    noremap <C-k>       <Cmd>call MoveUp()<CR>
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
    nnoremap \w <Cmd>call ListWindows()<CR>
    nnoremap \q <cmd>call QuickAction()<CR>
    xnoremap \q <cmd>call QuickAction()<CR>
    nnoremap \a <cmd>call AllAction()<CR>
    xnoremap \a <cmd>call AllAction()<CR>
    nnoremap \h <cmd>call Hover()<CR>
    inoremap \h <cmd>call SignatureHelp()<CR>
    nnoremap \e <Cmd>call Error()<CR>
    xnoremap \m y<cmd>call OpenNearestGenAiModelChat(@")<CR>
	xmap \t \r
    xnoremap \r y<cmd>call RunInNearestTerminal(@")<CR>
    nnoremap \r yy<cmd>call RunInNearestTerminal(@")<CR>
    call CreateSplitMappings("nnore", "\\o",  "<cmd>call OpenFile()<CR>")
    call CreateSplitMappings("xnore", "\\o",  "<cmd>call OpenFile(LastVisualSelection())<CR>")
    call CreateSplitMappings("nnore", "\\f",  "<cmd>call FindInFiles()<CR>")
    call CreateSplitMappings("xnore", "\\f",  "<cmd>call FindSelectedTextInFiles()<CR>")
    call CreateSplitMappings("nnore", "\\d",  "<cmd>call DirectoryBrowser()<CR>")
    call CreateSplitMappings("nnore", "\\b",  "<cmd>call ListBuffers()<CR>")
    call CreateSplitMappings("nnore", "\\gd", "<cmd>call Definition()<CR>")
    call CreateSplitMappings("nnore", "\\gD", "<cmd>call Declaration()<CR>")
    call CreateSplitMappings("nnore", "\\gr", "<cmd>call References()<CR>")
    call CreateSplitMappings("nnore", "\\gi", "<cmd>call Implementations()<CR>")
    call CreateSplitMappings("nnore", "\\gf", "<cmd>call GoToFile()<CR>")
    call CreateSplitMappings("nnore", "\\t",  "<cmd>call StartTerminal()<CR>")
    call CreateSplitMappings("nnore", "\\m",  "<cmd>call StartGenAiModelChat()<CR>")

" Commands
    command!          ONLY             call Only()
    command! -nargs=* DELMARKS         call DelMarks(<q-args>)
    command!          RENAME           call ChangeSymbolName()
    command! -range=% FORMAT           call AutoFormat()
    command!          ERRORS           call DisplayErrors()
    command!          ERRS             ERRORS
    command!          CD               silent cd %:p:h | redraw! | echo ":cd %:p:h"
    command! -bang    CP               call CopyPath(<bang>0)
    command! -nargs=? GITLOG           Git log --graph --oneline --pretty=format:'%h -%d %s (%cs) <%an>' <args>
    command! -nargs=? GLOG             GITLOG <args>
    command! -range=% GITHISTORY       <line1>,<line2>BCommits
    command! -range=% GHISTORY         <line1>,<line2>GITHISTORY
    command!          SWAP             call SwapWithNextParameter()
    command!          PREVSWAP         call SwapWithPreviousParameter()
    command!          BREAKPOINT       call ToggleBreakpoint()
    command!          TOGGLEDEBUGGERUI call ToggleDebuggerUi()
    command!          DEBUG            call StartDebugger()
    " Like :bd, which closes the buffer's windows, but these keep them: BD has
    "   them show other buffers (if CloseBuffer() is implemented that way), BL
    "   has them show the buffer list.
    " Errors are echoed from here so they read like :bdelete's own one-liner;
    "   left alone (or re-raised with echoerr) they come with an 'Error detected
    "   while processing' header line, and so a hit-enter prompt
    command! -bang -nargs=? -complete=buffer BD
                \ try | call CloseBuffer(<q-args>, <bang>0)
                \ | catch | echohl ErrorMsg | echomsg substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
                \ | echohl None | endtry
    command! -bang -nargs=? -complete=buffer BL
                \ try | call CloseBufferToList(<q-args>, <bang>0)
                \ | catch | echohl ErrorMsg | echomsg substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
                \ | echohl None | endtry

function! DelMarks(marks) abort
    if empty(a:marks)
        delmarks a-zA-Z0-9
    else
        execute 'delmarks' a:marks
    endif
endfunction

function! CopyPath(absolute) abort
    call CopyPathToRegisters(expand('%:p'), a:absolute)
endfunction

function! Only() abort
    execute "normal! :only\<CR>"
endfunction

" Plain :bdelete, which closes every window the buffer is in.
function! CloseBuffer(buf, force) abort
    execute 'bdelete' . (a:force ? '!' : '') a:buf
endfunction

" Like :bdelete, but every window showing the buffer switches to the buffer
"   list instead of closing.
function! CloseBufferToList(buf, force) abort
    " bufnr('5') would look for a buffer *named* 5
    let l:buf = empty(a:buf) ? bufnr('%') : a:buf =~# '^\d\+$' ? str2nr(a:buf) : bufnr(a:buf)
    " Left to :bdelete, before any window has switched, when it would refuse:
    "   no single buffer matches (E93/E94), or unsaved changes (E89), which
    "   'modified' tells exactly -- including a terminal's running job, in Vim
    "   (E948) but not Nvim, where that's checked separately (E89)
    if l:buf < 1 || (!a:force && (getbufvar(l:buf, '&modified') || (has('nvim')
                \ && getbufvar(l:buf, '&buftype') ==# 'terminal'
                \ && jobwait([getbufvar(l:buf, '&channel')], 0)[0] == -1)))
        execute 'bdelete' a:buf
        return
    endif
    let l:wins = win_findbuf(l:buf)
    for l:win in l:wins
        call win_execute(l:win, 'BufferList')
    endfor
    " Still on screen means the list *is* the buffer: it was a list already
    "   (BufferList from a list redraws it in place), or an empty [No Name]
    "   one, which the :enew that opens a new list reuses. Either way it's
    "   unlisted now, and deleting it would close the very windows it's in
    if !empty(win_findbuf(l:buf))
        return
    endif
    execute 'bdelete' . (a:force ? '!' : '') l:buf
    " Again, so those lists don't still show it: while the buffer list applies
    "   a deleted line (which runs this), lists don't update themselves
    for l:win in l:wins
        call win_execute(l:win, 'BufferList')
    endfor
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

" {query} prefills the search, if given
function! OpenFile(query = '') abort
    if empty(a:query)
        execute "normal! :Files\<CR>"
    else
        call fzf#vim#files('', fzf#vim#with_preview({'options': ['--query', a:query]}))
    endif
endfunction

" find-in-dir-helper.vim's default \f mappings step aside for the ones above,
"   so these do what they did. They also handle VSCode-Neovim.
function! FindInFiles() abort
    call findInDirHelper#DisplayHelpAndSearch()
endfunction

" Runs with Visual mode already ended; implementations get the selection
"   back from the '< and '> marks
function! FindSelectedTextInFiles() abort
    call findInDirHelper#FindSelectedTextInDir()
endfunction

" The text of the last Visual selection, as one line: a selection of several
"   lines is joined with spaces, without their indentation
function! LastVisualSelection() abort
    let l:lines = getregion(getpos("'<"), getpos("'>"), {'type': visualmode()})
    return trim(join(map(l:lines, 'trim(v:val)'), ' '))
endfunction

function! ListBuffers() abort
    execute "normal! :BufferList\<CR>"
endfunction

function! ListWindows() abort
    execute "normal! :Windows\<CR>"
endfunction

function! GoToFile() abort
    execute "normal! gf"
endfunction

call SourceFileIfExists("~/.config/vim/dirvish_config.vim")

call SourceFileIfExists("~/.vimrc.local")

if !has('nvim') " if nvim, call this function after nvim-specific config is loaded
    call SourceProjectFileIfExists(".vim/vimrc.local")
endif
