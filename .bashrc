# Load custom config
if [ -f ~/.bashrc.local.loadbefore ]; then
    source ~/.bashrc.local.loadbefore
elif [ -f ~/.shellrc.local.loadbefore ]; then
    source ~/.shellrc.local.loadbefore
fi

# Load common config
if [ -f ~/.shellrc ]; then
    source ~/.shellrc
fi


# Load FZF configuration
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Load custom config
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
elif [ -f ~/.shellrc.local ]; then
    source ~/.shellrc.local
fi
