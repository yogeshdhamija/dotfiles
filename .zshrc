# Load custom config
export LOCAL_CONFIG_OVERRIDES_LOADED=""
export LOCAL_CONFIG_OVERRIDES_NOT_LOADED=""
if [ -f ~/.zshrc.local.loadbefore ]; then
    export LOCAL_CONFIG_OVERRIDES_LOADED="~/.zshrc.local.loadbefore:$LOCAL_CONFIG_OVERRIDES_LOADED"
    source ~/.zshrc.local.loadbefore
else
    export LOCAL_CONFIG_OVERRIDES_NOT_LOADED="~/.zshrc.local.loadbefore:$LOCAL_CONFIG_OVERRIDES_NOT_LOADED"
fi

# Load FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

bindkey ^F forward-word
bindkey ^B backward-word
bindkey ^W backward-kill-word

# Get zsh to show Ctrl+C on cancelled command
TRAPINT() {
  print -n "^C"
  return $(( 128 + $1 ))
}

# Load common config
if [ -f ~/.shellrc ]; then
    source ~/.shellrc
fi

# Load custom config
if [ -f ~/.zshrc.local ]; then
    export LOCAL_CONFIG_OVERRIDES_LOADED="~/.zshrc.local:$LOCAL_CONFIG_OVERRIDES_LOADED"
    source ~/.zshrc.local
else
    export LOCAL_CONFIG_OVERRIDES_NOT_LOADED="~/.zshrc.local:$LOCAL_CONFIG_OVERRIDES_NOT_LOADED"
fi

# Start shell prompt
command -v starship > /dev/null && eval "$(starship init zsh)"
