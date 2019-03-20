" =====================================
" LOAD LOCAL FILE:
" =====================================

try
    source ~/.prelocalvimrc
catch
endtry








" =====================================
" PLUGINS:
" =====================================

" Install Plug if not installed
    if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

call plug#begin('~/.vim/plugged')

Plug 'editorconfig/editorconfig-vim'   " Use .editorconfig
Plug 'mhinz/vim-signify'               " Show git changes in sign column
Plug 'tpope/vim-repeat'                " Make . work for plugins that support it
Plug 'tpope/vim-commentary'            " Commenting
                                           " Example: gc2j  -> go comment 2 down
Plug 'tpope/vim-surround'              " Ability to surround objects
                                           " Example: ysiw] -> yes surround inner word with []
                                           " Example: viwS( -> visual inner word, surround with ( )
                                           " Example: cs'"  -> change surrounding ' to "
                                           " Example: ds"   -> delete surrounding "
                                           " Note: [ for space, ] for no space
Plug 'michaeljsmith/vim-indent-object' " Adding indent-level as a text object
                                           " Example: dii   -> delete inner indent
Plug 'flazz/vim-colorschemes'          " Colorschemes
Plug 'ap/vim-css-color'                " Highlight colors with their color
Plug 'nathanaelkane/vim-indent-guides' " Indent guides
Plug 'vim-airline/vim-airline'         " vim-airline
Plug 'vim-airline/vim-airline-themes'  " vim-airline
Plug 'tpope/vim-fugitive'              " show git branch on vim-airline
Plug 'scrooloose/nerdtree'             " NERDTree
Plug 'Xuyuanp/nerdtree-git-plugin'     " NERDTree
Plug 'mileszs/ack.vim'                 " Search
Plug 'junegunn/fzf', {
    \ 'dir': '~/.fzf',
    \ 'do': './install --all'
\ }                                    " Fuzzy finder
Plug 'junegunn/fzf.vim'                " Fuzzy finder vim wrapper
Plug 'junegunn/vim-easy-align'         " Easy Align
                                           " Example: gaip=         -> go align inner paragraph around the first =
                                           " Example: gaip-=        -> go align inner paragraph around the last =
                                           " Example: gaip*=        -> go align inner paragraph around all =
                                           " Example: gaip<Enter>*= -> go align inner paragraph, reversed, around all =
Plug 'leafgarland/typescript-vim'      " Typescript support
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
\ }                                    " LSP
Plug 'junegunn/goyo.vim'               " :Goyo to enter writing mode
Plug 'junegunn/limelight.vim'          " :Limelight!! to toggle focus mode

call plug#end()










" =====================================
" FUNCTIONS:
" =====================================

" Detects if currently running on Microsoft's Ubuntu on Windows (WSL)
    function! DetectWsl()
        return filereadable("/proc/version") && (match(readfile("/proc/version"), "Microsoft") != -1)
    endfunction

" Detects if currently running on regular Ubuntu
    function! DetectUbuntu()
        return filereadable("/proc/version") && (match(readfile("/proc/version"), "Ubuntu") != -1) && (match(readfile("/proc/version"), "Microsoft") == -1)
    endfunction

" Detects if currently running on Iterm
    function! DetectIterm()
        return $TERM_PROGRAM =~ "iTerm"
    endfunction

" Deletes all unmodified hidden buffers
    function! DeleteHiddenBuffers()
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

" Overriding Goyo plugin's enter/exit functions
    function! s:goyo_enter()
        set spell
        set nocursorline
        set noshowmode
        set noshowcmd
        IndentGuidesDisable
        Limelight
    endfunction
    function! s:goyo_leave()
        set nospell
        set cursorline
        set showmode
        set showcmd
        IndentGuidesEnable
        Limelight!
        AirlineRefresh " Airline starts up weird sometimes...
        AirlineToggle
        AirlineToggle
        AirlineRefresh
    endfunction

" Opening last session if no arguments when vim is opened
    augroup autosession
      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * nested call s:load_session_if_no_args()
      autocmd VimLeavePre * NERDTreeClose
      autocmd FileWritePost,VimLeavePre * call s:save_session_if_flag_set()
    augroup END
    function! s:load_session_if_no_args()
        if argc() == 0 && !exists("s:std_in")
            if filereadable(expand('~/.vim/lastsession.vim'))
                execute 'silent source ~/.vim/lastsession.vim'
            endif
        else
            let s:should_save_session = 0
        endif
    endfunction
    function! s:save_session_if_flag_set()
      if s:should_save_session == 1
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












" =====================================
" REMAPS:
" =====================================

" Pressing * does not move cursor
    nnoremap * *``

" Nerdtree change open in vsplit to `v` instead of `s`
    let NERDTreeMapOpenVSplit='v'
    let NERDTreeMapPreviewVSplit='gv'

