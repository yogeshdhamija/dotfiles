# Load custom config
export LOCAL_CONFIG_OVERRIDES_LOADED=""
export LOCAL_CONFIG_OVERRIDES_NOT_LOADED=""
if [ -f ~/.bashrc.local.loadbefore ]; then
    export LOCAL_CONFIG_OVERRIDES_LOADED="~/.bashrc.local.loadbefore:$LOCAL_CONFIG_OVERRIDES_LOADED"
    source ~/.bashrc.local.loadbefore
else
    export LOCAL_CONFIG_OVERRIDES_NOT_LOADED="~/.bashrc.local.loadbefore:$LOCAL_CONFIG_OVERRIDES_NOT_LOADED"
fi

# Load FZF configuration
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Make up and down arrow use a prefix when cycling through history
if [ -t 1 ]
then
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
    bind '"\C-F": forward-word'
    bind '"\C-B": backward-word'
fi

# Load common config
if [ -f ~/.shellrc ]; then
    source ~/.shellrc
fi

# Load custom config
if [ -f ~/.bashrc.local ]; then
    export LOCAL_CONFIG_OVERRIDES_LOADED="~/.bashrc.local:$LOCAL_CONFIG_OVERRIDES_LOADED"
    source ~/.bashrc.local
else
    export LOCAL_CONFIG_OVERRIDES_NOT_LOADED="~/.bashrc.local:$LOCAL_CONFIG_OVERRIDES_NOT_LOADED"
fi

# Start shell prompt
command -v starship > /dev/null && eval "$(starship init bash)"

