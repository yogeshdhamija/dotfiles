# Config (dotfiles)

## Quick Start

To clone this repo into your home directory:

```bash
export REPO_URL=git@github.com:ydhamija96/config.git
git clone --bare $REPO_URL $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config checkout && cd ~ && config submodule init && config submodule update
source ~/.bash_aliases
config-update
cd ~ && chmod +x .check_environment.sh && ./.check_environment.sh
```

This will set up a git repository in the folder `~/.cfg` with a detached working tree. This way, you can treat your home directory if as if it were a git repository -- using the `config` command, instead of `git` -- and it won't do crazy stuff like interfere with your other git repositories. Source: [this article](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).

## What it does

Primarily, this repo configures the terminal and vim/neovim.

### Terminal

- This repo will configure `zsh` and `bash` terminals. More config for `zsh` than for `bash`.
- Run `config-update` to get updates.
- Run `config-check` to see if recommended programs are installed on your system.
- These are the primary files:
    - `~/.bashrc` - for bash only settings
    - `~/.zshrc` - for zsh only settings
    - `~/.shellrc` - for common settings
    - `~/.bash_aliases` - for aliases
- If local settings need to be made which shouldn't be committed, the following files will be auto-loaded if they exist:
    - `~/.shellrc.local`
    - `~/.bashrc.local`
    - `~/.zshrc.local`
    - `~/.shellrc.local.loadbefore`
    - `~/.bashrc.local.loadbefore`
    - `~/.zshrc.local.loadbefore`
        - The `*.loadbefore` files are sourced at the top of the committed `*rc` files.
        - Note that `~/.shellrc.local` will not be loaded on a `zsh` terminal if `~/.zshrc.local` (more specific to `zsh`) exists.
- Many `zsh` plugins are included in this repo as submodules. `config-update` will update them.

### Vim

- `~/.vimrc` is where most of the configuration resides.
- `~/.vimrc.local` and `~/.vimrc.local.loadbefore` will be loaded if they exist.
- The `config-update` command will install/update all Vim plugins, through the `junegunn/vim-plug` plugin manager.
- For IDE-like features, Vim will be configured to use `neoclide/coc.nvim`.
    - Some plugins will be installed by default for Go, JSON, and Python.
    - Configuration for other languages will have to be done manually (`:h coc-nvim.txt@en`).

## Notes

- Do **not** use the `config add .` command. This will add all the untracked files in your home directory, which is **everything**.
    - Instead, add things individually using `config add <file>`.
    - This also applies to other stuff like `config commit -a`.
    - If you do this accidentally, you'll have to `Ctrl+C` out of it while it's stuck, or unstage all the files you added if it somehow succeeds.

