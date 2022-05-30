source ~/.config/vim/functions.vim

if !exists("plugins")
    let vim_idiomatic_plugins = [
        \ ['yogeshdhamija/better-asterisk-remap.vim', {}],
        \ ['tpope/vim-repeat', {}],
        \ ['tpope/vim-surround', {}],
        \ ['michaeljsmith/vim-indent-object', {}],
        \ ['junegunn/vim-easy-align', {}],
        \ ['yogeshdhamija/find-in-dir-helper.vim', {}],
        \ ['yogeshdhamija/filter-lq-list.vim', {}],
        \ ['yogeshdhamija/close-hidden-buffers-command.vim', {}],
        \ ['yogeshdhamija/terminal-command-motion.vim', {}],
    \ ]
    let interface_convenience_plugins = [
        \ ['yogeshdhamija/enter-insert-on-click.vim', {}],
        \ ['junegunn/vim-peekaboo', {}],
        \ ['kshenoy/vim-signature', {}],
        \ ['machakann/vim-highlightedyank', {}],
    \ ]
    let ide_like_functionality_plugins = [
        \ ['tpope/vim-commentary', {}],
        \ ['yogeshdhamija/save-sessions-per-directory.vim', {}],
        \ ['tpope/vim-fugitive', {}],
        \ ['tpope/vim-rhubarb', {}],
        \ ['junegunn/fzf', { 'do': { -> fzf#install() } }],
        \ ['junegunn/fzf.vim', {}],
        \ ['justinmk/vim-dirvish', {}],
        \ ['editorconfig/editorconfig-vim', {}],
    \ ]
    let language_plugins = [
    \ ]
    let visual_plugins = [
        \ ['mhinz/vim-signify', {}],
        \ ['morhetz/gruvbox', {}],
        \ ['itchyny/lightline.vim', {}],
        \ ['Yggdroot/indentLine', {}],
    \ ]
    let neovim_only_plugins = [
        \ ['neovim/nvim-lspconfig', {}],
        \ ['hrsh7th/cmp-nvim-lsp', {}],
        \ ['hrsh7th/cmp-buffer', {}],
        \ ['hrsh7th/cmp-path', {}],
        \ ['hrsh7th/cmp-cmdline', {}],
        \ ['hrsh7th/nvim-cmp', {}],
        \ ['j-hui/fidget.nvim', {}],
    \ ]
    let plugins = vim_idiomatic_plugins
                \ + interface_convenience_plugins
                \ + ide_like_functionality_plugins
                \ + language_plugins
                \ + visual_plugins
    if has('nvim')
      let plugins = plugins + neovim_only_plugins
    endif
endif


if exists("added_plugins")
    let plugins = plugins + added_plugins
endif

if !exists("disabled_plugins")
    let disabled_plugins = []
endif

call InstallPlugins(plugins, disabled_plugins)
