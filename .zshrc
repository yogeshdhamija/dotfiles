# Load custom config
if [ -f ~/.prelocalshellrc ]; then
    . ~/.prelocalshellrc
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="steeef"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.custom_zsh

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  docker
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

# Config alias
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Load aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# LSCOLORS in case dircolors doesn't work (on mac) for pretty ls colors
export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD

# Dircolors (on ubuntu) for pretty ls colors
[ -x '/usr/bin/dircolors' ] && eval `/usr/bin/dircolors ~/.dircolors-solarized/dircolors.256dark`

# Load FZF configuration
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Set up LESS 
export LESS="-RXF"

# Set up FZF to use Silver Searcher (ag)
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -g ""'
export FZF_CTRL_T_COMMAND='ag --hidden --ignore .git -g ""'

# Bind shortcuts
bindkey ^W forward-word
bindkey ^B backward-word
bindkey ^D backward-kill-word
bindkey ^E end-of-line
bindkey ^A beginning-of-line

# Load custom config
if [ -f ~/.localshellrc ]; then
    . ~/.localshellrc
fi
