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
" TODO: Look for better. Silver Searcher (ag) offers better functionality.
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
      silent execute 'bwipeout!' buf
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
            if filereadable(expand('~/.vim/lastsession.vim'))
                execute 'silent source ~/.vim/lastsession.vim'
            endif
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
    " Set leader key
    let mapleader = "\\"
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
        map <Leader>t :25split<CR> :terminal<CR>
    else
        map <Leader>t :terminal<CR>
    endif
" ==
" Shortcut to open method definition in a vsplit
map <Leader>dr :call LanguageClient#textDocument_definition({'gotoCmd': 'vsplit'})<CR>
" Shortcut to open method definition in current window
map <Leader>d :call LanguageClient#textDocument_definition()<CR>
" Shortcut to open LSP context menu
map <Leader>m :call LanguageClient_contextMenu()<CR>

" Shortcut to open NERDTree
map <Leader>ft :NERDTree<CR>
" Shortcut to use fuzzy file finder ('o' for 'open')
map <Leader>o :FZF<CR>
" Shortcut to use default silver searcher commands
    " command! -bang -nargs=+ -complete=dir Rag call fzf#vim#ag_raw(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
map <Leader>f :Ag<CR>
" Shortcut to close all hidden buffers
map <Leader>cb :call DeleteHiddenBuffers()<CR>
" Shortcut to make current file location the current working directory
    command CD cd %:p:h
    map <Leader>cd :cd<CR> :pwd<CR>
    map <Leader>CD :CD<CR> :pwd<CR>
" Move current buffer to new tab
map <Leader>b :tab split<CR> :tabp<CR> :close<CR> :tabn<CR>
" Move current buffer to split in previous tab
map <Leader>s :let bufn = bufname('%')<CR> :tabp<CR> :exe 'vertical sb ' . bufn<CR> :tabn<CR> :close<CR> :tabp<CR> :unlet bufn<CR>
" Move current buffer to new tab and turn off line numbers (good for copying)
map <Leader>bn :tab split<CR> :tabp<CR> :close<CR> :tabn<CR> :set nonumber<CR> :set scl=no<CR>
" Move current buffer to split in previous tab and turn on line numbers
map <Leader>sn :let bufn = bufname('%')<CR> :tabp<CR> :exe 'vertical sb ' . bufn<CR> :tabn<CR> :close<CR> :tabp<CR> :unlet bufn<CR> :set number<CR> :set scl=yes<CR>

" Command to save and generate .pdf from .md
command PDF w | exe '! pandoc "%:p" --listings -H ~/.listings-setup.tex -o "%:p:r.pdf"'
" Delete vim session and quit
command ClearSession let s:session_loaded = 0 | exe '!rm ~/.vim/lastsession.vim > /dev/null 2>&1' | qa






" LOAD LOCAL FILE:
" **********************

try
    source ~/.localvimrc
catch
endtry
