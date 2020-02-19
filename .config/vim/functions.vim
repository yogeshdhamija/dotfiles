function! SourceFileIfExists(filepath) abort
    try
        execute "source " . a:filepath
    catch
    endtry
endfunction

function! InstallCocPlugins(info) abort
    if executable("yarn") && executable("node")
        if a:info.status == 'installed' || a:info.force
            let s:extensions = ['coc-marketplace', 'coc-vimlsp', 'coc-gocode', 'coc-json', 'coc-python', 'coc-pyls', 'coc-tsserver']
            call coc#util#install()
            call coc#util#install_extension(s:extensions)
        endif
    endif
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
        tabdo windo IndentLinesEnable
    endif
    let g:indentLine_enabled=1
endfunction

function! DisableIndentLines() abort
    if v:vim_did_enter
        tabdo windo IndentLinesDisable
    endif
    let g:indentLine_enabled=0
endfunction

function! DisableLightline() abort
    if v:vim_did_enter
        call lightline#disable()
    endif
    augroup lightline_augroup
        autocmd!
        autocmd VimEnter * call lightline#disable()
    augroup END
endfunction

function! EnableLightline() abort
    if v:vim_did_enter
        call lightline#enable()
    endif
    augroup lightline_augroup
        autocmd!
        autocmd VimEnter * call lightline#enable()
    augroup END
endfunction

function! UnloadColors() abort
    tabdo windo set number&
    tabdo windo set signcolumn&
    syntax on
    if has('nvim')
        set inccommand&
    endif
    tabdo windo set wrap&
    tabdo windo set breakindent&
    set showbreak&
    tabdo windo set list&
    set showmode&
    if(!exists("g:writingmode") || g:writingmode != 1)
        let $NVIM_TUI_ENABLE_TRUE_COLOR=0                 " enable true color for nvim < 1.5 (I think)
        set notermguicolors
        colorscheme default
        set background=dark
    endif
    call DisableLightline()
    call DisableIndentLines()
endfunction







