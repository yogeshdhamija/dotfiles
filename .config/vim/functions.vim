function! SourceFileIfExists(filepath) abort
    try
        execute "source " . a:filepath
    catch
    endtry
endfunction

function! DetectWsl() abort
    return filereadable("/proc/version") && (match(readfile("/proc/version"), "Microsoft") != -1)
endfunction

function! DetectUbuntu() abort
    return filereadable("/proc/version") && (match(readfile("/proc/version"), "Ubuntu") != -1) && (match(readfile("/proc/version"), "Microsoft") == -1)
endfunction

function! DetectIterm() abort
    return $TERM_PROGRAM =~ "iTerm"
endfunction

function! InstallPluginManagerIfNotInstalled() abort
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
endfunction

function! InstallPlugins(plugins, disabled_plugins) abort
    call InstallPluginManagerIfNotInstalled()
    call plug#begin('~/.vim/plugged')
    for plugin in a:plugins
        if index(a:disabled_plugins, plugin[0], 0, 1) == -1
            Plug plugin[0], plugin[1]
        endif
    endfor
    call plug#end()
endfunction

function! CustomFoldText() abort
    let indent_level = indent(v:foldstart)
    let indent = repeat(' ', indent_level)
    let text = substitute(foldtext(), "^\s*\+-*", "", "")
    let text = substitute(text, '^\(\s*[^:]*\):\s\(.*\)$', '\2 ...', "")
    return indent . text
endfunction

function! SetClipboardForWslTerminal() abort
    let g:clipboard = {
                \   'name': 'WslClipboard',
                \   'copy': {
                \      '+': 'clip.exe',
                \      '*': 'clip.exe',
                \    },
                \   'paste': {
                \      '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                \      '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
                \   },
                \   'cache_enabled': 0,
                \ }
endfunction

function! CreateSplitMappings(mode, mapping, rhs) abort
    execute a:mode.'map '.a:mapping.' '.a:rhs
    execute a:mode.'map '.a:mapping.a:mapping[-1:].' '.a:rhs
    execute a:mode.'map '.a:mapping.'h :aboveleft vsplit<CR>'.a:rhs
    execute a:mode.'map '.a:mapping.'l :belowright vsplit<CR>'.a:rhs
    execute a:mode.'map '.a:mapping.'j :belowright split<CR>'.a:rhs
    execute a:mode.'map '.a:mapping.'k :aboveleft split<CR>'.a:rhs
endfunction

function! CreateMappingsInAllModes(mapping, rhs) abort
    execute 'nmap '.a:mapping.' '.a:rhs
    execute 'imap '.a:mapping.' '.a:rhs
    execute 'cmap '.a:mapping.' '.a:rhs
    execute 'vmap '.a:mapping.' '.a:rhs
    execute 'xmap '.a:mapping.' '.a:rhs
    execute 'smap '.a:mapping.' '.a:rhs
    execute 'omap '.a:mapping.' '.a:rhs
    execute 'tmap '.a:mapping.' '.a:rhs
    execute 'lmap '.a:mapping.' '.a:rhs
endfunction

function! NvimOnlyCreateCenteredFloatingWindow() abort
    let width = float2nr(&columns * 0.6)
    let height = float2nr(&lines * 0.6)
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_open_win(s:buf, v:true, opts)
endfunction

function! MarksHelperAddSection(lines, header, entries) abort
    if empty(a:entries)
        return
    endif
    if !empty(a:lines)
        call add(a:lines, '')
    endif
    call add(a:lines, a:header)
    call extend(a:lines, a:entries)
endfunction

