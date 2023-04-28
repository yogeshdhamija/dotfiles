# Dotfiles

## Quick Start

To clone this repo into your home directory:

```bash
export DOTFILES_REPO_URL=git@github.com:yogeshdhamija/dotfiles.git
# OR
export DOTFILES_REPO_URL=https://github.com/yogeshdhamija/dotfiles.git

source <(curl -Ls https://raw.githubusercontent.com/yogeshdhamija/dotfiles/master/dotfile-scripts/setup-dotfiles-environment.sh)
```

This will set up a git repository in the folder `~/.dotfiles` with a detached working tree. This way, you can treat your home directory if as if it were a git repository -- using the `dotfiles` command, instead of `git` -- and it won't do crazy stuff like interfere with your other git repositories. Source: [this article](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/). In summary: `dotfiles status`, `dotfiles commit`, `dotfiles push`.

## Cheat Sheet

**Commands to remember**:
```bash
dotfiles-update     # pulls new updates, including for submodules
dotfiles-check      # checks if recommended programs installed

# use like git:
dotfiles status
dotfiles add file
dotfiles commit
dotfiles push
```

**Common settings in** `~/.vimrc.local.loadbefore`:
```viml
" To add more plugins (using vim-plug)
    if !exists("added_plugins")
        let added_plugins = []
    endif
    let added_plugins = added_plugins + [
        \["these_plugins_will/be_added_to_the_defaults", {}],
    \]

" To disable certain default plugins
    if !exists("disabled_plugins")
        let disabled_plugins = []
    endif
    let disabled_plugins = disabled_plugins + ["neoclide/coc.nvim"]

" To run with ONLY specified plugins (not recommended)
    if !exists("plugins")
        let plugins = []
    endif
    let plugins = plugins + [
        \["only_these_plugins/will_be_used", {}],
    \]
```

**Common settings in** `~/.shellrc.local`:
```bash
alias a=b
export PATH="/add_to_path/:$PATH"
```

## What it does

Primarily, this repo configures the terminal and vim/neovim.

### Terminal

- This repo will configure `zsh` and `bash` terminals.
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
- Some `zsh` plugins are included in this repo as submodules.

### Vim & Neovim

This repo provides a `~/.vimrc` which defines all custom mappings/commands. The `~/.vimrc` is extended upon by other files to support other programs (Neovim and VSCode-Neovim).

- All mappings/remaps in `~/.vimrc`
    - These mappings call functions which may be defined in:
        -  `~/.vimrc` If it's a default implementation (overridden with enhanced functionality elsewhere), or if it's vim-specific
        -  `~/.config/nvim/init.vim` If it's a neovim specific implementation
        -  `~/.vscodevimrc` If it's a vscode-neovim specific implementation
    - Reasoning is so that the implementaton can change based on Vim, Neovim, or VScode-Neovim, but the mapping is only defined once

- File sourcing order (from first to last) is:

```bash
    ~/.config/nvim/init.vim             # only if pure Neovim
    ~/.vscodevimrc                      # only if Neovim embedded within VSCode
    .vim/vimrc.local.loadbefore         # only if exists in the directory vim/nvim was launched from
    ~/.vimrc.local.loadbefore           # only if exists

    ~/.vimrc

    ~/.vimrc.local                      # only if exists
    .vim/vimrc.local                    # only if exists in the directory nvim/vim was launched from
```

- The `dotfiles-update` terminal command will install/update all Vim plugins, through the `junegunn/vim-plug` plugin manager.

## Notes

- Do **not** use the `dotfiles add .` command. This will add all the untracked files in your home directory, which is **everything**.
    - Instead, add things individually using `dotfiles add file`.
    - This also applies to other commands like `dotfiles commit -a`.
    - If you do this accidentally, you'll have to `Ctrl+C` out of it while it's stuck, or unstage all the files if it somehow succeeds.
