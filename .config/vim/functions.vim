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

function! CreateCenteredFloatingWindow() abort
    if(!has('nvim')) 
        split
        new
    else
        let width = float2nr(&columns * 0.6)
        let height = float2nr(&lines * 0.6)
        let top = ((&lines - height) / 2) - 1
        let left = (&columns - width) / 2
        let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}
        let s:buf = nvim_create_buf(v:false, v:true)
        call nvim_open_win(s:buf, v:true, opts)
    endif
endfunction

function! SetColors() abort
    set background=dark
    set number
    syntax on
    silent! colorscheme gruvbox
    if(has('nvim'))
        set scl=auto:9
    else
        set scl=auto
    endif
    set foldmethod=indent
    set foldlevelstart=99
    tabdo windo set foldtext=CustomFoldText()
    tabdo windo set fillchars=fold:\ 
    set laststatus=2
    set noshowmode
    highlight CocHighlightText ctermbg=241 guibg=#665c54
endfunction

function! MarksHelper() abort
    if(reg_recording() == '' && reg_executing() == '')
        echo ":marks"
        Marks
    else
        call feedkeys("`", 'nt')
    endif
endfunction