" Ack.vim change open vsplit to right side
    " and add 'V' to open in split and close search
    let g:ack_mappings = { "v": "<C-W><CR><C-W>L<C-W>p<C-W>J<C-W>p" ,
                \ "gv": "<C-W><CR><C-W>L<C-W>p<C-W>J" ,
                \ "V": "<C-W><CR><C-W>L<C-W>p:bd<CR><C-W>p"}












" =====================================
" SETTINGS:
" =====================================

" Colorscheme
    set background=dark
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1                     " enable true color for nvim < 1.5 (I think)
    silent! colorscheme molokai
    let g:indent_guides_guide_size = 1
    let g:indent_guides_color_change_percent = 2
    let g:indent_guides_enable_on_vim_startup = 1
    let g:airline#extensions#tabline#enabled = 1
    let g:airline_theme='molokai'
    set number
    set signcolumn=yes
    set cursorline
    if (DetectUbuntu() || DetectIterm() || DetectWsl())
        set termguicolors
    endif
    syntax on
    " Change visual highlight color
        hi Visual term=reverse cterm=reverse guibg=Grey
    " Writing mode settings
        autocmd! User GoyoEnter nested call <SID>goyo_enter()
        autocmd! User GoyoLeave nested call <SID>goyo_leave()

" General settings
    let mapleader = ";"
    set mouse=a
    set ignorecase
    set linebreak
    set hlsearch
    set autoread
    set splitbelow
    set splitright
    filetype plugin on                              " Required for nerdcommenter plugin
    let NERDTreeShowHidden=1
    let s:should_save_session = 1                   " Enable open last session if no file specified
    let NERDTreeCascadeSingleChildDir=0
    let g:airline#extensions#whitespace#enabled = 0 " Airline don't show whitespace errors
    let g:easy_align_ignore_groups=[]
    set tabstop=4
    set shiftwidth=4
    set expandtab
    if has('nvim')                                  " Terminal don't show line numbers
        autocmd TermOpen * setlocal nonumber norelativenumber scl=no
    endif
    if executable('ag')                             " Set ack.vim search to use silver searcher
        let g:ackprg = 'ag --vimgrep --hidden'
    endif
    let g:ackhighlight = 1
        if has("autocmd")                           " Vim jump to the last position when reopening a file
          au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
            \| exe "normal! g`\"" | endif
        endif
    set hidden                                      " Needed for LSP
    let g:LanguageClient_serverCommands = {
        \ 'python': ['pyls'],
        \ 'java': ['jdtls'],
        \ 'go': ['go-langserver'],
        \ 'javascript': ['javascript-typescript-stdio'],
        \ 'typescript': ['javascript-typescript-stdio'],
    \ }
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











" =====================================
" SHORTCUTS:
" =====================================

" Leader shortcuts
    " t -> Terminal window, bottom
    " tj -> Terminal window, down (aka j)
    " tl -> Terminal window, right (aka l)
        " Note: <Esc> will not move to normal mode in terminal. Use <C-\><C-N>.
        if has('nvim')
            map <Leader>t :25split<CR> :terminal<CR> i
            map <Leader>tj :25split<CR> :terminal<CR> i
            map <Leader>tl :vsplit<CR> :terminal<CR> i
        else
            map <Leader>t :terminal<CR>
            map <Leader>tj :terminal<CR>
            map <Leader>tl :vsplit<CR> :terminal<CR> <C-W>k :q<CR>
        endif
    " bd -> Buffer Delete
        map <Leader>bd :bd<CR>
    " bca -> Buffers Close All
        map <Leader>bca :call DeleteHiddenBuffers()<CR>
    " CD -> Change Directory to current open file
        command CD cd %:p:h
        map <Leader>CD :CD<CR> :pwd<CR>
    " ld -> Lsp go-to-Definition
        map <Leader>ld :call LanguageClient#textDocument_definition()<CR>
    " ldl -> Lsp go-to-Definition in right (aka l) split
        map <Leader>ldl :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
    " lm -> Lsp Menu
        map <Leader>lm :call LanguageClient_contextMenu()<CR>
    " d -> Directory tree
        map <Leader>d :NERDTreeToggle<CR>
    " f -> Find
        map <Leader>f :LAck!<Space>
    " o -> Open
        map <Leader>o :FZF<CR>
    " r -> Right buffer
        map <Leader>r :bn<CR>

" Command to enter writing mode
    command WritingMode Goyo
" Command to save and generate .pdf from .md
    command PDF w | exe '! pandoc "%:p" --listings -H ~/.listings-setup.tex -o "%:p:r.pdf"'
" Delete vim session and quit
    command ClearSession let s:should_save_session = 0 | exe '!rm ~/.vim/lastsession.vim > /dev/null 2>&1' | qa










" =====================================
" LOAD LOCAL FILE:
" =====================================

try
    source ~/.localvimrc
catch
endtry
