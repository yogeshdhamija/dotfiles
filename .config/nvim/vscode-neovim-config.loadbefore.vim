source ~/.config/vim/functions.vim

" g:vscode is set by the vscode-neovim plugin (https://github.com/asvetliakov/vscode-neovim)
if(exists("g:vscode") && has('nvim'))




if !exists("plugins")
    let plugins = [
        \ ['yogeshdhamija/better-asterisk-remap.vim', {}],
        \ ['tpope/vim-repeat', {}],
        \ ['tpope/vim-surround', {}],
        \ ['tpope/vim-abolish', {}],
        \ ['michaeljsmith/vim-indent-object', {}],
        \ ['junegunn/vim-easy-align', {}],
        \ ['yogeshdhamija/find-in-dir-helper.vim', {}],
        \ ['yogeshdhamija/filter-lq-list.vim', {}],
        \ ['yogeshdhamija/close-hidden-buffers-command.vim', {}],
    \ ]
endif





endif
