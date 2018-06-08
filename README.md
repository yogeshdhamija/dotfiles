# Dev Config

Here is a repository for development-related configuration files, like:

* `.bashrc`
* `.bash_aliases`

...etc.

## How to set up:

It's cool if this repository tracks your home directory (`~`). However, if you make your home directory a git repository, it starts
to become really annoying-- it tracks all your changes, or if you add `*` to the .gitignore, it will effect your subrepositories.

What works best is to follow the method below, which I found in [this article](https://www.electricmonk.nl/log/2015/06/22/keep-your-home-dir-in-git-with-a-detached-working-directory/).

* `mkdir ~/.dotfiles/`
* `git clone <THIS_REPO> ~/.dotfiles`
* `alias dgit='git --git-dir ~/.dotfiles/.git --work-tree=$HOME'`

This will set up a git repository in the folder `~/.dotfiles` with a detached working tree. This way, you can treat your home directory if as if it were a git repository
-- using the `dgit` command, instead of `git` -- but it won't do crazy stuff like interfere with your other git repositories. 


### Important:

*The `.gitignore` is set to ignore everything by default!*
Make sure to add rules for any files you want to push.
