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
    " Like :bd, which closes the buffer's windows, but these keep them: BD has
    "   them show other buffers (if CloseBuffer() is implemented that way), BL
    "   has them show the buffer list.
    " Errors are echoed from here so they read like :bdelete's own one-liner;
    "   left alone (or re-raised with echoerr) they come with an 'Error detected
    "   while processing' header line, and so a hit-enter prompt
    command! -bar -bang -nargs=? -complete=buffer BD
                \ try | call CloseBuffer(<q-args>, <bang>0)
                \ | catch | echohl ErrorMsg | echomsg substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
                \ | echohl None | endtry
    command! -bar -bang -nargs=? -complete=buffer BL
                \ try | call CloseBufferToList(<q-args>, <bang>0)
                \ | catch | echohl ErrorMsg | echomsg substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
                \ | echohl None | endtry

    " A right-click menu item, with the keys or command it runs after its
    "   name: rhs itself, a <Cmd>...<CR> or :...<CR> as that command, or the
    "   optional keys to show instead. A <Nop> shows nothing.
    " They're in the name, lined up: the menu in a terminal leaves out the text
    "   after a <Tab> (:help menu-text), where Vim's own menus put them.
    "   cmd: the :menu command, e.g. 'nmenu'; the item is for that mode only.
    " With s:popup_marks set, an item that won't do anything at the cursor
    "   gets a × in front of its name, and the rest two spaces, so that the
    "   names still line up. It still runs its keys. A <Nop> never does
    "   anything; for the rest, PopUpItemWorks() tells.
    let s:popup_name_width = 18
    let s:popup_marks = 0
    function! s:Item(cmd, name, rhs, ...) abort
        let keys = a:0 ? a:1
                    \ : a:rhs ==? '<Nop>' ? ''
                    \ : substitute(a:rhs, '\c^\%(<Cmd>\|:\)\(.*\)<CR>$', ':\1', '')
        let label = a:name
        if !empty(keys)
            " && is a literal &, where & would underline the next letter
            let label .= repeat(' ', max([2, s:popup_name_width + 2 - strdisplaywidth(a:name)]))
                        \ . substitute(keys, '&', '\&\&', 'g')
        endif
        let label = escape(label, ' .\|')
        if s:popup_marks
            let works = a:rhs !=? '<Nop>' && PopUpItemWorks(a:name, a:cmd[0])
            let label = (works ? '\ \ ' : '×\ ') . label
        endif
        execute a:cmd 'PopUp.' . label a:rhs
    endfunction

    " Whether the right-click menu item a:name can do anything at the cursor,
    "   in mode a:mode ('n' or 'x'). This default says every one can, which
    "   leaves only the <Nop> items marked; other programs can tell better.
    function! PopUpItemWorks(name, mode) abort
        return 1
    endfunction

    " The right-click menu, made anew for each right-click (MenuPopup): the
    "   buffer list, mark list, file search and oil each have their own, and
    "   anywhere else it's the default one. Items that act on the line under
    "   the cursor (where the right-click moved it) are only there when the
    "   click was on that line's own text: a click on the hints above the
    "   first entry, say, moves the cursor to that entry (ClickedOnText()).
    function! s:PopUp() abort
        silent! aunmenu PopUp
        if &filetype ==# 'oil'
            call s:OilPopUp(ClickedOnText())
        elseif &filetype ==# 'filesearch'
            call s:FileSearchPopUp(ClickedOnText())
        elseif &filetype ==# 'bufferlist'
            call s:BufferListPopUp(ClickedOnText())
        elseif &filetype ==# 'marklist'
            call s:MarkListPopUp(ClickedOnText())
        else
            call s:DefaultPopUp()
        endif
    endfunction

    " Nothing in oil saves: it makes the changes on :w, and asks first. So,
    "   as with yy and p, Copy then Paste copies the file, Delete then Paste
    "   moves it, and New is a line to type a name on.
    function! s:OilPopUp(entry) abort
        let s:popup_name_width = 21
        let s:popup_marks = 0
        if a:entry
            call s:Item('nmenu',     'Open',                  '<CR>')
            call s:Item('xnoremenu', 'Open',                  '<Nop>')
            call s:Item('nmenu',     'Open with default app', 'gx')
            call s:Item('xnoremenu', 'Open with default app', '<Nop>')
        endif
        call s:Item('nmenu',     'Open in file manager',  'gX')
        call s:Item('xnoremenu', 'Open in file manager',  '<Nop>')
        if a:entry
            anoremenu PopUp.-1- <Nop>
            call s:Item('nnoremenu', 'Copy path',          '<Cmd>CP<CR>')
            call s:Item('xnoremenu', 'Copy path',          '<Nop>')
            call s:Item('nnoremenu', 'Copy absolute path', '<Cmd>CP!<CR>')
            call s:Item('xnoremenu', 'Copy absolute path', '<Nop>')
        endif
        anoremenu PopUp.-2- <Nop>
        if a:entry
            call s:Item('nnoremenu', 'Copy',   'yy')
            call s:Item('xnoremenu', 'Copy',   'y')
        endif
        call s:Item('nnoremenu', 'Paste',  'p')
        call s:Item('xnoremenu', 'Paste',  '<Nop>')
        call s:Item('nnoremenu', 'New',    'o')
        call s:Item('xnoremenu', 'New',    '<Nop>')
        if a:entry
            call s:Item('nnoremenu', 'Delete', 'dd')
            call s:Item('xnoremenu', 'Delete', 'd')
            anoremenu PopUp.-3- <Nop>
            call s:Item('nmenu',     'Terminal here', 'gt')
            call s:Item('xnoremenu', 'Terminal here', '<Nop>')
        endif
    endfunction

    " On the query line, Open opens the top result, as <CR> does there, and
    "   there's no Remove: dd there empties the query. u undoes a Remove.
    function! s:FileSearchPopUp(entry) abort
        let s:popup_name_width = 19
        let s:popup_marks = 0
        if a:entry
            call s:Item('nmenu',     'Open', '<CR>')
            call s:Item('xnoremenu', 'Open', '<Nop>')
        endif
        if a:entry && line('.') > 1
            call s:Item('nnoremenu', 'Remove from results', 'dd')
            call s:Item('xnoremenu', 'Remove from results', 'd')
        endif
    endfunction

    " Close asks first, as the toolbar's Close buttons do: the list runs :BL
    "   on each line deleted, which closes the buffer at once
    function! s:BufferListPopUp(entry) abort
        let s:popup_name_width = 5
        let s:popup_marks = 0
        if a:entry
            call s:Item('nmenu',     'Open',  '<CR>')
            call s:Item('xnoremenu', 'Open',  '<Nop>')
            call s:Item('nnoremenu', 'Close', '<Cmd>call <SID>ConfirmClose("dd")<CR>', 'dd')
            call s:Item('xnoremenu', 'Close', '<Cmd>call <SID>ConfirmClose("d")<CR>', 'd')
        endif
    endfunction

    " Delete mark asks nothing: u puts it back. On ^ and ., which can't be
    "   deleted, the list puts the line back and says why, as for dd.
    function! s:MarkListPopUp(entry) abort
        let s:popup_name_width = 11
        let s:popup_marks = 0
        if a:entry
            call s:Item('nmenu',     'Jump',        '<CR>')
            call s:Item('xnoremenu', 'Jump',        '<Nop>')
            call s:Item('nnoremenu', 'Delete mark', 'dd')
            call s:Item('xnoremenu', 'Delete mark', 'd')
        endif
    endfunction

    " Types a:keys, which close the buffer list's buffers on the lines they
    "   delete, once that's confirmed. Typed, so the list sees the change;
    "   in Visual mode, a No ends it.
    function! s:ConfirmClose(keys) abort
        let l:visual = mode() =~# "^[vV\<C-V>]"
        let l:count = l:visual ? abs(line('v') - line('.')) + 1 : 1
        if ClickableConfirm(l:count == 1 ? 'Close this buffer?' : 'Close ' . l:count . ' buffers?',
                    \ "&Yes\n&No", 2) == 1
            call feedkeys(a:keys, 'm')
        elseif l:visual
            call feedkeys("\<Esc>", 'n')
        endif
    endfunction

    " Each item stays in its place, marked if it won't do anything here.
    function! s:DefaultPopUp() abort
        let s:popup_name_width = 18
        let s:popup_marks = 1
        call s:Item('nnoremenu', 'Expand selection',   'vv')
        call s:Item('xmenu',     'Expand selection',   'v')
        call s:Item('nnoremenu', 'Shrink selection',   '<Nop>')
        call s:Item('xmenu',     'Shrink selection',   'V')
        call s:Item('nnoremenu', 'Copy',               '<Nop>')
        call s:Item('xnoremenu', 'Copy',               '"+y')
        call s:Item('nnoremenu', 'Paste',              '"+p')
        call s:Item('xnoremenu', 'Paste',              '"+p')
        anoremenu PopUp.-1- <Nop>
        call s:Item('nmenu',     'Hover',              '\h')
        call s:Item('xnoremenu', 'Hover',              '<Nop>')
        call s:Item('nmenu',     'Show error',         '\e')
        call s:Item('xnoremenu', 'Show error',         '<Nop>')
        call s:Item('nmenu',     'Code actions',       '\q')
        call s:Item('xmenu',     'Code actions',       '\q')
        call s:Item('nmenu',     'Definition',         '\gdd')
        call s:Item('xnoremenu', 'Definition',         '<Nop>')
        call s:Item('nmenu',     'Declaration',        '\gDD')
        call s:Item('xnoremenu', 'Declaration',        '<Nop>')
        call s:Item('nmenu',     'References',         '\grr')
        call s:Item('xnoremenu', 'References',         '<Nop>')
        call s:Item('nmenu',     'Implementations',    '\gii')
        call s:Item('xnoremenu', 'Implementations',    '<Nop>')
        call s:Item('nmenu',     'Go to file',         '\gff')
        call s:Item('xnoremenu', 'Go to file',         '<Nop>')
        anoremenu PopUp.-2- <Nop>
        call s:Item('nnoremenu', 'Rename',             '<Cmd>RENAME<CR>')
        call s:Item('xnoremenu', 'Rename',             '<Nop>')
        call s:Item('nnoremenu', 'Format',             '<Cmd>FORMAT<CR>')
        call s:Item('xnoremenu', 'Format',             ':FORMAT<CR>')
        call s:Item('nnoremenu', 'Swap with next',     '<Cmd>SWAP<CR>')
        call s:Item('xnoremenu', 'Swap with next',     '<Nop>')
        call s:Item('nnoremenu', 'Swap with previous', '<Cmd>PREVSWAP<CR>')
        call s:Item('xnoremenu', 'Swap with previous', '<Nop>')
    endfunction

    if has('menu')
        " Made here too, so that it's there before the first right-click
        silent! aunmenu PopUp
        call s:DefaultPopUp()
        augroup PopUpMenu
            autocmd!
            autocmd MenuPopup * call s:PopUp()
        augroup END

        " The buttons (toolbar-menu.nvim). After the <Tab>, the keys or command
        "   each runs, as its button and the popups show it (:help menu-text);
        "   a confirmation in front isn't part of it. Only an item's first
        "   entry's counts, so it's on the Normal mode one.
        silent! aunmenu ToolBar
        nnoremenu ToolBar.󰆓\ Save<Tab>:w                         <Cmd>write<CR>
        nnoremenu ToolBar.󰕌\ Undo<Tab>u                          u
        nnoremenu ToolBar.󰑎\ Redo<Tab>^R                         <C-R>
        anoremenu ToolBar.-open-                                 <Nop>
        nmenu     ToolBar.󰈞\ Open\ file<Tab>\\oo                 \oo
        xmenu     ToolBar.󰈞\ Open\ file                          \oo
        nmenu     ToolBar.󱎸\ Find\ in\ files<Tab>\\ff            \ff
        xmenu     ToolBar.󱎸\ Find\ in\ files                     \ff
        nmenu     ToolBar.󰉋\ Browse\ directory<Tab>\\dd          \dd
        nmenu     ToolBar.󰈢\ List\ buffers<Tab>\\bb              \bb
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
        nnoremenu ToolBar.󰅖\ Close\ buffer<Tab>:bd               <Cmd>if ClickableConfirm('Close this buffer?', "&Yes\n&No", 2) == 1 <Bar> bdelete <Bar> endif<CR>
        nnoremenu ToolBar.󰐓\ Close\ buffer\ to\ list<Tab>:BL     <Cmd>if ClickableConfirm('Close this buffer?', "&Yes\n&No", 2) == 1 <Bar> BL <Bar> endif<CR>
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
    inoremap <RightMouse> <C-\><C-N><RightMouse>

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
