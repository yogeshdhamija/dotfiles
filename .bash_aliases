function windows() {
    # If using WSL, run the command as if run from CMD

    # TODO Fix this absurd security hole
    cmd.exe /C $1 $2 $3 $4 $5 $6 $7 $8 $9 
}

# To stop and destroy all docker containers, images, and volumes
alias "docker-nuke"='docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker rmi $(docker images -q) --force; docker volume rm $(docker volume ls -f dangling=true -q)'
alias "docker-mininuke"='docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker volume rm $(docker volume ls -f dangling=true -q)'

# Pretty git log
alias "git-log"="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"

# General stuff
alias "fucking"="sudo"

# Check config status
alias "config-check"="cd ~ && chmod +x .check_environment.sh && ./.check_environment.sh && cd -"

# config-update: Pull from repo, check if any submodule updates exist, show status
alias "config-update"="cd ~ && config remote update && config pull && config checkout && config submodule init && config submodule update && config submodule update --remote && config status; mv ~/.vim/lastsession.vim ~/.vim/lastsession.vim.old > /dev/null 2>&1; vim +PlugUpgrade +PlugUpdate +ClearSession; mv ~/.vim/lastsession.vim.old ~/.vim/lastsession.vim > /dev/null 2>&1; cd -"

# Config pretty git log
alias "config-log"="config log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"
