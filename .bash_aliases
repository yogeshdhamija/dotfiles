function in() {
    # in command searches current directory for filename contining string
    find . -name "*$1*" -type f | grep -E "[^\/]*$"
}
function fin() {
    # is recursive egrep
    grep -RE $1 .
}
function windows() {
    # If using WSL, run the command as if run from CMD

    # I know this implementation is terrible. Fix it if it's causing problems.
    cmd.exe /C $1 $2 $3 $4 $5 $6 $7 $8 $9 
}

# To stop and destroy all docker containers, images, and volumes
alias "docker-nuke"='docker stop $(docker ps -a -q); docker rm $(docker ps -a -q); docker rmi $(docker images -q) --force; docker volume rm $(docker volume ls -f dangling=true -q)'

# Pretty git log
alias "git-log"="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"

# General stuff
alias "fucking"="sudo"

# Split horizontal using tmux
alias "hsplit"="tmux split-window -h"
alias "vsplit"="tmux split-window -v"

# Default Noble environment variables
alias "envs"="NOBLE_CONFIG_FILE=src/tests/fixtures/unify.json DBURL=mysql://unify:unify@127.0.0.1:3306/unify"
alias "envs-pp"="NOBLE_CONFIG_FILE=src/tests/fixtures/unify.json DBURL=mysql://unify:unify@127.0.0.1:3306/unify PYTHONPATH=src/"

