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
    command! -bar -nargs=* DELMARKS    call DelMarks(<q-args>)
    command!          RENAME           call ChangeSymbolName()
    command! -range=% FORMAT           call AutoFormat(<range> ? [<line1>, <line2>] : [])
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
    command! -bar -bang -nargs=? -complete=buffer BD
                \ try | call CloseBuffer(<q-args>, <bang>0)
                \ | catch | echohl ErrorMsg | echomsg substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
                \ | echohl None | endtry
    command! -bar -bang -nargs=? -complete=buffer BL
                \ try | call CloseBufferToList(<q-args>, <bang>0)
                \ | catch | echohl ErrorMsg | echomsg substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
                \ | echohl None | endtry

" Right click menu
	function! PopUpItemWorks(name, mode) abort
		return 1
	endfunction
	function! BufferListPopUp(entry) abort
		call PopUpStart(5, 0)
		if a:entry
			call PopUpItem('nmenu',     'Open',  '<CR>')
			call PopUpItem('xnoremenu', 'Open',  '<Nop>')
			call PopUpItem('nnoremenu', 'Close', 'dd')
			call PopUpItem('xnoremenu', 'Close', 'd')
		endif
	endfunction
	function! MarkListPopUp(entry) abort
		call PopUpStart(11, 0)
		if a:entry
			call PopUpItem('nmenu',     'Jump',        '<CR>')
			call PopUpItem('xnoremenu', 'Jump',        '<Nop>')
			call PopUpItem('nnoremenu', 'Delete mark', 'dd')
			call PopUpItem('xnoremenu', 'Delete mark', 'd')
		endif
	endfunction
	function! DefaultPopUp() abort
		call PopUpStart(18, 1)
		call PopUpItem('nnoremenu', 'Expand selection',   'vv')
		call PopUpItem('xmenu',     'Expand selection',   'v')
		call PopUpItem('nnoremenu', 'Shrink selection',   '<Nop>')
		call PopUpItem('xmenu',     'Shrink selection',   'V')
		call PopUpItem('nnoremenu', 'Copy',               '<Nop>')
		call PopUpItem('xnoremenu', 'Copy',               '"+y')
		call PopUpItem('nnoremenu', 'Paste',              '"+p')
		call PopUpItem('xnoremenu', 'Paste',              '"+p')
		anoremenu PopUp.-1- <Nop>
		call PopUpItem('nmenu',     'Hover',              '\h')
		call PopUpItem('xnoremenu', 'Hover',              '<Nop>')
		call PopUpItem('nmenu',     'Show error',         '\e')
		call PopUpItem('xnoremenu', 'Show error',         '<Nop>')
		call PopUpItem('nmenu',     'Code actions',       '\q')
		call PopUpItem('xmenu',     'Code actions',       '\q')
		call PopUpItem('nmenu',     'Definition',         '\gdd')
		call PopUpItem('xnoremenu', 'Definition',         '<Nop>')
		call PopUpItem('nmenu',     'Declaration',        '\gDD')
		call PopUpItem('xnoremenu', 'Declaration',        '<Nop>')
		call PopUpItem('nmenu',     'References',         '\grr')
		call PopUpItem('xnoremenu', 'References',         '<Nop>')
		call PopUpItem('nmenu',     'Implementations',    '\gii')
		call PopUpItem('xnoremenu', 'Implementations',    '<Nop>')
		call PopUpItem('nmenu',     'Go to file',         '\gff')
		call PopUpItem('xnoremenu', 'Go to file',         '<Nop>')
		anoremenu PopUp.-2- <Nop>
		call PopUpItem('nnoremenu', 'Rename',             '<Cmd>RENAME<CR>')
		call PopUpItem('xnoremenu', 'Rename',             '<Nop>')
		call PopUpItem('nnoremenu', 'Format',             '<Cmd>FORMAT<CR>')
		call PopUpItem('xnoremenu', 'Format',             ':FORMAT<CR>')
		call PopUpItem('nnoremenu', 'Swap with next',     '<Cmd>SWAP<CR>')
		call PopUpItem('xnoremenu', 'Swap with next',     '<Nop>')
		call PopUpItem('nnoremenu', 'Swap with previous', '<Cmd>PREVSWAP<CR>')
		call PopUpItem('xnoremenu', 'Swap with previous', '<Nop>')
	endfunction
    inoremap <RightMouse> <C-\><C-N><RightMouse>
    if has('menu')
        call DefaultPopUp()
        augroup PopUpMenu
            autocmd!
            autocmd MenuPopup * call PopUp()
        augroup END
	endif

