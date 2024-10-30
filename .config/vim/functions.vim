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

function! MarksHelper() abort
    if(reg_recording() == '' && reg_executing() == '')
        echo ":marks"
        Marks
    else
        call feedkeys("`", 'nt')
    endif
endfunction

function! RunInTerminal(cmd) range abort
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

    " Else, switch to terminal buffer in current window, if buffer is open
    if(!l:foundterm)
        for l:buffer_nr in reverse(range(1, bufnr('$')))
            if getbufvar(l:buffer_nr, '&buftype') ==# 'terminal'
                execute 'buffer' l:buffer_nr
                let l:foundterm = 1
                break
            endif
        endfor
    endif

    " Else, start a new terminal buffer in current window
    if(!l:foundterm)
        terminal
    endif

    let l:orig_z = @z
    let @z = a:cmd
    stopinsert
    normal! "zp
    let @z = l:orig_z
    normal! i
endfunction
