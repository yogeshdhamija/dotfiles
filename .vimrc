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
            \ ['joshdick/onedark.vim', {}],
            \ ['vim-airline/vim-airline', {}],
            \ ['vim-airline/vim-airline-themes', {}],
            \ ['lukas-reineke/indent-blankline.nvim', {}],
        \ ]
        let embed_to_other_apps_plugins = [
        \ ]
        let plugins = vim_idiomatic_plugins + interface_convenience_plugins + ide_like_functionality_plugins + language_plugins + visual_plugins
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
    let g:peekaboo_window="call CreateCenteredFloatingWindow()"

" Colorscheme
    set background=dark
    silent! colorscheme onedark
    set number
    set scl=yes
    set foldmethod=indent
    set foldlevelstart=99
    tabdo windo set foldtext=CustomFoldText()
    tabdo windo set fillchars=fold:\ 
    set laststatus=2
    highlight MatchParen term=bold,underline cterm=bold,underline ctermbg=234 ctermfg=14 gui=bold,underline guibg=#1d2021 guifg=#91fff8

" Remaps
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
        nnoremap \c <Esc>:noh<CR>
    " Remap Control+C in visual mode to copy to system clipboard (and Command+C for some terminals)
        vnoremap <C-c> "+y
        vnoremap <D-c> "+y
    " Remap Ctrl+V in visual mode to paste from system clipboard (and Command+C for some terminals)
        vnoremap <C-v> "+p
        vnoremap <D-v> "+p
    " \t -> Terminal window
        " Note: <Esc> will not move to normal mode in terminal. Use <C-\><C-N>.
        if has('nvim')
            call CreateSplitMappings("nnore", "\\t", ":terminal<CR>:startinsert<CR>")
        else
            call CreateSplitMappings("nnore", "\\t", ":terminal ++curwin<CR>")
        endif
    " \d -> Directory listing
        call CreateSplitMappings("n", "\\d", "-")
    " \o -> Open
        nnoremap \o :Files<CR>
    " \b -> list Buffers
        nnoremap \b :Buffers<CR>
    " \w -> list Windows
        nnoremap \w :Windows<CR>
    " \a -> code Action
        nnoremap \a :Actions<CR>
        vnoremap \a :'<,'>Actions<CR>
    " \gd -> Goto Definition
        call CreateSplitMappings("nnore", "\\gd", ":call CocActionAsync('jumpDefinition')<CR>")
    " \gr -> Goto References
        call CreateSplitMappings("nnore", "\\gr", ":call CocActionAsync('jumpReferences')<CR>")
    " \h -> Help
        nnoremap \h :call CocActionAsync("doHover") \| call CocActionAsync("showSignatureHelp")<CR>
        inoremap \h <C-O>:call CocActionAsync("doHover") \| call CocActionAsync("showSignatureHelp")<CR>

" Commands
    " Capital ":only" command
        command! Only only
        command! ONLY Only
    " DelMarks -> Delete all Marks
        command! DelMarks delmarks a-zA-Z0-9
        command! DELMARKS DelMarks
    " CD -> Change Directory to current open file
        command! CD silent cd %:p:h | redraw! | echo ":cd %:p:h" 
    " CP -> Copy absolute filePath to + register (system clipboard)
        command! CP let @+ = expand("%:p") | redraw! | echo ":let @+ = expand('%:p')" 
    " Command to save and generate .pdf from .md
        command! PDF w | call WriteToPdf()
    " Git stuff
        command! -nargs=? GITLOG Git log --graph --oneline --pretty=format:'%h -%d %s (%cs) <%an>' <args>
        command! GITHISTORY BCommits

        command! GHISTORY GITHISTORY
        command! -nargs=? GLOG GITLOG <args>
    " Often used LSP stuff
        command! -range Actions <line1>,<line2>CocAction
        command! -range ACTIONS <line1>,<line2>Actions

        command! Rename call CocActionAsync("rename")
        command! RENAME Rename

        command! -range=% Format <line1>mark < | <line2>mark > | call CocAction("formatSelected", "V")
        command! -range=% FORMAT <line1>,<line2>Format

        command! Error call CocActionAsync("diagnosticInfo")
        command! Errors CocList --normal diagnostics
        command! ERRORS Errors
        command! ERROR Error
        command! ERRS Errors
        command! ERR Error

call SourceFileIfExists(".vim/vimrc.local")
call SourceFileIfExists("~/.vimrc.local")
