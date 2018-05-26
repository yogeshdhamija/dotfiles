# To stop and destroy all docker containers, images, and volumes
alias "docker-kill"='docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) && docker rmi $(docker images -q) --force && docker volume rm $(docker volume ls -f dangling=true -q)'

# Pretty git log
alias "git-log"="git log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --"

# Default Noble environment variables
alias "envs"="NOBLE_CONFIG_FILE=src/tests/fixtures/unify.json DBURL=mysql://unify:unify@127.0.0.1:3306/unify"
alias "envs-pp"="NOBLE_CONFIG_FILE=src/tests/fixtures/unify.json DBURL=mysql://unify:unify@127.0.0.1:3306/unify PYTHONPATH=src/"
