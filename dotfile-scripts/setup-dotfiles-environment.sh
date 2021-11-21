#!/bin/bash

git clone --bare $DOTFILES_REPO_URL $HOME/.dotfiles
alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout && cd ~ && dotfiles submodule init && dotfiles submodule update
source ~/.shell_aliases
dotfiles-update
cd ~ && chmod +x .check_environment.sh && ./.check_environment.sh