function! MarksHelperLines(buf) abort
    let l:special_desc = {
        \ "'": 'position before last jump',
        \ '"': 'position when last exiting buffer',
        \ '^': 'position of last insert',
        \ '.': 'position of last change',
        \ '[': 'start of last change or yank',
        \ ']': 'end of last change or yank',
        \ '<': 'start of last visual selection',
        \ '>': 'end of last visual selection',
    \ }

    let l:local = {}
    let l:special = {}
    for l:m in getmarklist(a:buf)
        let l:char = strpart(l:m.mark, 1)
        if l:char =~# '^[a-z]$'
            let l:local[l:char] = l:m.pos[1]
        elseif has_key(l:special_desc, l:char)
            let l:special[l:char] = l:m.pos[1]
        endif
    endfor

    let l:global = {}
    let l:numbered = {}
    for l:m in getmarklist()
        let l:char = strpart(l:m.mark, 1)
        let l:where = fnamemodify(get(l:m, 'file', ''), ':~') . ':' . l:m.pos[1]
        if l:char =~# '^[A-Z]$'
            let l:global[l:char] = l:where
        elseif l:char =~# '^[0-9]$'
            let l:numbered[l:char] = l:where
        endif
    endfor

    let l:lines = []

    let l:entries = []
    for l:char in sort(keys(l:local))
        let l:text = trim(get(getbufline(a:buf, l:local[l:char]), 0, ''))
        call add(l:entries, printf(' %s  %4d  %s', l:char, l:local[l:char], l:text))
    endfor
    call MarksHelperAddSection(l:lines, 'Local (a-z)', l:entries)

    let l:entries = []
    for l:char in sort(keys(l:global))
        call add(l:entries, printf(' %s  %s', l:char, l:global[l:char]))
    endfor
    call MarksHelperAddSection(l:lines, 'Global (A-Z)', l:entries)

    let l:entries = []
    for l:char in sort(keys(l:numbered))
        call add(l:entries, printf(' %s  %s', l:char, l:numbered[l:char]))
    endfor
    call MarksHelperAddSection(l:lines, 'Numbered (0-9, previous sessions)', l:entries)

    let l:entries = []
    for l:char in ["'", '"', '^', '.', '[', ']', '<', '>']
        if has_key(l:special, l:char)
            call add(l:entries, printf(' %s  %4d  %s', l:char, l:special[l:char], l:special_desc[l:char]))
        endif
    endfor
    call MarksHelperAddSection(l:lines, 'Special', l:entries)

    if empty(l:lines)
        let l:lines = ['No marks set']
    endif
    return l:lines
endfunction

function! MarksHelper() abort
    if(reg_recording() != '' || reg_executing() != '')
        call feedkeys("`", 'nti')
        return
    endif

    let l:lines = MarksHelperLines(bufnr('%'))
    let l:origwin = win_getid()

    if has('nvim')
        call NvimOnlyCreateCenteredFloatingWindow()
    else
        vertical botright 45new
        setlocal nonumber norelativenumber nolist nocursorline nofoldenable
    endif
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nowrap
    call setline(1, l:lines)
    setlocal nomodifiable
    syntax match MarksHelperHeader /^\S.*/
    syntax match MarksHelperKey /^\s\zs\S/
    syntax match MarksHelperLnum /^\s\S\s\+\zs\d\+/
    highlight default link MarksHelperHeader Title
    highlight default link MarksHelperKey Identifier
    highlight default link MarksHelperLnum Number
    let l:helperwin = win_getid()

    let l:raw = 27
    try
        redraw
        echo '`'
        let l:raw = getchar()
    catch /^Vim:Interrupt$/
        let l:raw = 27
    finally
        call win_gotoid(l:helperwin)
        close
        call win_gotoid(l:origwin)
        redraw
        echo ''
    endtry

    let l:char = type(l:raw) == v:t_number ? nr2char(l:raw) : ''
    if !empty(l:char) && stridx("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789`'\"^.[]<>", l:char) >= 0
        call feedkeys('`' . l:char, 'ni')
    endif
endfunction

function! RunInNearestTerminal(cmd) range abort
    let l:foundterm = 0

    " Switch to terminal window, if one is open
    for winnr in range(1, winnr('$'))
      let bufnr = winbufnr(winnr)
      if getbufvar(bufnr, '&buftype') ==# 'terminal'
        execute winnr . "wincmd w"
        let l:foundterm = 1
        break
      endif
    endfor

    " Else, switch to terminal buffer if buffer is open
    if(!l:foundterm)
        for l:buffer_nr in reverse(range(1, bufnr('$')))
            if getbufvar(l:buffer_nr, '&buftype') ==# 'terminal'
                vsplit
                execute 'buffer' l:buffer_nr
                let l:foundterm = 1
                break
            endif
        endfor
    endif

    " Else, start a new terminal buffer
    if(!l:foundterm)
        vsplit
        terminal
    endif

    let l:orig_z = @z
    let @z = a:cmd
    stopinsert
    normal! "zp
    let @z = l:orig_z
    normal! i
endfunction
