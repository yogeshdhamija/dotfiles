# Dotfiles

## Quick Start

To clone this repo into your home directory:

```bash
export DOTFILES_REPO_URL=git@github.com:yogeshdhamija/dotfiles.git
# OR
export DOTFILES_REPO_URL=https://github.com/yogeshdhamija/dotfiles.git

source <(curl -Ls https://gist.githubusercontent.com/yogeshdhamija/c65eab14d4bfc62f2d3dd490b7f082d5/raw/65891558f1abf858c390654a88bc78b25d5d48dc/dotfiles.sh)
```

This will set up a git repository in the folder `~/.dotfiles` with a detached working tree. This way, you can treat your home directory if as if it were a git repository -- using the `dotfiles` command, instead of `git` -- and it won't do crazy stuff like interfere with your other git repositories. Source: [this article](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).

## Cheat Sheet

**Common settings in** `~/.vimrc.local.loadbefore`:
```

" To override the default plugins (list is in vim-plug style):
    if !exists("plugins")
        let plugins = []
    endif
    let plugins = plugins + [  
        \["these_plugins_will/override_the_defaults", {}],
    \]

" To add more plugins (list is in vim-plug style):
    if !exists("added_plugins")
        let added_plugins = []
    endif
    let added_plugins = added_plugins + [      
        \["these_plugins_will/be_added_to_the_defaults", {}],
    \]

" To disable certain plugins (list is just the plugin name):
    if !exists("disabled_plugins")
        let disabled_plugins = []
    endif
    let disabled_plugins = disabled_plugins + ["neoclide/coc.nvim"]

" To change the coc.nvim default installed plugins:
    if !exists("coc_plugins")
        let coc_plugins = []
    endif
    let coc_plugins = coc_plugins + ["these_will_override_defaults"]

" To add more coc.nvim default installed plugins:
    if !exists("added_coc_plugins")
        let added_coc_plugins = []
    endif
    let added_coc_plugins = added_coc_plugins + ["these_will_be_added_to_defaults"]

```

**Common settings in** `~/.shellrc.local`:
```
alias a=b
export PATH="/add_to_path/:$PATH"
```

## What it does

Primarily, this repo configures the terminal and vim/neovim.

### Terminal

- This repo will configure `zsh` and `bash` terminals. More config for `zsh` than for `bash`.
- Run `dotfiles-update` to get updates.
- Run `dotfiles-check` to see if recommended programs are installed on your system.
- These are the primary files:
    - `~/.bashrc` - for bash-only settings
    - `~/.zshrc` - for zsh-only settings
    - `~/.shellrc` - for common settings
    - `~/.shell_aliases` - for aliases
- The following files will be auto-loaded if they exist, so you can make changes you don't want to commit:
    - `~/.shellrc.local`
    - `~/.bashrc.local`
    - `~/.zshrc.local`
    - `~/.shellrc.local.loadbefore`
    - `~/.bashrc.local.loadbefore`
    - `~/.zshrc.local.loadbefore`
        - The `*.loadbefore` files are sourced before any other config.
- Many `zsh` plugins are included in this repo as submodules. `dotfiles-update` will update them.

### Vim

- `~/.vimrc` is where most of the configuration resides.
- `~/.vimrc.local` and `~/.vimrc.local.loadbefore` will be loaded if they exist.
- The `dotfiles-update` command will install/update all Vim plugins, through the `junegunn/vim-plug` plugin manager.
- For IDE-like features, Vim will be configured to use `neoclide/coc.nvim`.
    - Some plugins will be installed by default for Go, JSON, and Python.
    - Configuration for other languages will have to be done manually (`:h coc-nvim.txt@en`).

## Notes

- Do **not** use the `dotfiles add .` command. This will add all the untracked files in your home directory, which is **everything**.
    - Instead, add things individually using `dotfiles add <file>`.
    - This also applies to other commands like `dotfiles commit -a`.
    - If you do this accidentally, you'll have to `Ctrl+C` out of it while it's stuck, or unstage all the files you added if it somehow succeeds.
