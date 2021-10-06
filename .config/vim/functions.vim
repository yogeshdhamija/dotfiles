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

function! EnableIndentLines() abort
    if v:vim_did_enter
        tabdo windo IndentGuidesEnable
    endif
    let g:indentLine_enabled=1
    augroup indentlines_augroup
        autocmd!
        if(has('nvim'))
            autocmd TermEnter *  IndentGuidesDisable 
            autocmd TermLeave *  IndentGuidesEnable 
        endif
    augroup END
endfunction

function! DisableIndentLines() abort
    if v:vim_did_enter
        tabdo windo IndentGuidesDisable
    endif
    let g:indentLine_enabled=0
    augroup indentlines_augroup
        autocmd!
    augroup END
endfunction

function! DisableLightline() abort
    if v:vim_did_enter
        silent! call lightline#disable()
    endif
    augroup lightline_augroup
        autocmd!
        autocmd VimEnter * silent! call lightline#disable()
    augroup END
endfunction

function! EnableLightline() abort
    if v:vim_did_enter
        silent! call lightline#enable()
    endif
    augroup lightline_augroup
        autocmd!
        autocmd VimEnter * silent! call lightline#enable()
    augroup END
endfunction

function! CustomFoldText() abort
    let indent_level = indent(v:foldstart)
    let indent = repeat(' ', indent_level - 4)
    let text = substitute(foldtext(), "^\s*\+-*", "", "")
    let text = substitute(text, '^\s*\([^:]*\):\(.*\)$', '\2 --+ (\1)', "")
    return indent . '+--' . text
endfunction

function! WriteToPdf() abort
    let current_dir = escape(expand("%:p:h"), ' ') . ";"
    let listings_file = findfile(".listings-setup.tex", current_dir)
    exe '!pandoc "%:p" --listings -H "' . listings_file . '" -o "%:p:r.pdf" -V geometry:margin=1in'
endfunction

function! EnableJumpToLastPositionWhenReOpeningFile() abort
    augroup jump_to_last_position_on_open
        autocmd!
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
                    \ | exe "normal! g`\"" | endif
    augroup END
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
    if exists('g:vscode')
        execute a:mode.'map '.a:mapping.' '.a:rhs
        execute a:mode.'map '.a:mapping.a:mapping[-1:].' '.a:rhs
        execute a:mode.'map '.a:mapping.'h :call VSCodeNotify("workbench.action.newGroupLeft")<CR>'.a:rhs
        execute a:mode.'map '.a:mapping.'l :call VSCodeNotify("workbench.action.newGroupRight")<CR>'.a:rhs
        execute a:mode.'map '.a:mapping.'j :call VSCodeNotify("workbench.action.newGroupBelow")<CR>'.a:rhs
        execute a:mode.'map '.a:mapping.'k :call VSCodeNotify("workbench.action.newGroupAbove")<CR>'.a:rhs
    else
        execute a:mode.'map '.a:mapping.' '.a:rhs
        execute a:mode.'map '.a:mapping.a:mapping[-1:].' '.a:rhs
        execute a:mode.'map '.a:mapping.'h :aboveleft vsplit<CR>'.a:rhs
        execute a:mode.'map '.a:mapping.'l :belowright vsplit<CR>'.a:rhs
        execute a:mode.'map '.a:mapping.'j :belowright split<CR>'.a:rhs
        execute a:mode.'map '.a:mapping.'k :aboveleft split<CR>'.a:rhs
    endif
endfunction

function! ExecuteVSCodeCommandInVisualMode(command_name) abort
    let visualmode = visualmode()
    if visualmode ==# 'V'
        let startLine = line("v")
        let endLine = line(".")
        call VSCodeNotifyRange(a:command_name, startLine, endLine, 1)
    else
        let startPos = getpos("v")
        let endPos = getpos(".")
        call VSCodeNotifyRangePos(a:command_name, startPos[1], endPos[1], startPos[2], endPos[2]+1, 1)
    endif
endfunction

function! CreateCenteredFloatingWindow()
    if(!has('nvim')) 
        split
        new
    else
        let width = float2nr(&columns * 0.6)
        let height = float2nr(&lines * 0.6)
        let top = ((&lines - height) / 2) - 1
        let left = (&columns - width) / 2
        let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

        let top = "╭" . repeat("─", width - 2) . "╮"
        let mid = "│" . repeat(" ", width - 2) . "│"
        let bot = "╰" . repeat("─", width - 2) . "╯"
        let lines = [top] + repeat([mid], height - 2) + [bot]
        let s:buf = nvim_create_buf(v:false, v:true)
        call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
        call nvim_open_win(s:buf, v:true, opts)
        set winhl=Normal:Floating
        let opts.row += 1
        let opts.height -= 2
        let opts.col += 2
        let opts.width -= 4
        call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
        au BufWipeout <buffer> exe 'bw '.s:buf
    endif
endfunction
