source ~/.config/vim/functions.vim

call SourceFileIfExists("~/.vimrc.local.loadbefore")

if !exists("plugins")
    let plugins = [ 
        \ ['editorconfig/editorconfig-vim', {}],
        \ ['mhinz/vim-signify', {}],
        \ ['tpope/vim-repeat', {}],
        \ ['tpope/vim-commentary', {}],
        \ ['tpope/vim-surround', {}],
        \ ['michaeljsmith/vim-indent-object', {}],
        \ ['rakr/vim-one', {}],
        \ ['itchyny/lightline.vim', {}],
        \ ['Yggdroot/indentLine', {}],
        \ ['tpope/vim-fugitive', {}],
        \ ['junegunn/fzf', {}],
        \ ['junegunn/fzf.vim', {}],
        \ ['junegunn/vim-easy-align', {}],
        \ ['junegunn/goyo.vim', {}],
        \ ['junegunn/limelight.vim', {}],
        \ ['justinmk/vim-dirvish', {}],
        \ ['leafgarland/typescript-vim', {}],
        \ ['neoclide/coc.nvim', {'do': function('InstallCocPlugins')}],
    \]
endif
if !exists("disabled_plugins")
    let disabled_plugins = []
endif

call InstallPlugins(plugins, disabled_plugins)

" Overriding Goyo plugin's enter/exit functions
    function! s:goyo_enter()
        let g:writingmode=1
        call LoadColors()
        call UnloadColors()
        setlocal syntax=off
        setlocal spell
        setlocal noshowmode
        setlocal nocursorline
        setlocal noshowcmd
        let b:coc_suggest_disable = 1
        Limelight
        " Set up ability to :q from within WritingMode
            let b:quitting = 0
            let b:quitting_bang = 0
            autocmd QuitPre <buffer> let b:quitting = 1
            cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
        set background=light
    endfunction
    function! s:goyo_leave()
        let g:writingmode=0
        set syntax<
        set spell<
        set showmode<
        set showcmd<
        set cursorline<
        let b:coc_suggest_disable = 0
        Limelight!
        " Quit Vim if this is the only remaining buffer
            if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
                if b:quitting_bang
                    qa!
                else
                    qa
                endif
            endif
        call LoadColors()
    endfunction

" =====================================
" SETTINGS:
" =====================================

" Preserve default colorscheme
    call DisableLightline()
    call DisableIndentLines()

" General settings
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
    if has('nvim')                                  " Terminal don't show line numbers
        autocmd TermOpen * setlocal nonumber norelativenumber scl=no
    endif
    let g:ack_use_cword_for_empty_search = 0
    if executable('rg')
        set grepprg=rg\ --vimgrep\ --no-heading\ --hidden
    elseif executable('ag')
        set grepprg=ag\ --vimgrep\ --noheading\ --hidden
    endif
    let g:ackhighlight = 1
    if has("autocmd")                               " Vim jump to the last position when reopening a file
        au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
            \ | exe "normal! g`\"" | endif
    endif
    set hidden                                      " Needed for LSP
    let g:dirvish_mode = 2
    let g:dirvish_relative_paths = 1
    if DetectWsl()
        let g:clipboard = {
            \   'name': 'WslClipboard',
            \   'copy': {
            \      '+': 'clip.exe',
            \      '*': 'clip.exe',
            \    },
            \   'paste': {
            \      '+': 'powershell.exe -c Get-Clipboard',
            \      '*': 'powershell.exe -c Get-Clipboard',
            \   },
            \   'cache_enabled': 0,
            \ }
    endif
    " Start interactive EasyAlign in visual mode (e.g. vipga)
        xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
        nmap ga <Plug>(EasyAlign)
    " Writing mode settings
        autocmd! User GoyoEnter nested call <SID>goyo_enter()
        autocmd! User GoyoLeave nested call <SID>goyo_leave()
    " Setting up session management (autosave sessions)
        let g:should_save_session = 0
        augroup autosession
            autocmd StdinReadPre * let s:std_in=1
            autocmd VimEnter * nested call LoadSessionIfVimNotLaunchedWithArgs()
            autocmd FileWritePost,VimLeavePre * call SaveSessionIfFlagSet()
        augroup END
    " Directory tree settings
    augroup dirvish_config
        autocmd!
        " Improve preview
        autocmd FileType dirvish
                    \ nnoremap <silent><buffer> p ddO<Esc>:r ! find "<C-R>"" -maxdepth 1 -print0 \| xargs -0 ls -Fd<CR>:silent! keeppatterns %s/\/\//\//g<CR>:silent! keeppatterns %s/[^a-zA-Z0-9\/]$//g<CR>:silent! keeppatterns g/^$/d<CR>:noh<CR>
    augroup END












" =====================================
" REMAPS:
" =====================================

" Pressing * does not move cursor
    nnoremap * :let old=@"<CR>yiw:let @/="\\V\\<".escape(@", '/\')."\\>"<CR>:set hlsearch<CR>:let @"=old<CR>:echo "/".@/<CR>

" Pressing * in visual mode searches for selection
    vnoremap * :<C-U>let old=@"<CR>gvy:let @/="\\V".escape(@", '/\')<CR>:set hlsearch<CR>:let @"=old<CR>:echo "/".@/<CR>

" Make pasting from clipboard safer
    inoremap <C-R>+ <C-R><C-R>+

" Pressing <Esc> in normal mode removes search highlights
    " augroup because of vim issue https://github.com/vim/vim/issues/3080
    " Note: remapping on every yank might cause lag
    augroup escape_mapping
        autocmd!
        autocmd TextYankPost * nnoremap <Esc> <Esc>:noh<CR>
    augroup END

