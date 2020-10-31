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

function! UnloadColors() abort
    let l:win_view = winsaveview()
    tabdo windo set number&
    tabdo windo set signcolumn&
    tabdo windo set foldmethod&
    tabdo windo set foldignore&
    tabdo windo set foldtext&
    tabdo windo set fillchars&
    set foldlevelstart&
    tabdo windo set nofoldenable
    syntax off
    if has('nvim')
        set inccommand&
    endif
    tabdo windo set wrap&
    tabdo windo set breakindent&
    set showbreak&
    tabdo windo set list&
    set showmode&
    set laststatus&
    let $NVIM_TUI_ENABLE_TRUE_COLOR=0
    set notermguicolors
    let g:lightline={'colorscheme': 'default'}
    colorscheme default
    set background=dark
    call DisableLightline()
    call DisableIndentLines()
    call winrestview(l:win_view)
endfunction

function! LoadColors() abort
    let l:win_view = winsaveview()
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    if (DetectUbuntu() || DetectIterm() || DetectWsl() || 
                \ (exists("g:is_termguicolors_supported") && g:is_termguicolors_supported == 1))
        set termguicolors
    endif
    tabdo windo set foldmethod=indent
    tabdo windo set foldignore=
    set foldlevelstart=99
    tabdo windo set foldtext=CustomFoldText()
    tabdo windo set fillchars=fold:\ 
    tabdo windo set number
    tabdo windo set signcolumn=yes
    tabdo windo set nofoldenable
    syntax on
    tabdo windo set wrap
    tabdo windo set breakindent
    set listchars=tab:\|\ ,eol:$
    let g:indent_guides_tab_guides = 0
    tabdo windo set list
    set noshowmode
    set laststatus=2
    set showbreak===>\|
    if has('nvim')
        autocmd WinEnter,TermOpen term://* setlocal nolist nonumber norelativenumber scl=no
        set inccommand=nosplit
    endif
    let g:gruvbox_bold=0
    let g:gruvbox_invert_selection = 0
    set background=dark
    silent! colorscheme gruvbox                           " silent to suppress error before plugin installed
    let g:lightline={'colorscheme': 'gruvbox'}
    let g:lightline.inactive = {
        \'left': [['filename', 'modified']],
        \'right': [['lineinfo'], ['percent']] 
    \}
    call EnableLightline()
    highlight IndentGuidesOdd ctermfg=245 ctermbg=237 guifg=#928374 guibg=#3c3836
    highlight IndentGuidesEven ctermfg=245 ctermbg=237 guifg=#928374 guibg=#3c3836
    highlight MatchParen term=bold,underline cterm=bold,underline ctermbg=234 ctermfg=14 gui=bold,underline guibg=#1d2021 guifg=#91fff8
    highlight String ctermfg=175 guifg=#d3869b
    highlight SignColumn ctermfg=223 ctermbg=235 guifg=#ebdbb2 guibg=#282828
    highlight VertSplit cterm=reverse ctermfg=237 ctermbg=237 gui=reverse guifg=#3c3836 guibg=#3c3836
    let g:indent_guides_auto_colors = 0
    let g:indent_guides_start_level = 2
    let g:indent_guides_guide_size = 1
    call EnableIndentLines()
    call winrestview(l:win_view)
endfunction

function! WriteToPdf() abort
    let current_dir = escape(expand("%:p:h"), ' ') . ";"
    let listings_file = findfile(".listings-setup.tex", current_dir)
    exe '!pandoc "%:p" --listings -H "' . listings_file . '" -o "%:p:r.pdf" -V geometry:margin=1in'
endfunction

function! EnableWritingMode() abort
    let g:writingmode=1
    call LoadColors()
    set background=light
    set syntax=off
    set spell
    set noshowmode
    set noshowcmd
    set nocursorline
    let b:coc_suggest_disable = 1
    set nonumber
    set nolist
    call DisableIndentLines()
    call DisableLightline()
    Goyo 80x85%
    set showbreak=
    Limelight
    cabbrev  q   :WritingModeOff<CR>:q<CR>:WritingModeOn<CR>
    cabbrev  qa  :WritingModeOff<CR>:qa<CR>:WritingModeOn<CR>
    nnoremap ZQ  :WritingModeOff<CR>ZQ:WritingModeOn<CR>
    cabbrev  wq  :WritingModeOff<CR>:wq<CR>:WritingModeOn<CR>
    cabbrev  x   :WritingModeOff<CR>:x<CR>:WritingModeOn<CR>
    nnoremap ZZ  :WritingModeOff<CR>ZZ:WritingModeOn<CR>
    cabbrev  wqa :WritingModeOff<CR>:wqa<CR>:WritingModeOn<CR>
    cabbrev  xa  :WritingModeOff<CR>:xa<CR>:WritingModeOn<CR>
endfunction

function! DisableWritingMode() abort
    let g:writingmode=0
    Limelight!
    Goyo!
    set showcmd&
    set nocursorline&
    set spell&
    call LoadColors()
    let b:coc_suggest_disable = 0
    cunabbrev q
    cunabbrev qa
    nunmap    ZQ
    cunabbrev wq
    cunabbrev x
    nunmap    ZZ
    cunabbrev wqa
    cunabbrev xa
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
    execute a:mode.'map '.a:mapping.' '.a:rhs
    execute a:mode.'map '.a:mapping.a:mapping[-1:].' '.a:rhs
    execute a:mode.'map '.a:mapping.'h :aboveleft vsplit<CR>'.a:rhs
    execute a:mode.'map '.a:mapping.'l :belowright vsplit<CR>'.a:rhs
    execute a:mode.'map '.a:mapping.'j :belowright split<CR>'.a:rhs
    execute a:mode.'map '.a:mapping.'k :aboveleft split<CR>'.a:rhs
endfunction
