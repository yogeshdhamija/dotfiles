source ~/.config/vim/functions.vim

call SourceFileIfExists("~/.vimrc.local.loadbefore")
call SourceFileIfExists(".vim/vimrc.local.loadbefore")

" Plugins
    if !exists("plugins")
        let vim_idiomatic_plugins = [
            \ ['yogeshdhamija/better-asterisk-remap.vim', {}],
            \ ['tpope/vim-repeat', {}],
            \ ['tpope/vim-surround', {}],
            \ ['tpope/vim-abolish', {}],
            \ ['michaeljsmith/vim-indent-object', {}],
            \ ['junegunn/vim-easy-align', {}],
            \ ['yogeshdhamija/find-in-dir-helper.vim', {}],
            \ ['yogeshdhamija/filter-lq-list.vim', {}],
            \ ['yogeshdhamija/close-hidden-buffers-command.vim', {}],
        \ ]
        let interface_convenience_plugins = [
            \ ['yogeshdhamija/enter-insert-on-click.vim', {}],
            \ ['junegunn/vim-peekaboo', {}],
            \ ['kshenoy/vim-signature', {}],
        \ ]
        let ide_like_functionality_plugins = [
            \ ['tpope/vim-commentary', {}],
            \ ['yogeshdhamija/save-sessions-per-directory.vim', {}],
            \ ['tpope/vim-fugitive', {}],
            \ ['tpope/vim-rhubarb', {}],
            \ ['junegunn/fzf', { 'do': { -> fzf#install() } }],
            \ ['junegunn/fzf.vim', {}],
            \ ['justinmk/vim-dirvish', {}],
            \ ['editorconfig/editorconfig-vim', {}],
        \ ]
        let language_plugins = [
            \ ['neoclide/coc.nvim', {'branch': 'release'}],
            \ ['sheerun/vim-polyglot', {}],
        \ ]
        let visual_plugins = [
            \ ['mhinz/vim-signify', {}],
            \ ["NLKNguyen/papercolor-theme", {}],
            \ ["nathanaelkane/vim-indent-guides", {}],
        \ ]
        let embed_to_other_apps_plugins = [
        \ ]
        if(!exists('g:vscode'))
            let plugins = vim_idiomatic_plugins + interface_convenience_plugins + ide_like_functionality_plugins + language_plugins + visual_plugins
        else
            let plugins = vim_idiomatic_plugins
        endif
        if(has('nvim'))
            let plugins = plugins + embed_to_other_apps_plugins
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
            \ 'coc-eslint',
            \ 'coc-apollo',
            \ 'coc-emmet'
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
        set grepprg=rg\ --follow\ --vimgrep\ --no-heading
    elseif executable('ag')
        set grepprg=ag\ --follow\ --vimgrep\ --noheading
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
    if !has('nvim')
        if exists('+termwinkey')
            set termwinkey=<C-\-n>
        else
            set termkey=<C-\-n>
        endif
    endif
    set updatetime=300
    autocmd CursorHold * silent! call CocActionAsync('highlight')
    let g:peekaboo_window="split new"

" Colorscheme
    if(!exists('g:vscode'))
        set background=light
        silent! colorscheme PaperColor
        set number
        set scl=yes
        set foldmethod=indent
        set foldlevelstart=99
        tabdo windo set foldtext=CustomFoldText()
        tabdo windo set fillchars=fold:\ 

        hi CocErrorSign  ctermfg=Red guifg=#ff0000
        hi CocWarningSign  ctermfg=Brown guifg=#ff922b
        hi CocInfoSign  ctermfg=Black guifg=#fab005

        set listchars=tab:\|\ 
        set list
        let g:indent_guides_enable_on_vim_startup = 1
        let g:indent_guides_auto_colors = 0
        autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#dfdfdf ctermbg=254
        autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#dfdfdf ctermbg=254
        let g:indent_guides_guide_size = 1
        let g:indent_guides_tab_guides = 0

        set laststatus=2
    endif

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
    " Map vim's spellcheck to quickfix list in VSCode
        if(exists('g:vscode'))
            nnoremap z= <Cmd>call VSCodeNotify("editor.action.quickFix")<CR>
            xnoremap z= <Cmd>call ExecuteVSCodeCommandInVisualMode("editor.action.quickFix")<CR>
        endif
    "Get navigating marks working with vscode neovim plugin
        " (also relies on VSCode Bookmarks plugin)
    if(exists("g:vscode"))
        nnoremap m v<Esc>:call ExecuteVSCodeCommandInVisualMode('bookmarks.toggleLabeled')<CR><Esc>
        nnoremap ` :call VSCodeNotify('bookmarks.listFromAllFiles')<CR>
    endif
    " Remove vscode neovim plugin's <C-W><C-H> mappings
    if(exists("g:vscode"))
        map <C-W><C-H> <C-W>h
        map <C-W><C-J> <C-W>j
        map <C-W><C-K> <C-W>k
        map <C-W><C-L> <C-W>l
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
            nnoremap \c <Esc>:noh<CR>:call VSCodeNotify("workbench.action.closeSidebar")<CR>:call VSCodeNotify("workbench.action.closePanel")<CR>:call VSCodeNotify("notifications.hideToasts")<CR>:call VSCodeNotify("closeParameterHints")<CR>
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
        " Note: <Esc> will not move to normal mode in terminal. Use <C-\><C-N>.
        if exists('g:vscode')
            nnoremap \tj :call VSCodeNotify("terminal.focus")<CR>
            nnoremap \tv :call VSCodeNotify("workbench.action.terminal.split")<CR>
            nnoremap \ts :call VSCodeNotify("workbench.action.terminal.new")<CR>
            nnoremap \t1 :call VSCodeNotify("workbench.action.terminal.focusAtIndex1")<CR>
            nnoremap \t2 :call VSCodeNotify("workbench.action.terminal.focusAtIndex2")<CR>
            nnoremap \t3 :call VSCodeNotify("workbench.action.terminal.focusAtIndex3")<CR>
            nnoremap \t4 :call VSCodeNotify("workbench.action.terminal.focusAtIndex4")<CR>
            nnoremap \t5 :call VSCodeNotify("workbench.action.terminal.focusAtIndex5")<CR>
            nnoremap \t6 :call VSCodeNotify("workbench.action.terminal.focusAtIndex6")<CR>
            nnoremap \t7 :call VSCodeNotify("workbench.action.terminal.focusAtIndex7")<CR>
            nnoremap \t8 :call VSCodeNotify("workbench.action.terminal.focusAtIndex8")<CR>
            nnoremap \t9 :call VSCodeNotify("workbench.action.terminal.focusAtIndex9")<CR>
        elseif has('nvim')
            call CreateSplitMappings("nnore", "\\t", ":terminal<CR>:startinsert<CR>")
        else
            call CreateSplitMappings("nnore", "\\t", ":terminal ++curwin<CR>")
        endif
    " \d -> Directory listing
        if(exists('g:vscode'))
            nnoremap \dh :call VSCodeNotify("workbench.files.action.showActiveFileInExplorer")<CR>
        else
            call CreateSplitMappings("n", "\\d", "-")
        endif
    " \o -> Open
        if(exists('g:vscode'))
            nnoremap \o :call VSCodeNotify("workbench.action.quickOpen")<CR>
        else
            nnoremap \o :Files<CR>
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
            nnoremap \a <Cmd>call VSCodeNotify("workbench.action.showCommands")<CR>
            xnoremap \a <Cmd>call ExecuteVSCodeCommandInVisualMode("workbench.action.showCommands")<CR>
        else
            nnoremap \a :Actions<CR>
            vnoremap \a :'<,'>Actions<CR>
        endif
    " \gd -> Goto Definition
        if(exists('g:vscode'))
            nnoremap \gd :call VSCodeNotify('editor.action.revealDefinition')<CR>
            nnoremap \gdd :call VSCodeNotify('editor.action.revealDefinition')<CR>
            nnoremap \gdl :call VSCodeNotify('editor.action.revealDefinitionAside')<CR>
        else
            call CreateSplitMappings("nnore", "\\gd", ":call CocActionAsync('jumpDefinition')<CR>")
        endif
    " \gr -> Goto References
        if(exists('g:vscode'))
            nnoremap \gr :call VSCodeNotify('editor.action.goToReferences')<CR>
            nnoremap \grr :call VSCodeNotify('editor.action.goToReferences')<CR>
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
        command! ONLY Only
    " DelMarks -> Delete all Marks
        if(exists("g:vscode"))
            command! DelMarks call VSCodeNotify("bookmarks.clearFromAllFiles")
        else
            command! DelMarks delmarks a-zA-Z0-9
        endif
        command! DELMARKS DelMarks
    " CD -> Change Directory to current open file
        if(!exists("g:vscode"))
            command! CD silent cd %:p:h | redraw! | echo ":cd %:p:h" 
        endif
    " CP -> Copy absolute filePath to + register (system clipboard)
        if(!exists("g:vscode"))
            command! CP let @+ = expand("%:p") | redraw! | echo ":let @+ = expand('%:p')" 
        endif
    " Command to save and generate .pdf from .md
        if(!exists("g:vscode"))
            command! PDF w | call WriteToPdf()
        endif
    " Git stuff
        command! -nargs=? GITLOG Git log --graph --oneline --pretty=format:'%h -%d %s (%cs) <%an>' <args>
        command! GITHISTORY BCommits

        command! GHISTORY GITHISTORY
        command! -nargs=? GLOG GITLOG <args>
    " Often used LSP stuff
        if(exists("g:vscode"))
            command! Actions call VSCodeNotify("workbench.action.showCommands")
            command! ACTIONS Actions
        else
            command! -range Actions <line1>,<line2>CocAction
            command! -range ACTIONS <line1>,<line2>Actions
        endif

        if(exists("g:vscode"))
            command! Rename call VSCodeNotify('editor.action.rename')
        else
            command! Rename call CocActionAsync("rename")
        endif
        command! RENAME Rename

        if(exists("g:vscode"))
            command! Format call VSCodeNotify('editor.action.formatDocument')
            command! FORMAT Format
        else
            command! -range=% Format <line1>mark < | <line2>mark > | call CocAction("formatSelected", "V")
            command! -range=% FORMAT <line1>,<line2>Format
        endif

        if(exists("g:vscode"))
            command! Errors call VSCodeNotify("workbench.actions.view.problems")
            command! Error Errors
        else
            command! Error call CocActionAsync("diagnosticInfo")
            command! Errors CocList --normal diagnostics
        endif
        command! ERRORS Errors
        command! ERROR Error
        command! ERRS Errors
        command! ERR Error

call SourceFileIfExists(".vim/vimrc.local")
call SourceFileIfExists("~/.vimrc.local")
