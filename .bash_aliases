function windows() {
    # If using WSL, run the command as if run from CMD

    # TODO Fix this absurd security hole
    cmd.exe /C $1 $2 $3 $4 $5 $6 $7 $8 $9 
}

# To stop and destroy all docker containers, images, and volumes
alias "docker-nuke"='docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker rmi $(docker images -q) --force; docker volume rm $(docker volume ls -f dangling=true -q)'

# To stop and destroy all docker containers and volumes (but keep images)
alias "docker-mininuke"='docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker volume rm $(docker volume ls -f dangling=true -q)'

# Pretty git log
alias "git-log"="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"

# I am Vim
alias ":q"="exit"
alias ":e"="vim"

# Check config status
alias "config-check"="cd ~ && chmod +x .check_environment.sh && ./.check_environment.sh && cd -"

# Check if repo updates exist (also submodules)
alias "config-update-repo"="cd ~ && config remote update && config pull && config checkout && config submodule init && config submodule update && config submodule update --remote && config status; cd -"

# Update vim plugins
alias "config-update-vim"="cd ~ && mv ~/.vim/lastsession.vim ~/.vim/lastsession.vim.old > /dev/null 2>&1; vim +PlugUpgrade +PlugUpdate +ClearSession; mv ~/.vim/lastsession.vim.old ~/.vim/lastsession.vim > /dev/null 2>&1; cd -"

# Update fzf
alias "config-update-fzf"="cd ~ && .fzf/install --all && cd -"

# config-update: Pull from repo, check if any submodule updates exist, show status
alias "config-update"="config-update-repo; config-update-vim; config-update-fzf"

# Config pretty git log
alias "config-log"="config log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
