# Load custom config
if [ -f ~/.zshrc.local.loadbefore ]; then
    source ~/.zshrc.local.loadbefore
fi
if [ -f ~/.shellrc.local.loadbefore ]; then
    source ~/.shellrc.local.loadbefore
fi

# oh my zsh stuff
export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM=$HOME/.custom_zsh
DISABLE_AUTO_UPDATE="true"

# Completion settings
HYPHEN_INSENSITIVE="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirtysource This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

HIST_STAMPS="yyyy-mm-dd"
ZSH_THEME="half-life"

plugins=(
  docker-compose
  web-search
  ssh
  colored-man-pages
  zsh-autosuggestions
  zsh-syntax-highlighting
  gradle
)

# Load oh my zsh
source $ZSH/oh-my-zsh.sh

# Load FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Bind shortcuts
bindkey ^F forward-word
bindkey ^B backward-word
bindkey ^W backward-kill-word

# LSCOLORS in case dircolors doesn't work (on mac) for pretty ls colors
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
# Dircolors (on ubuntu) for pretty ls colors
[ -x '/usr/bin/dircolors' ] && eval `/usr/bin/dircolors ~/.dircolors-solarized/dircolors.256dark`

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=240"

# Get theme to refresh git status on every prompt load
function my_preexec { PR_GIT_UPDATE=1 }
add-zsh-hook preexec my_preexec

# Get zsh to show Ctrl+C on cancelled command
TRAPINT() {
  print -n "^C"
  return $(( 128 + $1 ))
}

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}
pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# Load common config
if [ -f ~/.shellrc ]; then
    source ~/.shellrc
fi

# Load custom config
if [ -f ~/.shellrc.local ]; then
    source ~/.shellrc.local
fi
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
