" LOAD LOCAL FILE:
" **********************

try
    source ~/.prelocalvimrc
catch
endtry








" PLUGINS:
" **********************

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
                                           " Example: gc2j  = go comment 2 down
Plug 'tpope/vim-surround'              " Ability to surround objects
                                           " Example: ysiw] = yes surround inner word with []
                                           " Example: cs'"  = change surrounding ' to "
                                           " Example: ds"   = delete surrounding "
                                           " Note: [ for space, ] for no space
Plug 'michaeljsmith/vim-indent-object' " Adding indent-level as a text object
                                           " Example: dii   = delete inner indent
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
                                           " Example: gaip=         = go align inner paragraph around the first =
                                           " Example: gaip-=        = go align inner paragraph around the last =
                                           " Example: gaip*=        = go align inner paragraph around all =
                                           " Example: gaip<Enter>*= = go align inner paragraph, reversed, around all =
Plug 'leafgarland/typescript-vim'      " Typescript support
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
\ }                                    " LSP
Plug 'junegunn/goyo.vim'               " :Goyo to enter writing mode
Plug 'junegunn/limelight.vim'          " :Limelight!! to toggle focus mode

call plug#end()










" FUNCTIONS:
" **********************
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

" Writing mode settings ===
    function! s:goyo_enter()
        set spell
        set nocursorline
        IndentGuidesDisable
        Limelight
    endfunction

    function! s:goyo_leave()
        set nospell
        set cursorline
        IndentGuidesEnable
        Limelight!
        " Airline starts up weird sometimes...
        AirlineRefresh
        AirlineToggle
        AirlineToggle
        AirlineRefresh
    endfunction

    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    autocmd! User GoyoLeave nested call <SID>goyo_leave()
" ===

" Opening last session if no arguments when vim is opened ===
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
" ===











" REMAPS:
" **********************

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








" SETTINGS:
" **********************

" Colorscheme settings ===
    " dark background
    set background=dark
    " enable true color for nvim < 1.5 (I think)
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
    " syntax highlighting (I think)
    syntax enable
    " colorscheme
    silent! colorscheme molokai
    " make indent lines 1 character wide
    let g:indent_guides_guide_size = 1
    " make indent guide lines subtle
    let g:indent_guides_color_change_percent = 2
    " enable indent guides
    let g:indent_guides_enable_on_vim_startup = 1
    " enable vim-airline tab bar
    let g:airline#extensions#tabline#enabled = 1
    " vim-airline theme
    let g:airline_theme='molokai'
    " Line numbers
    set number
    " Show sign column
    set scl=yes
    " Show line under where cursor is
    set cursorline
    " Use better colors if terminal supports it ==
        let colorenv=$COLORTERM
        if colorenv == 'truecolor'
            set termguicolors
        endif
    " ==
    " Syntax highlighting
    syntax on
    " Change visual highlight color
    hi Visual term=reverse cterm=reverse guibg=Grey
" ===

" General settings ===
    " Set leader key
    let mapleader = ";"
    " Mouse
    set mouse=a
    " Ignore case on search
    set ignorecase
    " Line break on word boundry
    set linebreak
    " Highlight all terms when searched using '/'
    set hlsearch
    " Autoread files changed outside vim
    set autoread
    " Set default to split below
    set splitbelow
    " Set default to split above
    set splitright
    " Required for nerdcommenter plugin
    filetype plugin on
    " NERDTree automatically shows hidden files
    let NERDTreeShowHidden=1
    " Enable open last session if no file specified
    let s:should_save_session = 1
    " NERDTree don't collapse directories with one child
    let NERDTreeCascadeSingleChildDir=0
    " Airline don't show whitespace errors
    let g:airline#extensions#whitespace#enabled = 0
    " Tab character column size
    set tabstop=4
    " Default indent size
    set shiftwidth=4
    " Set spaces instead of tabs
    set expandtab
    " Terminal don't show line numbers ==
        if has('nvim')
            autocmd TermOpen * setlocal nonumber norelativenumber scl=no
        endif
    " ==
    " Set search to use silver searcher
    if executable('ag')
        let g:ackprg = 'ag --nogroup --nocolor --column --hidden'
    endif
    " Highlight search results on open
    let g:ackhighlight = 1
    " Vim jump to the last position when reopening a file ==
        if has("autocmd")
          au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
            \| exe "normal! g`\"" | endif
        endif
    " ==
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)
    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
" ===
" 'autozimu/LanguageClient-neovim' config ===
    set hidden
    let g:LanguageClient_serverCommands = {
        \ 'python': ['pyls'],
        \ 'java': ['jdtls'],
        \ 'go': ['go-langserver'],
        \ 'javascript': ['javascript-typescript-stdio'],
        \ 'typescript': ['javascript-typescript-stdio'],
    \ }
" ===




" SHORTCUTS:
" **********************

" Shortcut to create a split terminal window. ==
" Note: <Esc> will not move to normal mode in terminal. Use <C-\><C-N>. ==
    if has('nvim')
        map <Leader>t :25split<CR> :terminal<CR>
    else
        map <Leader>t :terminal<CR>
    endif
" ==

" Alias for buffer delete
map <Leader>bd :bd<CR>
" Shortcut to close all hidden buffers ('bca' -> 'buffers close all')
map <Leader>bca :call DeleteHiddenBuffers()<CR>
" Shortcut to make current file location the current working directory
    command CD cd %:p:h
    map <Leader>cd :cd<CR> :pwd<CR>
    map <Leader>CD :CD<CR> :pwd<CR>
" Open method definition in current window ('ld' -> 'lsp definition')
map <Leader>ld :call LanguageClient#textDocument_definition()<CR>
" Shortcut to open method definition in a vsplit
map <Leader>ldr :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
" Shortcut to open LSP context menu
map <Leader>lm :call LanguageClient_contextMenu()<CR>
" Shortcut to search ('f' for 'find')
map <Leader>f :LAck!<Space>
" Shortcut to open dir tree ('d' for 'dirtree')
map <Leader>d :NERDTreeToggle<CR>
" Shortcut to use fuzzy file finder ('o' for 'open')
map <Leader>o :FZF<CR>
" Cycle buffers ('r' for 'right')
map <Leader>r :bn<CR>

" Move current buffer to new tab ('vb' for 'view big')
map <Leader>vb :tab split<CR> :tabp<CR> :close<CR> :tabn<CR>
" Move current buffer to new tab and turn off line numbers (good for copying)
map <Leader>vbn :tab split<CR> :tabp<CR> :close<CR> :tabn<CR> :set nonumber<CR> :set scl=no<CR>
" Move current buffer to split in previous tab
map <Leader>vs :let bufn = bufname('%')<CR> :tabp<CR> :exe 'vertical sb ' . bufn<CR> :tabn<CR> :close<CR> :tabp<CR> :unlet bufn<CR>
" Move current buffer to split in previous tab and turn on line numbers
map <Leader>vsn :let bufn = bufname('%')<CR> :tabp<CR> :exe 'vertical sb ' . bufn<CR> :tabn<CR> :close<CR> :tabp<CR> :unlet bufn<CR> :set number<CR> :set scl=yes<CR>

" Command to enter writing mode
command Writing Goyo
" Command to save and generate .pdf from .md
command PDF w | exe '! pandoc "%:p" --listings -H ~/.listings-setup.tex -o "%:p:r.pdf"'
" Delete vim session and quit
command ClearSession let s:should_save_session = 0 | exe '!rm ~/.vim/lastsession.vim > /dev/null 2>&1' | qa






" LOAD LOCAL FILE:
" **********************

try
    source ~/.localvimrc
catch
endtry
