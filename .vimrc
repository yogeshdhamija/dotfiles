source ~/.config/vim/functions.vim

call SourceFileIfExists("~/.vimrc.local.loadbefore")

" Plugins
    if !exists("plugins")
        let convenience_plugins = [
            \ ['ydhamija96/uss-find.vim', {}],
            \ ['ydhamija96/uss-mouse.vim', {}],
            \ ['ydhamija96/uss-clean-buffers.vim', {}],
            \ ['ydhamija96/uss-asterisk.vim', {}],
            \ ['tpope/vim-repeat', {}],
            \ ['tpope/vim-commentary', {}],
            \ ['tpope/vim-surround', {}],
            \ ['tpope/vim-abolish', {}],
            \ ['michaeljsmith/vim-indent-object', {}],
            \ ['junegunn/vim-easy-align', {}],
        \ ]
        let functionality_plugins = [
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
        let nvim_only_plugins = [
            \ ['kvngvikram/rightclick-macros', {}],
        \ ]
        let plugins = convenience_plugins + functionality_plugins + language_plugins + visual_plugins
        if (has('nvim'))
            let plugins = plugins + nvim_only_plugins
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
    call LoadColors()
    let g:indent_guides_enable_on_vim_startup = 1
    if !has('nvim')
        if exists('+termwinkey')
            set termwinkey=<C-\-n>
        else
            set termkey=<C-\-n>
        endif
    endif
    set updatetime=300
    autocmd CursorHold * silent call CocActionAsync('highlight')
    " kvngvikram/rightclick-macros
        let g:rightclick_normal_items    = ['undo',     'redo',    'paste (+)']
        let g:rightclick_normal_macros   = ['u',        '',      '"+p'    ]
        let g:rightclick_visual_items    = ['copy (+)', 'cut (+)', 'paste (+)']
        let g:rightclick_visual_macros   = ['"+y',      '"+d',     '"+p'    ]

" Remaps
    " kvngvikram/rightclick-macros
        if(has('nvim'))
            let g:rightclick_default_mappings = 0
            nnoremap <silent> <RightMouse> <LeftMouse>:call Rightclick_normal()<CR>
            inoremap <silent> <RightMouse> <Esc>:call Rightclick_normal()<CR>
            vnoremap <silent> <RightMouse> <LeftMouse>:call Rightclick_visual()<CR>
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
    " Pressing <Esc> in normal mode removes search highlights
        " augroup because of vim issue https://github.com/vim/vim/issues/3080
        " Note: remapping on every yank might cause lag
        augroup escape_mapping
            autocmd!
            autocmd TextYankPost * nnoremap <Esc> <Esc>:noh<CR>
        augroup END
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
        if has('nvim')
            call CreateSplitMappings("nnore", "\\t", ":terminal<CR>:startinsert<CR>")
        else
            call CreateSplitMappings("nnore", "\\t", ":terminal ++curwin<CR>")
        endif
    " \d -> Directory listing
        call CreateSplitMappings("n", "\\d", "-")
    " \o -> Open
        nnoremap \o :FZF<CR>
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
    " CD -> Change Directory to current open file
        command! CD silent cd %:p:h | redraw! | echo ":cd %:p:h" 
    " CP -> Copy absolute filePath to + register (system clipboard)
        command! CP let @+ = expand("%:p") | redraw! | echo ":let @+ = expand('%:p')" 
    " Writing Mode for distraction free editing
        command! WritingModeOn call EnableWritingMode()
        command! WritingModeOff call DisableWritingMode()
    " Colorscheme on/off
        command! ColorSchemeOn call LoadColors()
        command! ColorSchemeOff call UnloadColors()
    " Command to save and generate .pdf from .md
        command! PDF w | call WriteToPdf()
    " Often used LSP stuff
        command! -range Actions <line1>,<line2>CocAction
        command! -range ACT <line1>,<line2>Actions

        command! Rename call CocActionAsync("rename")
        command! REN Rename

        command! -range=% Format <line1>mark < | <line2>mark > | call CocAction("formatSelected", "V")
        command! -range=% FOR <line1>,<line2>Format

        command! Error call CocActionAsync("diagnosticInfo")
        command! Errors CocList --normal diagnostics
        command! ERRS Errors
        command! ERR Error

call SourceFileIfExists("~/.vimrc.local")
