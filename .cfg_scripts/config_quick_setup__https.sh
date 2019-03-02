git clone --bare https://github.com/ydhamija96/config.git $HOME/.cfg
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config checkout && cd ~ && config submodule init && config submodule update
source ~/.bash_aliases
config-update
cd ~ && chmod +x .check_environment.sh && ./.check_environment.sh
