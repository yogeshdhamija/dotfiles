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
    let l:win_view = winsaveview()
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
    call winrestview(l:win_view)
endfunction

function! LoadColors() abort
    let l:win_view = winsaveview()
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    if (DetectUbuntu() || DetectIterm() || DetectWsl())
        set termguicolors
    endif
    tabdo windo set number
    tabdo windo set signcolumn=yes
    syntax on
    tabdo windo set wrap
    tabdo windo set breakindent
    set listchars=tab:\|\ ,eol:$
    tabdo windo set list
    set noshowmode
    set showbreak=>>>\ 
    let g:indentLine_showFirstIndentLevel=1
    " Indentline conflicts with some other concealed characters.
    " Workaround: conceal nothing on cursor line
    let g:indentLine_concealcursor=''
    if has('nvim')
        autocmd TermOpen * setlocal nolist
        autocmd TermOpen * IndentLinesDisable
        set inccommand=nosplit
    endif
    autocmd FileType json IndentLinesDisable
    silent! colorscheme one                           " silent to suppress error before plugin installed
    let g:lightline={'colorscheme': 'one'}
    set background=dark
    call EnableLightline()
    highlight Comment guifg=#6C7380
    highlight NonText guifg=#424956
    highlight Normal ctermfg=145 ctermbg=16 guifg=#abb2bf guibg=#20242C
    highlight Pmenu ctermfg=145 ctermbg=16 guifg=#abb2bf guibg=#20242C
    highlight PmenuSel ctermbg=39 ctermfg=59 guibg=#61AFEF guifg=#5C6370
    call EnableIndentLines()
    call winrestview(l:win_view)
endfunction

function! DisplayHelpAndSearch() abort
    let helptext = ":set grepprg?\n    grepprg=".&grepprg."\n:pwd\n    ".getcwd()."\n\n"
    call inputsave()
    let searchstring = input(helptext . ":copen | silent grep! ")
    call inputrestore()
    if(len(searchstring) > 0)
        exec "copen"
        exec "silent grep! " . searchstring
    endif
endfunction

function! WriteToPdf() abort
    let current_dir = escape(expand("%:p:h"), ' ') . ";"
    let listings_file = findfile(".listings-setup.tex", current_dir)
    exe '!pandoc "%:p" --listings -H "' . listings_file . '" -o "%:p:r.pdf" -V geometry:margin=1in'
endfunction

function! EnterInsertAfterCursor() abort
    if col('.') == col('$') - 1
        startinsert!
    else
        startinsert
    endif
endfunction

function! EnterInsertIfFileOrIfBottomOfTerminal() abort
    if ( getbufvar(bufname("%"), "&buftype", "NONE") != "terminal" ) 
                \ || (line('w$') >= line('$'))
        call EnterInsertAfterCursor()
    endif
endfunction

function! DeleteHiddenBuffers() abort
    let tpbl=[]
    let closed = 0
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        if getbufvar(buf, '&mod') == 0
            silent execute 'bwipeout!' buf
            let closed += 1
        endif
    endfor
    echo "Closed ".closed." hidden buffers"
endfunction

function! LoadSessionIfVimNotLaunchedWithArgs() abort
    if argc() == 0 && !exists("s:std_in")
        if filereadable(expand('~/.vim/lastsession.vim'))
            execute 'silent source ~/.vim/lastsession.vim'
            let g:should_save_session = 1
        endif
    else
        let g:should_save_session = 0
    endif
endfunction

function! SaveSessionIfFlagSet() abort
  if g:should_save_session == 1
    let sessionoptions = &sessionoptions
    try
        set sessionoptions-=options
        set sessionoptions+=tabpages
        execute 'mksession! ~/.vim/lastsession.vim'
    finally
        let &sessionoptions = sessionoptions
    endtry
  endif
endfunction











