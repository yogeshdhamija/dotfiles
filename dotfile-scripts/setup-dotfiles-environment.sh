#!/bin/bash

git clone --bare $DOTFILES_REPO_URL $HOME/.dotfiles
export DOTFILES_COMMAND='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias dotfiles="${DOTFILES_COMMAND}"
dotfiles config --local status.showUntrackedFiles no
dotfiles config remote.origin.fetch "+refs/heads/*:refs/remotes/origin/*" 
dotfiles checkout && cd ~ && dotfiles submodule init && dotfiles submodule update
source ~/.shell_aliases
dotfiles-update
