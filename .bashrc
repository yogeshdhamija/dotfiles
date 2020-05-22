# Load custom config
export LOCAL_CONFIG_OVERRIDES=""
if [ -f ~/.bashrc.local.loadbefore ]; then
    export LOCAL_CONFIG_OVERRIDES="~/.bashrc.local.loadbefore:$LOCAL_CONFIG_OVERRIDES"
    source ~/.bashrc.local.loadbefore
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

# get current branch and status of git repo
function parse_git {
    # Read only first line, which should always be the current branch.
    read branch <<< "$(git branch 2> /dev/null)"

    status=`git status 2>&1`
    declare -a bits

    for I in\
        ' !&&&modified:' ' ?&&&Untracked files'\
        ' *&&&Your branch is ahead of' ' +&&&new file:'\
        ' >&&&renamed:' ' x&&&deleted:'
    {
        [[ "$status" == *"${I#*&&&}"* ]] && bits+=("${I%&&&*}")
    }

    # For removing initial field, but also for the if-empty situation.
    branch=" on ${branch#* }"
    [ "$branch" == ' on ' ] && unset branch

    # Branch names with spaces shouldn't be an issue here, as only the first
    # space-delimited field is ignored when reading the 'branch' variable.
    printf "%s%s" "$branch" "${bits[@]}"
}

# set nice prompt
export PS1="\[\e[35m\]\u\[\e[m\] in \[\e[32m\]\w\[\e[m\]\[\e[36m\]\`parse_git\`\[\e[m\] \\$ "

# Load common config
if [ -f ~/.shellrc ]; then
    source ~/.shellrc
fi

# Load custom config
if [ -f ~/.bashrc.local ]; then
    export LOCAL_CONFIG_OVERRIDES="~/.bashrc.local:$LOCAL_CONFIG_OVERRIDES"
    source ~/.bashrc.local
fi
