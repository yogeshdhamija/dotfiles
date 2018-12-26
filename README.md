# Dev Config

Here is a repository for development-related configuration files, like:

* `.bashrc`
* `.bash_aliases`

...etc.

## What this does:

It does **not** install anything. It will only clone the files into `~`.

## How to set up:

What works best is to follow the method below, which I found in [this article](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).

* `git clone --bare <THIS_REPO-URL> $HOME/.cfg`
* `alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'`
* `config config --local status.showUntrackedFiles no`
* `config checkout && cd ~ && config submodule init && config submodule update`
* `cd ~ && chmod +x .check_environment.sh && ./.check_environment.sh`

This will set up a git repository in the folder `~/.cfg` with a detached working tree. This way, you can treat your home directory if as if it were a git repository
-- using the `config` command, instead of `git` -- and it won't do crazy stuff like interfere with your other git repositories.

## Notes:

- There will be many errors the first time you launch vim or neovim. Just skip through them-- it'll automatically install the plugins and then everything will be fine.
- Do **not** use the `config add .` command. This will add all the untracked files in your home directory, which is **everything**.
    - Instead, add things individually using `config add <file>`.
    - This also applies to other stuff like `config commit -a`.
    - If you do this accidentally, you'll have to `Ctrl+C` out of it while it's stuck, or unstage all the files you added if it somehow succeeds.
