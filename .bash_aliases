function windows() {
    # If using WSL, run the command as if run from CMD

    # TODO Fix this absurd security hole
    cmd.exe /C $1 $2 $3 $4 $5 $6 $7 $8 $9 
}

# To stop and destroy all docker containers, images, and volumes
alias "docker-nuke"='docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker rmi $(docker images -q) --force; docker volume rm $(docker volume ls -f dangling=true -q)'

# Pretty git log
alias "git-log"="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"

# General stuff
alias "fucking"="sudo"

# Check config status
alias "config-check"="cd ~; chmod +x .check_environment.sh; ./.check_environment.sh"
alias "config-update"="config submodule update --remote"

