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

" Use .editorconfig
Plug 'editorconfig/editorconfig-vim'

" Show git changes in sign column
Plug 'mhinz/vim-signify'

" Make . work for plugins that support it
Plug 'tpope/vim-repeat'

" Commenting
" Example: gc2j = go comment 2 down
" Note: gc = go comment
Plug 'tpope/vim-commentary'

" Ability to surround objects
" Example: ysiw] = yes surround inner word with []
" Example: cs'" = change surrounding ' to "
" Example: ds" = delete surrounding "
" Note: [ for space, ] for no space
Plug 'tpope/vim-surround'

" Adding indent-level as a text object
" Example: dii = delete inner indent
Plug 'michaeljsmith/vim-indent-object'

" Colorschemes
Plug 'flazz/vim-colorschemes'

" Indent guides
Plug 'nathanaelkane/vim-indent-guides'

" vim-airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" show git branch on vim-airline
Plug 'tpope/vim-fugitive'

" NERDTree
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'

" Fuzzy finder
" Note: If silver searcher is installed, :Ag to search.
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
    
" Typescript support
Plug 'leafgarland/typescript-vim'

" LSP
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
\ }

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
      silent execute 'bwipeout' buf
      let closed += 1
    endif
  endfor
  echo "Closed ".closed." hidden buffers"
endfunction

" Opening last session if no arguments when vim is opened ===
    augroup autosession
      autocmd StdinReadPre * let s:std_in=1
      autocmd VimEnter * nested call s:session_vim_enter()
      autocmd VimLeavePre * NERDTreeClose
      autocmd FileWritePost,VimLeavePre * call s:session_vim_leave()
    augroup END

    function! s:session_vim_enter()
        if argc() == 0 && !exists("s:std_in")
            execute 'silent source ~/.vim/lastsession.vim'

        " " Disabled cuz want vim to save sessions even if specific file opened
        " else
        "   let s:session_loaded = 0
        endif
    endfunction

    function! s:session_vim_leave()
      if s:session_loaded == 1
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











" MAPPINGS:
" **********************

" Pressing * does not move cursor
nnoremap * *``
" Easier splitting ==
    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H>
" ==









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
    colorscheme molokai
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
    " Mouse
    set mouse=a
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
    " Open last session if no file specified
    let s:session_loaded = 1
    " Vim jump to the last position when reopening a file ==
        if has("autocmd")
          au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
            \| exe "normal! g`\"" | endif
        endif
    " ==
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
        command T 25split | terminal
    endif
" ==
" Shortcut to open method definition in a vsplit
command DR :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})
" Shortcut to open method definition in current window
command D :call LanguageClient#textDocument_definition()
" Shortcut to open LSP context menu
command M :call LanguageClient_contextMenu()

" Shortcut to open NERDTree
command FT NERDTree
" Shortcut to use fuzzy finder
command F Files
" Shortcut to close all hidden buffers
command CB call DeleteHiddenBuffers()
" Shortcut to make current file location the current working directory
command CD cd %:p:h
" Shortcut to save and generate .pdf from .md
command PDF w |exe '! pandoc "%:p" --listings -H ~/.listings-setup.tex -o "%:p:r.pdf"'
" Move current buffer to new tab
command B tab split | tabp | close | tabn
" Move current buffer to split in previous tab
command S let bufn = bufname('%') | tabp | exe 'vertical sb ' . bufn | tabn | close | tabp | unlet bufn
" Move current buffer to new tab and turn off line numbers (good for copying)
command BN tab split | tabp | close | tabn | set nonumber | set scl=no
" Move current buffer to split in previous tab and turn on line numbers
command SN let bufn = bufname('%') | tabp | exe 'vertical sb ' . bufn | tabn | close | tabp | unlet bufn | set number | set scl=yes






" LOAD LOCAL FILE:
" **********************

try
    source ~/.localvimrc
catch
endtry
