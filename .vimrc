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

" Theme
Plug 'flazz/vim-colorschemes'

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

" C, C++ through cquery
if executable('cquery')
   au User lsp_setup call lsp#register_server({
      \ 'name': 'cquery',
      \ 'cmd': {server_info->['cquery']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': { 'cacheDirectory': '/path/to/cquery/cache' },
      \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
      \ })
endif

" C, C++ through clangd
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif

" Go
if executable('go-langserver')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'go-langserver',
        \ 'cmd': {server_info->['go-langserver', '-mode', 'stdio']},
        \ 'whitelist': ['go'],
        \ })
endif











" SETTINGS: 
" **********************

" Colorscheme settings ===
set background=dark			" duh
let $NVIM_TUI_ENABLE_TRUE_COLOR=1	" enable true color for nvim < 1.5 (I think)
set termguicolors			" enable true color support for nvim > 1.5 (I think)
syntax enable				" syntax highlighting (I think)
colorscheme molokai			" dis da best one
" ===


set number		" Line numbers
set mouse=a		" Mouse
syntax on		" Syntax highlighting
set hlsearch		" Highlight all terms when searched using '/'
set cursorline		" Show line under where cursor is
set autoread		" Autoread files changed outside vim
set scrolloff=30	" Scroll offset
nnoremap * *``
			" Pressing * does not move cursor


" Vim jump to the last position when reopening a file ===
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g`\"" | endif
endif
" ===


let g:lsp_async_completion=1					" LSP use async for autocompletion
let g:asyncomplete_remove_duplicates=1				" LSP optimization by reducing duplicate hint windows
let g:lsp_signs_enabled = 1					" LSP enable signs for warnings, errors, etc.
let g:lsp_diagnostics_echo_cursor = 1				" LSP show error of cursor line when in normal mode
let g:asyncomplete_smart_completion = 1				" LSP allow fuzzy autocompletion
let g:asyncomplete_auto_popup = 1				" LSP Allow auto-popup of suggestions (required for fuzzy autocompletion)
set completeopt-=preview					" LSP Disable preview window
imap <c-space> <Plug>(asyncomplete_force_refresh)
								" Ctrl+Space refreshes popup window

" Easier splitting ===
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright
" ===


autocmd TermOpen * setlocal nonumber norelativenumber
								" Terminal don't show line numbers

command T 15split | terminal
								" Shortcut to create a split terminal window

command Dr vsplit | LspDefinition
								" Shortcut to open method definition in a vsplit

command D LspDefinition
								" Shortcut to open method definition in current window

