function! SourceFileIfExists(filepath) abort
    try
        execute "source " . a:filepath
    catch
    endtry
endfunction

" Like SourceFileIfExists(), but for config belonging to the project being
"   edited rather than to us, so it is never run just because we happened to
"   start up in that directory.
"
" Neovim (including VSCode-Neovim) gates it behind the trust list (:h trust):
"   vim.secure.read() returns v:null unless the file is trusted, prompting the
"   first time it sees it and again whenever its contents change -- so it also
"   covers the "if exists" part. Executing the returned contents, instead of
"   re-sourcing the path, avoids the TOCTOU window the :trust docs warn about.
"
" Vim has no trust list, so it refuses to load these files at all and tells you
"   how to do it by hand once you've decided the project is trustworthy.
function! SourceProjectFileIfExists(filepath) abort
    if has('nvim')
        let l:contents = v:lua.vim.secure.read(fnamemodify(a:filepath, ':p'))
        if type(l:contents) != v:t_string
            return
        endif
        try
            call v:lua.vim.api.nvim_exec2(l:contents, {})
        catch
        endtry
    elseif filereadable(a:filepath)
        echohl WarningMsg
        echomsg "did not load untrusted file. Use source "
                    \ . fnamemodify(a:filepath, ':p:~') . " to load manually"
        echohl None
    endif
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

" Copies a path into both the system clipboard (+) and the unnamed (") register.
"   When a:absolute is falsy, the path is shortened to be relative to the cwd,
"   falling back to the absolute path when it does not live below the cwd.
function! CopyPathToRegisters(path, absolute) abort
    if empty(a:path)
        echohl WarningMsg | echo "Nothing to copy: this buffer has no path" | echohl None
        return
    endif
    " ':p' appends a trailing slash to directories, which is what we want: a
    "   copied directory path should read as one.
    let l:absolute_path = fnamemodify(a:path, ':p')
    " ':.' shortens to a cwd-relative path only when the path is below the cwd,
    "   and leaves it absolute otherwise. That is exactly the fallback we want.
    let l:path = a:absolute ? l:absolute_path : fnamemodify(l:absolute_path, ':.')
    " ':.' reduces the cwd itself to an empty string once it carries a trailing
    "   slash, so name it explicitly instead of copying nothing.
    if empty(l:path)
        let l:path = './'
    endif
    let @" = l:path
    " Vim builds without clipboard support ('vim --version' shows -clipboard)
    "   throw E354 on any write to @+, so only attempt it when it can work.
    "   The unnamed register is set first so it survives either way.
    if has('nvim') || has('clipboard')
        let @+ = l:path
    endif
    redraw!
    echo "Copied: " . l:path
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

    let l:origbuf = bufnr('%')
    let l:origwin = win_getid()

    if has('nvim')
        call NvimOnlyCreateCenteredFloatingWindow()
    else
        vertical botright 45new
        setlocal nonumber norelativenumber nolist nocursorline nofoldenable
    endif
    setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted nowrap
    call setline(1, MarksHelperLines(l:origbuf))
    setlocal nomodifiable
    syntax match MarksHelperHeader /^\S.*/
    syntax match MarksHelperKey /^\s\zs\S/
    syntax match MarksHelperLnum /^\s\S\s\+\zs\d\+/
    highlight default link MarksHelperHeader Title
    highlight default link MarksHelperKey Identifier
    highlight default link MarksHelperLnum Number
    let l:helperwin = win_getid()

    let l:raw = 27
    let l:prompt = '`'
    try
        while 1
            redraw
            echo l:prompt
            let l:prompt = '`'
            let l:raw = getchar()
            " <BS>/<Del> arrive as special-key strings, or as 8/127 from some terminals
            let l:isdel = type(l:raw) == v:t_number
                \ ? (l:raw == 8 || l:raw == 127)
                \ : (l:raw ==# "\<BS>" || l:raw ==# "\<Del>")
            if !l:isdel
                break
            endif

            redraw
            let l:marks = trim(input(':DELMARKS '))
            if !empty(l:marks)
                try
                    execute 'DELMARKS' l:marks
                catch
                    let l:prompt = substitute(v:exception, '^Vim\%((\a\+)\)\=:', '', '')
                endtry
            endif
            setlocal modifiable
            silent %delete _
            call setline(1, MarksHelperLines(l:origbuf))
            setlocal nomodifiable
        endwhile
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

