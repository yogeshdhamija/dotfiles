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
Make sure to add rules for any files you want to push. And add them to the terrible documentation below.

## Documentation:
### Last updated: 2018-06-12

Stuff that is tracked by git:

* README.md
    * This is the readme you are currently reading.
* .bashrc
    * Contains the `dgit` alias (see 'How to set up' section above)
    * Loads `.bash_aliases` and `.bash_prompt`
    * Has ssh auto-completion magic
* .bash_aliases
    * Has most of the aliases for ease
    * Pasted here for easy remembering:
        ```bash
        # To stop and destroy all docker containers, images, and volumes
        alias "docker-murder"='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) && docker rmi $(docker images -q) --force && docker volume rm $(docker volume ls -f dangling=true -q)'

        # Restart Noble docker
        alias "docker-up"="docker-compose up -d mariadb"

        # Pretty git log
        alias "git-log"="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"

        # Split horizontal using tmux
        alias "tsh"="tmux split-window -h"
        alias "tsv"="tmux split-window -v"

        # Default Noble environment variables
        alias "envs"="NOBLE_CONFIG_FILE=src/tests/fixtures/unify.json DBURL=mysql://unify:unify@127.0.0.1:3306/unify"

        alias "envs-pp"="NOBLE_CONFIG_FILE=src/tests/fixtures/unify.json DBURL=mysql://unify:unify@127.0.0.1:3306/unify PYTHONPATH=src/"

        ```
* .vimrc
    * Basic vim settings
* .zshrc
    * Loads up `.bash_aliases` but *not* `.bash_prompt`, so if you want to use zshell instead of bash, add it and update the documentation.
* .bash_prompt
    * Adds some cool git features to the prompt
    * Adds some cool Python virtualenv features to the prompt
* .tmux.conf
    * Basic tmux settings