" Remap left mouse release to put in insert mode
    nnoremap <LeftMouse> <C-\><C-n><LeftMouse>
    inoremap <LeftMouse> <C-\><C-n><LeftMouse>
    nnoremap <silent> <LeftRelease> <C-\><C-n><LeftRelease>:call EnterInsertIfFileOrIfBottomOfTerminal()<CR>
    inoremap <silent> <LeftRelease> <C-\><C-n><LeftRelease>:call EnterInsertIfFileOrIfBottomOfTerminal()<CR>

" Remap Control+C in visual mode to copy to system clipboard (and Command+C for some terminals)
    vnoremap <C-c> "+y
    vnoremap <D-c> "+y
" Remap Ctrl+V in insert + visual modes to paste from system clipboard (and Command+C for some terminals)
    vnoremap <C-v> "+p
    inoremap <C-v> <C-r>+
    vnoremap <D-v> "+p
    inoremap <D-v> <C-r>+










" =====================================
" SHORTCUTS:
" =====================================

" \t -> Terminal window
" \th -> Terminal window, left (aka h)
" \tj -> Terminal window, down (aka j)
" \tk -> Terminal window, up (aka k)
" \tl -> Terminal window, right (aka l)
    " Note: <Esc> will not move to normal mode in terminal. Use <C-\><C-N>.
    if has('nvim')
        nnoremap \t :terminal<CR>:startinsert<CR>
        nnoremap \th :vsplit<CR><C-W>H:terminal<CR>:startinsert<CR>
        nnoremap \tj :25split<CR>:terminal<CR>:startinsert<CR>
        nnoremap \tk :split<CR><C-W>K25<C-W>_:terminal<CR>:startinsert<CR>
        nnoremap \tl :vsplit<CR>:exe "terminal"<CR>:startinsert<CR>
    else
        nnoremap \t :terminal ++curwin<CR>
        nnoremap \th :terminal<CR><C-W>_<C-W>H
        nnoremap \tj :terminal<CR><C-\><C-n>25<C-W>_i
        nnoremap \tk :terminal<CR><C-\><C-n><C-W>K25<C-W>_i
        nnoremap \tl :terminal<CR><C-W>L
    endif
" \d -> Directory listing
    nmap \d :silent! cd %:p:h<CR>:if(expand('%'))<CR>Dirvish %<CR>else<CR>Dirvish<CR>endif<CR><CR>:echo ":Dirvish %"<CR>:silent! cd -<CR>R
" \f -> Find
    nnoremap \f :call DisplayHelpAndSearch()<CR>
" \o -> Open
    nnoremap \o :FZF<CR>
" \b -> list Buffers
    nnoremap \b :Buffers<CR>
" \w -> list Windows
    nnoremap \w :Windows<CR>
" LSP Stuff
    " \ld -> Lsp go-to-Definition
        nnoremap \ld :LspJumpDefinition<CR>
    " \ldl -> Lsp go-to-Definition in right (aka L) split
        nnoremap \ldl :vsplit<CR> :LspJumpDefinition<CR>
    " \lr -> Lsp jump to References
        nnoremap \lr :LspJumpReferences<CR>
    " \lrl -> Lsp jump to References in right (aka L) split
        nnoremap \lrl :vsplit<CR> :LspJumpReferences<CR>
    " \lw -> Lsp what's Wrong list
        nnoremap \lw :LspDiagnosticList<CR>
    " \lwl -> Lsp what's Wrong List
        nnoremap \lwl :LspDiagnosticList<CR>
    " \lwh -> Lsp what's Wrong List
        nnoremap \lwh :LspDiagnosticInfo<CR>
    " \lh -> Lsp Help<CR>
        nnoremap \lh :LspHover<CR>








" =====================================
" COMMANDS:
" =====================================

" CAB -> Close All Buffers
    command CloseHiddenBuffers call DeleteHiddenBuffers()
" CD -> Change Directory to current open file
    command CD echo ":cd %:p:h" | silent cd %:p:h
" CP -> Copy absolute filePath to + register (system clipboard)
    command CP echo ":let @+ = expand('%:p')" | let @+ = expand("%:p")
" Writing mode
    command WritingModeOn Goyo 80x85%
    command WritingModeOff Goyo!
    command WritingModeToggle Goyo
" Command to save and generate .pdf from .md
    command PDF w | call WriteToPdf()
" Start saving the session
    command StartKeepingSession let g:should_save_session = 1 | echo "Using ':mksession' and ':source' to save and load session."
" Delete vim session and quit
    command ClearSession let g:should_save_session = 0 | exe '!rm ~/.vim/lastsession.vim > /dev/null 2>&1' | qa
" Map coc.nvim available actions to commands to allow tab completion
    command LspDiagnosticList      CocList --normal diagnostics
    command LspDiagnosticInfo      call CocActionAsync("diagnosticInfo")
    command LspJumpDefinition      call CocActionAsync("jumpDefinition")
    command LspJumpDeclaration     call CocActionAsync("jumpDeclaration")
    command LspJumpImplementation  call CocActionAsync("jumpImplementation")
    command LspJumpTypeDefinition  call CocActionAsync("jumpTypeDefinition")
    command LspJumpReferences      call CocActionAsync("jumpReferences")
    command LspHover               call CocActionAsync("doHover")
    command LspRename              call CocActionAsync("rename")
    command LspSymbols             CocList --interactive symbols
    command LspFormat              call CocActionAsync("format")
    command LspCodeAction          call CocActionAsync("codeAction")
    command LspCodeLensAction      call CocActionAsync("codeLensAction")
    command LspQuickfixes          call CocActionAsync("quickfixes")








call SourceFileIfExists("~/.vimrc.local")
