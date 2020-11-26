source ~/.config/vim/functions.vim

call SourceFileIfExists("~/.vimrc.local.loadbefore")

" Plugins
    if !exists("plugins")
        let vim_idiomatic_plugins = [
            \ ['yogeshdhamija/uss-asterisk.vim', {}],
            \ ['tpope/vim-repeat', {}],
            \ ['tpope/vim-surround', {}],
            \ ['tpope/vim-abolish', {}],
            \ ['michaeljsmith/vim-indent-object', {}],
            \ ['junegunn/vim-easy-align', {}],
        \ ]
        let interface_convenience_plugins = [
            \ ['ydhamija96/uss-find.vim', {}],
            \ ['ydhamija96/uss-mouse.vim', {}],
            \ ['ydhamija96/uss-clean-buffers.vim', {}],
        \ ]
        let ide_like_functionality_plugins = [
            \ ['tpope/vim-commentary', {}],
            \ ['ydhamija96/uss-sessions.vim', {}],
            \ ['tpope/vim-fugitive', {}],
            \ ['tpope/vim-rhubarb', {}],
            \ ['junegunn/fzf', {}],
            \ ['junegunn/fzf.vim', {}],
            \ ['justinmk/vim-dirvish', {}],
            \ ['editorconfig/editorconfig-vim', {}],
        \ ]
        let language_plugins = [
            \ ['neoclide/coc.nvim', {'branch': 'release'}],
            \ ['leafgarland/typescript-vim', {}],
            \ ['peitalin/vim-jsx-typescript', {}],
            \ ['uiiaoo/java-syntax.vim', {}]
        \ ]
        let visual_plugins = [
            \ ['junegunn/goyo.vim', {}],
            \ ['junegunn/limelight.vim', {}],
            \ ['morhetz/gruvbox', {}],
            \ ['nathanaelkane/vim-indent-guides', {}],
            \ ['itchyny/lightline.vim', {}],
            \ ['mhinz/vim-signify', {}],
        \ ]
        if(!exists('g:vscode'))
            let plugins = vim_idiomatic_plugins + interface_convenience_plugins + ide_like_functionality_plugins + language_plugins + visual_plugins
        else
            let plugins = vim_idiomatic_plugins
        endif
    endif
    if !exists("disabled_plugins")
        let disabled_plugins = []
    endif
    if exists("added_plugins")
        let plugins = plugins + added_plugins
    endif
    call InstallPlugins(plugins, disabled_plugins)

    if !exists("coc_plugins")
        let coc_plugins = [
            \ 'coc-marketplace', 
            \ 'coc-vimlsp', 
            \ 'coc-json', 
            \ 'coc-yaml',
            \ 'coc-tsserver',
            \ 'coc-java',
            \ 'coc-phpls'
        \ ]
    endif
    if exists("added_coc_plugins")
        let coc_plugins = coc_plugins + added_coc_plugins
    endif
    let g:coc_global_extensions = coc_plugins

" General Settings
    set mouse=a
    set ignorecase
    set linebreak
    set hlsearch
    set autoread
    set splitbelow
    set splitright
    let g:easy_align_ignore_groups=[]
    set tabstop=4
    set shiftwidth=4
    set expandtab
    set undofile
    set undodir=~/.vim/undodir
    set nomodeline
    if executable('rg')
        set grepprg=rg\ --follow\ --vimgrep\ --no-heading\ --no-ignore-vcs\ --hidden
    elseif executable('ag')
        set grepprg=ag\ --follow\ --vimgrep\ --noheading\ --skip-vcs-ignores\ --hidden
    else
        set grepprg=grep\ -nR
    endif
    call EnableJumpToLastPositionWhenReOpeningFile()
    set hidden
    let g:dirvish_mode = 2
    let g:dirvish_relative_paths = 1
    if DetectWsl()
        call SetClipboardForWslTerminal()
    endif
    if(!exists("g:vscode"))
        call LoadColors()
    endif
    let g:indent_guides_enable_on_vim_startup = 1
    if !has('nvim')
        if exists('+termwinkey')
            set termwinkey=<C-\-n>
        else
            set termkey=<C-\-n>
        endif
    endif
    set updatetime=300
    autocmd CursorHold * silent! call CocActionAsync('highlight')

