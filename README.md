# Config (dotfiles)

## Cheat Sheet

**Common settings in** `~/.vimrc.local.loadbefore`:
```
let plugins = [
        \["these_plugins_will/override_the_defaults", {}],
    \]
let added_plugins = [
        \["these_plugins_will/be_added_to_the_defaults", {}],
    \]
let disabled_plugins = ["neoclide/coc.nvim"]
let coc_plugins = ["these_will_override_defaults"]
let added_coc_plugins = ["these_will_be_added_to_defaults"]

let g:is_termguicolors_supported = 1
let g:gruvbox_italic=1
```

**Common settings in** `~/.vimrc.local`:
```
ColorSchemeOff
```

**Common settings in** `~/.shellrc.local`:
```
alias a=b
export PATH="/add_to_path/:$PATH"
```

## Quick Start

To clone this repo into your home directory:

```bash
export CONFIG_REPO_URL=git@github.com:ydhamija96/config.git
# OR
export CONFIG_REPO_URL=https://github.com/ydhamija96/config.git

source <(curl -Ls https://gist.githubusercontent.com/ydhamija96/c65eab14d4bfc62f2d3dd490b7f082d5/raw/8fafb174bab823f279eb882b28e67718b1ae9213/run.sh)
```

This will set up a git repository in the folder `~/.cfg` with a detached working tree. This way, you can treat your home directory if as if it were a git repository -- using the `config` command, instead of `git` -- and it won't do crazy stuff like interfere with your other git repositories. Source: [this article](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).

## What it does

Primarily, this repo configures the terminal and vim/neovim.

### Terminal

- This repo will configure `zsh` and `bash` terminals. More config for `zsh` than for `bash`.
- Run `config-update` to get updates.
- Run `config-check` to see if recommended programs are installed on your system.
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

## My favorite colors
- Dark background: `#20242C`
- Light background: `#FAFAFA`
- Cursor color: `#8D8F93`
- Red accent: `#e06c75`
- Blue accent: `#61afef`
- Green accent: `#98c379`
