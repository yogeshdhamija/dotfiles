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
        \ ['AndrewRadev/splitjoin.vim', {}],
    \ ]
    let interface_convenience_plugins = [
        \ ['yogeshdhamija/enter-insert-on-click.vim', {}],
        \ ['junegunn/vim-peekaboo', {}],
        \ ['kshenoy/vim-signature', {}],
        \ ['machakann/vim-highlightedyank', {}],
        \ ['liuchengxu/vim-which-key', {}],
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
        \ ['neoclide/coc.nvim', {'branch': 'release'}],
        \ ['sheerun/vim-polyglot', {}],
    \ ]
    let visual_plugins = [
        \ ['mhinz/vim-signify', {}],
        \ ['joshdick/onedark.vim', {}],
        \ ['morhetz/gruvbox', {}],
        \ ['itchyny/lightline.vim', {}],
        \ ['lukas-reineke/indent-blankline.nvim', {}],
    \ ]
    let plugins = vim_idiomatic_plugins
                \ + interface_convenience_plugins
                \ + ide_like_functionality_plugins
                \ + language_plugins
                \ + visual_plugins
endif

if exists("added_plugins")
    let plugins = plugins + added_plugins
endif

if !exists("disabled_plugins")
    let disabled_plugins = []
endif

call InstallPlugins(plugins, disabled_plugins)

if !exists("coc_plugins")
    let coc_plugins = [
        \ 'coc-marketplace',
        \ 'coc-vimlsp',
        \ 'coc-json',
        \ 'coc-yaml',
    \ ]
endif

if exists("added_coc_plugins")
    let coc_plugins = coc_plugins + added_coc_plugins
endif

let g:coc_global_extensions = coc_plugins
