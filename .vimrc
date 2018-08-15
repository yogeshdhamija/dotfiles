
" SETTINGS: 
" **********************

" Dark background
set background=dark

" Line numbers
set number

" Mouse
set mouse=a

" Syntax highlighting
syntax on

" Highlight all terms when searched using '/'
set hlsearch

" Show line under where cursor is
set cursorline

" LSP use async for autocompletion
let g:lsp_async_completion=1

" LSP optimization by reducing duplicate hint windows
let g:asyncomplete_remove_duplicates = 1

" LSP nable signs for warnings, errors, etc.
let g:lsp_signs_enabled = 1

" LSP show error of cursor line when in normal mode
let g:lsp_diagnostics_echo_cursor = 1

" Easier splitting
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright







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

" Other
Plug 'editorconfig/editorconfig-vim'
Plug 'mhinz/vim-signify'

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