" Clickable items (status bar in neovim or menu bar in gvim)
	if has('menu')
        silent! aunmenu ToolBar
		" Format: nmenu ToolBar.A\ B<Tab>C D
		" 	A = what appears in the menu/status bar (usually an icon), may not contain spaces
		" 	B = what appears in the popup menu to describe the icon
		" 	C = what appears as the "hint text" (usually what command/keymap would be run)
		" 	D = what actually runs
        nnoremenu ToolBar.󰆓\ Save<Tab>:w                         <Cmd>write<CR>
        nnoremenu ToolBar.󰕌\ Undo<Tab>u                          u
        nnoremenu ToolBar.󰑎\ Redo<Tab>^R                         <C-R>
        anoremenu ToolBar.-listbuffers-                          <Nop>
        nmenu     ToolBar.󰈢\ List\ buffers<Tab>\\bb              \bb
        anoremenu ToolBar.-open-                                 <Nop>
        nmenu     ToolBar.󰈞\ Open\ file<Tab>\\oo                 \oo
        xmenu     ToolBar.󰈞\ Open\ file                          \oo
        nmenu     ToolBar.󱎸\ Find\ in\ files<Tab>\\ff            \ff
        xmenu     ToolBar.󱎸\ Find\ in\ files                     \ff
        nmenu     ToolBar.󰉋\ Browse\ directory<Tab>\\dd          \dd
        nmenu     ToolBar.󰚩\ Model\ chat<Tab>\\mm                \mm
        xmenu     ToolBar.󰚩\ Model\ chat                         \m
        nmenu     ToolBar.󰆍\ Terminal<Tab>\\tt                   \tt
        xmenu     ToolBar.󰆍\ Terminal                            \t
        anoremenu ToolBar.-windows-                              <Nop>
        nnoremenu ToolBar.󰯋\ Split<Tab>^Ws                       <C-W>s
        nnoremenu ToolBar.󰯌\ Split\ vertically<Tab>^Wv           <C-W>v
        nnoremenu ToolBar.󰊓\ Only\ this\ window<Tab>:ONLY        <Cmd>ONLY<CR>
        nnoremenu ToolBar.󰖭\ Quit\ window<Tab>:q                 <Cmd>confirm quit<CR>
        anoremenu ToolBar.-buffers-                              <Nop>
        nnoremenu ToolBar.󰅖\ Close\ buffer<Tab>:bd               <Cmd>bdelete<CR>
        nnoremenu ToolBar.󰐓\ Close\ buffer\ to\ list<Tab>:BL     <Cmd>BL<CR>
        nnoremenu ToolBar.󰃢\ Close\ hidden\ buffers<Tab>:CLO     <Cmd>if ClickableConfirm('Close hidden buffers?', "&Yes\n&No", 2) == 1 <Bar> execute 'CLOSEHIDDENBUFFERS' <Bar> endif<CR>
        nnoremenu ToolBar.󰗩\ Close\ hidden\ buffers\ and\ terminals<Tab>:CLO! <Cmd>if ClickableConfirm('Close hidden buffers and terminals?', "&Yes\n&No", 2) == 1 <Bar> execute 'CLOSEHIDDENBUFFERS!' <Bar> endif<CR>
        anoremenu ToolBar.-marks-                                <Nop>
        nnoremenu ToolBar.󰃀\ Marks<Tab>:MarkList                 <Cmd>MarkList<CR>
        nnoremenu ToolBar.󰧎\ Delete\ all\ marks<Tab>:DELMARKS    <Cmd>if ClickableConfirm('Delete all marks?', "&Yes\n&No", 2) == 1 <Bar> DELMARKS <Bar> endif<CR>
        anoremenu ToolBar.-jumps-                                <Nop>
        nnoremenu ToolBar.󰁍\ Back<Tab>^O                         <C-O>
        nnoremenu ToolBar.󰁔\ Forward<Tab>^I                      <C-I>

        let g:toolbar_menu_state = {
                    \ '󰈢 List buffers': 'ListedBuffersState',
                    \ '󰚩 Model chat':   'GenAiModelChatsState',
                    \ '󰆍 Terminal':     'TerminalsState',
                    \ '󰃀 Marks':        'MarksState',
                    \ }
    endif


function! PopUp() abort
	if &filetype ==# 'bufferlist'
		call BufferListPopUp(ClickedOnText())
	elseif &filetype ==# 'marklist'
		call MarkListPopUp(ClickedOnText())
	else
		call DefaultPopUp()
	endif
endfunction

function! DelMarks(marks) abort
    if empty(a:marks)
        delmarks a-zA-Z0-9
    else
        execute 'delmarks' a:marks
    endif
endfunction

function! CopyPath(absolute) abort
    if &filetype ==# 'bufferlist'
        " The buffer under the cursor, not the list itself
        call CopyPathToRegisters(editableBufferList#PathUnderCursor(), a:absolute)
    else
        call CopyPathToRegisters(expand('%:p'), a:absolute)
    endif
endfunction

function! Only() abort
    execute "normal! :only\<CR>"
endfunction

function! CloseBuffer(buf, force) abort
    execute 'bdelete' . (a:force ? '!' : '') a:buf
endfunction

function! CloseBufferToList(buf, force) abort
    let l:buf = empty(a:buf) ? bufnr('%') : a:buf =~# '^\d\+$' ? str2nr(a:buf) : bufnr(a:buf)
	
	" plain :bdelete when we know it'll fail (to get the error message)
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
    if !empty(win_findbuf(l:buf))
		" Still on screen means the list *is* the buffer, so do nothing
        return
    endif
    execute 'bdelete' . (a:force ? '!' : '') l:buf
    for l:win in l:wins
		" Refresh now that buffer has been removed
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
    call editableMarkList#Pick()
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
