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

" For the status line: how many buffers :ls shows (the listed ones), e.g. '3 buffers'
function! ListedBuffersStatus() abort
    let l:count = len(getbufinfo({'buflisted': 1}))
    return l:count . (l:count == 1 ? ' buffer' : ' buffers')
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

" In Visual mode the selection is ended first: a : typed there would give
"   :split a '<,'> range, which it refuses (E16). The rhs can still get at
"   the selection through '< and '>.
function! CreateSplitMappings(mode, mapping, rhs) abort
    let l:pre = a:mode =~# '^[vx]' ? '<Esc>' : ''
    execute a:mode.'map '.a:mapping.' '.l:pre.a:rhs
    execute a:mode.'map '.a:mapping.a:mapping[-1:].' '.l:pre.a:rhs
    execute a:mode.'map '.a:mapping.'h '.l:pre.':aboveleft vsplit<CR>'.a:rhs
    execute a:mode.'map '.a:mapping.'l '.l:pre.':belowright vsplit<CR>'.a:rhs
    execute a:mode.'map '.a:mapping.'j '.l:pre.':belowright split<CR>'.a:rhs
    execute a:mode.'map '.a:mapping.'k '.l:pre.':aboveleft split<CR>'.a:rhs
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

" confirm(), but its choices can be clicked as well as typed (in a GUI, it's a
"   dialog already)
function! ClickableConfirm(msg, choices = "&Ok", default = 1) abort
    if has('gui_running')
        return confirm(a:msg, a:choices, a:default)
    endif
    " Drawn as confirm() draws them, e.g. '(Y)es, [N]o: ', with where each is
    let l:prompt = ''
    let l:choices = []
    for l:choice in split(a:choices, "\n")
        let l:key = matchstr(l:choice, '&\zs.')
        if empty(l:key)
            let l:key = strcharpart(l:choice, 0, 1)
            let l:choice = '&' . l:choice
        endif
        let l:brackets = len(l:choices) + 1 == a:default ? '[]' : '()'
        let l:prompt .= empty(l:prompt) ? '' : ', '
        let l:from = strdisplaywidth(l:prompt) + 1
        let l:prompt .= substitute(l:choice, '&\(.\)', l:brackets[0] . '\1' . l:brackets[1], '')
        call add(l:choices, {'key': tolower(l:key), 'from': l:from, 'to': strdisplaywidth(l:prompt)})
    endfor
    echohl MoreMsg
    echo a:msg . "\n" . l:prompt . ': '
    echohl None
    " A click picks a choice when the button goes down and up on it
    let l:pressed = 0
    try
        while 1
            let l:key = getcharstr()
            if l:key ==# "\<CR>"
                return a:default
            elseif l:key ==# "\<Esc>" || l:key ==# "\<C-C>"
                return 0
            elseif l:key ==# "\<LeftMouse>" || l:key ==# "\<LeftRelease>"
                let l:pos = getmousepos()
                let l:on = 0
                for l:i in range(len(l:choices))
                    if l:pos.screenrow == &lines
                                \ && l:pos.screencol >= l:choices[l:i].from
                                \ && l:pos.screencol <= l:choices[l:i].to
                        let l:on = l:i + 1
                    endif
                endfor
                if l:key ==# "\<LeftMouse>"
                    let l:pressed = l:on
                elseif l:on && l:on == l:pressed
                    return l:on
                endif
            else
                let l:i = index(map(copy(l:choices), 'v:val.key'), tolower(l:key))
                if l:i >= 0
                    return l:i + 1
                endif
            endif
        endwhile
    catch /^Vim:Interrupt$/
        return 0
    finally
        redraw
    endtry
endfunction

" The text of the last Visual selection, as one line: a selection of several
"   lines is joined with spaces, without their indentation
function! LastVisualSelection() abort
    let l:lines = getregion(getpos("'<"), getpos("'>"), {'type': visualmode()})
    return trim(join(map(l:lines, 'trim(v:val)'), ' '))
endfunction

function! CloseWindowsWithFileType(filetype)
    let l:current_win = winnr()
    let l:win_count = winnr('$')
    for l:i in range(1, l:win_count)
        exe l:i . 'wincmd w'
        if &filetype == a:filetype
            close
            let l:win_count -= 1
            let l:i -= 1
        endif
    endfor
    exe l:current_win . 'wincmd w'
endfunction

