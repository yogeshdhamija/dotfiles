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

## Commands provided (aliases)

```bash
dotfiles-update     # pulls new updates, including for submodules
dotfiles-check      # checks if recommended programs installed

# use like git:
dotfiles status
dotfiles add file
dotfiles commit
dotfiles push
```

## What it does

Configures terminals and text editors to my preferences.

## Terminal

- This repo will configure the `bash`,`zsh`, and `fish` terminals.
- These are the primary files used to configure things:
    - `~/.bashrc` - for bash-only settings
    - `~/.zshrc` - for zsh-only settings
    - `~/.config/fish/config.fish` - for fish-only settings
    - `~/.shellrc` - for common settings across POSIX shells (`bash` and `zsh`)
    - `~/.shell_aliases` - for aliases (`bash`, `zsh`, and `fish`)
- The following files will be auto-loaded if they exist, so you can make changes you don't want to commit:
    - `~/.shellrc.local`
    - `~/.bashrc.local`
    - `~/.zshrc.local`
    - `~/.config/fish/config.fish.local`
    - `~/.shellrc.local.loadbefore`
    - `~/.bashrc.local.loadbefore`
    - `~/.zshrc.local.loadbefore`
    - `~/.config/fish/config.fish.local.loadbefore`
        - The `*.loadbefore` files are sourced before any other config.

## Text Editors

Configures editors to be vim-like. Editors are: Vim, Neovim, VSCode (with the VSCode-Neovim plugin), Jetbrains IDEs (with the IdeaVim plugin), Zed.

### For Vim-Like editors (Vim, Neovim, and the VSCode-Neovim plugin):

The `~/.vimrc` acts as the base where all mappings and commands are defined. Neovim and VSCode-Neovim configurations extend that file to override or add functionality.

- All mappings and commands in `~/.vimrc`
    - These mappings call functions which can be defined in:
        -  `~/.vimrc` If it's vim-specific or default implementation (may be overridden).
        -  `~/.config/nvim/init.vim` If it's neovim-specific.
        -  `~/.vscodevimrc` If it's vscode-neovim specific.

- File sourcing order (from first to last) is:

```bash
    ~/.config/nvim/init.vim             # only if Neovim
    ~/.vscodevimrc                      # only if VSCode-Neovim
    .vim/vimrc.local.loadbefore
    ~/.vimrc.local.loadbefore

    ~/.vimrc

    ~/.vimrc.local
    .vim/vimrc.local
```

- The `dotfiles-update` terminal command will install/update all Vim plugins, through the `junegunn/vim-plug` plugin manager.

**Configuring vim plugins:**

The `*.local.loadbefore` vim files can be used to adjust which plugins are used. Common settings are:
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

### For non Vim-like editors (Jetbrains, Zed, VSCode):
The settings live in the editor-specific files. They try to duplicate the mappings and commands in `~/.vimrc` as much as possible. Files used are:

- `~/.ideavimrc` for Jetbrains IDEs' IdeaVim plugin.
- `~/.config/zed/` for Zed.
- `~/dotfile-backups/vscode/` for VSCode

### VSCode

The `~/dotfile-backups/vscode/` folder contains VSCode profile files, which contain all the settings and configuration to make VSCode load `~/.vscodevimrc` and behave like NeoVim.

This must be imported into VSCode manually.

I should remember to periodically export these profile files from VSCode, in case I make updates/changes. When I do that, I should remember to name the profile "Default" (though the file name can differ), otherwise I'll have trouble re-importing.

## Notes

- Do **not** use the `dotfiles add .` command. This will add all the untracked files in your home directory, which is **everything**.
    - Instead, add things individually using `dotfiles add <file>`.
    - This also applies to other commands like `dotfiles commit -a`.
    - If you do this accidentally, you'll have to `Ctrl+C` out of it while it's stuck, or unstage all the files if it somehow succeeds.
