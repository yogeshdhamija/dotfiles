" PLUGINS:
" **********************

" Install Plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" VIM LSP Stuff
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

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

" Hopefully LSP will replace one day ==
    " Typescript
    Plug 'leafgarland/typescript-vim'

    " Go
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
" ==

call plug#end()







" REGISTER LSP SERVERS:
" **********************************

" Python
if executable('pyls')
    au User lsp_setup call lsp#register_server({
    \ 'name': 'pyls',
    \ 'cmd': {server_info->['pyls']},
        \ 'workspace_config': {'pyls': { 'configurationSources': ['flake8', 'pycodestyle'] } },
    \ 'whitelist': ['python'],
    \ })
endif

" Typescript (set up to also help with JavaScript)
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
      \ 'name': 'typescript-language-server',
      \ 'cmd': { server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
      \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
      \ 'whitelist': ['typescript', 'javascript', 'javascript.jsx']
      \ })
endif

" Go
if executable('go-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'go-langserver',
        \ 'cmd': {server_info->['go-langserver', '-gocodecompletion']},
        \ 'whitelist': ['go'],
        \ })
endif

" Bash
if executable('bash-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'whitelist': ['sh'],
        \ })
endif







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
        else
          let s:session_loaded = 0
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
    " enable vim-airline powerline font icons
    let g:airline_powerline_fonts = 1
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
    " Remap ; to :
    nnoremap ; :
    " Remap capitals to navigate faster ==
        noremap H 7h
        noremap L 7l
        noremap J 7j
        noremap K 7k
    " ==
    " Mouse
    set mouse=a 
    " Highlight all terms when searched using '/'
    set hlsearch    
    " Autoread files changed outside vim
    set autoread    
    " Scroll offset
    set scrolloff=30
    " Pressing * does not move cursor
    nnoremap * *``
    " Required for nerdcommenter plugin
    filetype plugin on
    " NERDTree automatically shows hidden files
    let NERDTreeShowHidden=1
    " NERDTree don't collapse directories with one child
    let NERDTreeCascadeSingleChildDir=0
    " Tab character column size
    set tabstop=4
    " Default indent size
    set shiftwidth=4
    " Set spaces instead of tabs
    set expandtab
    " Keep visual selection after indent change ==
        vmap < <gv
        vmap > >gv
    " ==
    " Get rid of ex mode
    nnoremap Q <nop>
    " Get rid of macros
    nnoremap q <nop>
    " Terminal don't show line numbers
    autocmd TermOpen * setlocal nonumber norelativenumber scl=no
    " Easier splitting ==
        nnoremap <C-J> <C-W><C-J>
        nnoremap <C-K> <C-W><C-K>
        nnoremap <C-L> <C-W><C-L>
        nnoremap <C-H> <C-W><C-H>
        set splitbelow
        set splitright
    " ==
    " Easier Tabs
    nnoremap <C-T> :tabn<CR>
    nnoremap <C-R> :tabp<CR>
    " Easier Buffers
    nnoremap <C-B> :bnext<CR>
    nnoremap <C-V> :bprev<CR>
    " open NERDTREE and terminal if no file specified ==
        " autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | exe 'terminal' | setlocal nonumber norelativenumber scl=no | NERDTree | endif
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
" Getting rid of plugin stuff taking over ma' settings ===
    " vim-go taking up the <C-T> shortcut
    let g:go_def_mapping_enabled = 0
    " vim-go taking up the K key
    let g:go_doc_keywordprg_enabled = 0
    " NERDTree taking up J
    let g:NERDTreeMapJumpLastChild = ''
    " NERDTree taking up K
    let g:NERDTreeMapJumpFirstChild = ''
" ===
" LSP settings ===
    " use async for autocompletion
    let g:lsp_async_completion=1                
    " optimization by reducing duplicate hint windows
    let g:asyncomplete_remove_duplicates=1          
    " enable signs for warnings, errors, etc.
    let g:lsp_signs_enabled = 1             
    " show error of cursor line when in normal mode
    let g:lsp_diagnostics_echo_cursor = 1           
    " allow fuzzy autocompletion
    let g:asyncomplete_smart_completion = 1         
    " Allow auto-popup of suggestions (required for fuzzy autocompletion)
    let g:asyncomplete_auto_popup = 1           
    " Disable preview window
    set completeopt-=preview                
    " <C-Space> refreshes popup window
    imap <c-space> <Plug>(asyncomplete_force_refresh)
" ===





" SHORTCUTS:
" **********************

" Shortcut to create a split terminal window.
" Note: <Esc> will not move to normal mode in terminal. Use <C-\><C-N>.
command T 15split | terminal
" Shortcut to open method definition in a vsplit
command DR vsplit | LspDefinition
" Shortcut to open method definition in current window
command D LspDefinition
" Shortcut to open NERDTree
command FT NERDTree
" Shortcut to use fuzzy finder
command F Files
" Shortcut to close all hidden buffers
command C call DeleteHiddenBuffers()
" WARNING: These commands save the file in the current buffer. ===
    " Shortcut to generate .pdf from .md 
    command PDF w |exe '! pandoc "%:p" -o "%:p:r.pdf" -V fontsize=12pt' 
    " Move current buffer to new tab
    command B w | tab split | tabp | close | tabn
    " Move current buffer to split in previous tab
    command S w | let bufn = bufname('%') | tabp | exe 'vertical sb ' . bufn | tabn | close | tabp | unlet bufn
    " Move current buffer to new tab and turn off line numbers (good for copying)
    command BN w | tab split | tabp | close | tabn | set nonumber | set scl=no
    " Move current buffer to split in previous tab and turn on line numbers
    command SN w | let bufn = bufname('%') | tabp | exe 'vertical sb ' . bufn | tabn | close | tabp | unlet bufn | set number | set scl=yes
" ===






" LOAD LOCAL FILE:
" **********************

try 
    source ~/.localvimrc
catch
endtry
