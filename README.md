# Dev Config

Here is a repository for development-related configuration files, like:

* `.bashrc`
* `.bash_aliases`

...etc.

## How to set up:

It's cool if this repository tracks your home directory (`~`). However, if you make your home directory a git repository, it starts
to become really annoying-- it tracks all your changes, or if you add `*` to the .gitignore, it will effect your subrepositories.

What works best is to follow the method below, which I found in [this article](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).

* `git clone --bare <THIS_REPO-URL> $HOME/.cfg`
* `alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'`
* `config config --local status.showUntrackedFiles no`
* `config checkout`

Optional:

To set your default terminal to zsh:
* `chsh -s $(which zsh)`

This will set up a git repository in the folder `~/.cfg` with a detached working tree. This way, you can treat your home directory if as if it were a git repository
-- using the `config` command, instead of `git` -- but it won't do crazy stuff like interfere with your other git repositories. 

### Useful things to have installed:

* neovim
* zsh
* the_silver_searcher
* desired LSP language servers

### Important:

* __Do **not** use the `config add .` command. This will add all the untracked files in your home directory, which is **everything**.__

    Instead, add things individually using `config add <file>`.

    This also applies to other stuff like `config commit -a`. 


