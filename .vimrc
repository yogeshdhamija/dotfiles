set background=dark
set number
set mouse=a
syntax on
set hlsearch
set cursorline

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'editorconfig/editorconfig-vim'
Plug 'mhinz/vim-signify'
Plug 'nvie/vim-flake8'

call plug#end()

autocmd BufWritePost *.py call Flake8()
let g:flake8_show_in_file=1
let g:flake8_show_quickfix=0