" Remaps
    " Get folding working with vscode neovim plugin
    if(exists("g:vscode"))
        nnoremap zM :call VSCodeNotify('editor.foldAll')<CR>
        nnoremap zR :call VSCodeNotify('editor.unfoldAll')<CR>
        nnoremap zc :call VSCodeNotify('editor.fold')<CR>
        nnoremap zC :call VSCodeNotify('editor.foldRecursively')<CR>
        nnoremap zo :call VSCodeNotify('editor.unfold')<CR>
        nnoremap zO :call VSCodeNotify('editor.unfoldRecursively')<CR>
        nnoremap za :call VSCodeNotify('editor.toggleFold')<CR>
        nmap j gj
        nmap k gk
    endif
    "Get navigating marks working with vscode neovim plugin
        " (also relies on VSCode Bookmarks plugin)
    if(exists("g:vscode"))
        nnoremap m v<Esc>:call ExecuteVSCodeCommandInVisualMode('bookmarks.toggleLabeled')<CR><Esc>
        nnoremap ` :call VSCodeNotify('bookmarks.listFromAllFiles')<CR>
    endif
    "Add commenting to vscode neovim plugin
        if(exists("g:vscode"))
            xmap gc  <Plug>VSCodeCommentary
            nmap gc  <Plug>VSCodeCommentary
            omap gc  <Plug>VSCodeCommentary
            nmap gcc <Plug>VSCodeCommentaryLine
        endif

    " Directory tree settings
        augroup dirvish_config
            autocmd!
            " Remove q remap
            autocmd FileType dirvish silent! unmap <buffer> q
            " Improve preview
            autocmd FileType dirvish
                        \ nnoremap <silent><buffer> t ddO<Esc>:let @"=substitute(@", '\n', '', 'g')<CR>:r ! find "<C-R>"" -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d<CR>:noh<CR>
        augroup END
    " Start interactive EasyAlign in visual mode (e.g. vipga)
        xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
        nmap ga <Plug>(EasyAlign)
    " Make pasting from clipboard safer
        inoremap <C-R> <C-R><C-O>
    " \c -> Clear highlights
        if(exists('g:vscode'))
            nnoremap \c <Esc>:noh<CR>:call VSCodeNotify("workbench.action.closeSidebar")<CR>:call VSCodeNotify("workbench.action.closePanel")<CR>:call VSCodeNotify("notifications.hideToasts")<CR>
        else
            nnoremap \c <Esc>:noh<CR>
        endif
    " Remap Control+C in visual mode to copy to system clipboard (and Command+C for some terminals)
        vnoremap <C-c> "+y
        vnoremap <D-c> "+y
    " Remap Ctrl+V in visual mode to paste from system clipboard (and Command+C for some terminals)
        vnoremap <C-v> "+p
        vnoremap <D-v> "+p
    " \t -> Terminal window
        " \th -> Terminal window, left (aka h)
        " \tj -> Terminal window, down (aka j)
        " \tk -> Terminal window, up (aka k)
        " \tl -> Terminal window, right (aka l)
        " Note: <Esc> will not move to normal mode in terminal. Use <C-\><C-N>.
        if exists('g:vscode')
            nnoremap \t :call VSCodeNotify("terminal.focus")<CR>
        elseif has('nvim')
            call CreateSplitMappings("nnore", "\\t", ":terminal<CR>:startinsert<CR>")
        else
            call CreateSplitMappings("nnore", "\\t", ":terminal ++curwin<CR>")
        endif
    " \d -> Directory listing
        if(exists('g:vscode'))
            nnoremap \d :call VSCodeNotify("workbench.files.action.showActiveFileInExplorer")<CR>
        else
            call CreateSplitMappings("n", "\\d", "-")
        endif
    " \f -> Find
        if(exists("g:vscode"))
            nnoremap \f :call VSCodeNotify("workbench.action.findInFiles")<CR>
        else
            " functionality provided by plugin
        endif
    " \o -> Open
        if(exists('g:vscode'))
            nnoremap \o :call VSCodeNotify("workbench.action.quickOpen")<CR>
        else
            nnoremap \o :FZF<CR>
        endif
    " \b -> list Buffers
        if(exists('g:vscode'))
            nnoremap \b :call VSCodeNotify("workbench.action.openPreviousEditorFromHistory")<CR>
        else
            nnoremap \b :Buffers<CR>
        endif
    " \w -> list Windows
        if(exists('g:vscode'))
            nnoremap \w :call VSCodeNotify("workbench.files.action.focusOpenEditorsView")<CR>
        else
            nnoremap \w :Windows<CR>
        endif
    " \a -> code Action
        if(exists('g:vscode'))
            nmap \a :call VSCodeNotify("workbench.action.showCommands")<CR>
            vmap \a :call ExecuteVSCodeCommandInVisualMode("workbench.action.showCommands")<CR><Esc>
        else
            nnoremap \a :Actions<CR>
            vnoremap \a :'<,'>Actions<CR>
        endif
    " \gd -> Goto Definition
        if(exists('g:vscode'))
            nnoremap \gd :call VSCodeNotify('editor.action.revealDefinition')<CR>
        else
            call CreateSplitMappings("nnore", "\\gd", ":call CocActionAsync('jumpDefinition')<CR>")
        endif
    " \gr -> Goto References
        if(exists('g:vscode'))
            nnoremap \gr :call VSCodeNotify('editor.action.goToReferences')<CR>
        else
            call CreateSplitMappings("nnore", "\\gr", ":call CocActionAsync('jumpReferences')<CR>")
        endif
    " \h -> Help
        if(exists('g:vscode'))
            nnoremap \h :call VSCodeNotify('editor.action.showHover')<CR>
        else
            nnoremap \h :call CocActionAsync("doHover") \| call CocActionAsync("showSignatureHelp")<CR>
            inoremap \h <C-O>:call CocActionAsync("doHover") \| call CocActionAsync("showSignatureHelp")<CR>
        endif

" Commands
    " Vscode-specific ":only" command
        if(exists("g:vscode"))
            command! Only call VSCodeNotify("workbench.action.closeSidebar") | call VSCodeNotify("workbench.action.closePanel") | call VSCodeNotify("workbench.action.closeEditorsInOtherGroups")
        else
            command! Only only
        endif
        command! ON Only
    " DM -> Delete all Marks
        if(exists("g:vscode"))
            command! DM call VSCodeNotify("bookmarks.clearFromAllFiles")
        else
            command! DM delmarks a-zA-Z0-9
        endif
    " CD -> Change Directory to current open file
        if(!exists("g:vscode"))
            command! CD silent cd %:p:h | redraw! | echo ":cd %:p:h" 
        endif
    " CP -> Copy absolute filePath to + register (system clipboard)
        if(!exists("g:vscode"))
            command! CP let @+ = expand("%:p") | redraw! | echo ":let @+ = expand('%:p')" 
        endif
    " Writing Mode for distraction free editing
        if(!exists("g:vscode"))
            command! WritingModeOn call EnableWritingMode()
            command! WritingModeOff call DisableWritingMode()
        endif
    " Colorscheme on/off
        if(!exists("g:vscode"))
            command! ColorSchemeOn call LoadColors()
            command! ColorSchemeOff call UnloadColors()
        endif
    " Command to save and generate .pdf from .md
        if(!exists("g:vscode"))
            command! PDF w | call WriteToPdf()
        endif
    " Command to close other editors
        if(exists("g:vscode"))
            command! CloseHiddenBuffers call VSCodeNotify("workbench.action.clearEditorHistory") | call VSCodeNotify("workbench.action.splitEditor") | call VSCodeNotify("workbench.action.closeActiveEditor") |
                \ call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup") | call VSCodeNotify("workbench.action.focusNextGroup")
            command! CLO CloseHiddenBuffers
        else
            " provided by plugin
        endif
    " Often used LSP stuff
        if(exists("g:vscode"))
            command! Actions call VSCodeNotify("workbench.action.showCommands")
            command! ACT Actions
        else
            command! -range Actions <line1>,<line2>CocAction
            command! -range ACT <line1>,<line2>Actions
        endif

        if(exists("g:vscode"))
            command! Rename call VSCodeNotify('editor.action.rename')
        else
            command! Rename call CocActionAsync("rename")
        endif
        command! REN Rename

        if(exists("g:vscode"))
            command! Format call VSCodeNotify('editor.action.formatDocument')
            command! FOR Format
        else
            command! -range=% Format <line1>mark < | <line2>mark > | call CocAction("formatSelected", "V")
            command! -range=% FOR <line1>,<line2>Format
        endif

        if(exists("g:vscode"))
            command! Errors call VSCodeNotify("workbench.actions.view.problems")
            command! ERRS Errors
        else
            command! Error call CocActionAsync("diagnosticInfo")
            command! Errors CocList --normal diagnostics
            command! ERRS Errors
            command! ERR Error
        endif

call SourceFileIfExists("~/.vimrc.local")
