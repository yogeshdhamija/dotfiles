# Dev Config

Here is a repository for development-related configuration files, like:

* `.bashrc`
* `.bash_aliases`

...etc.

## What this does:

It does **not** install anything. It will only clone the files into `~`.

## How to set up:

### Quick Start:

#### SSH: 
`source <(curl -s https://gist.githubusercontent.com/ydhamija96/d1481c18a463591bdfa199e5f0fdd3f0/raw)`
#### HTTPS: 
`source <(curl -s https://gist.githubusercontent.com/ydhamija96/4f56e815a9110b5a0fde4c4a32ad582f/raw)`

### Actual Process:

What works best is to follow the method below, which I found in [this article](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/).

* Clone:
    * HTTPS:
        * `git clone --bare https://github.com/ydhamija96/config.git $HOME/.cfg`
    * SSH:
        * `git clone --bare git@github.com:ydhamija96/config.git $HOME/.cfg`
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
