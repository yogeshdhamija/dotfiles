# Load custom config
#if [ -f ~/.bashrc.local.loadbefore ]; then
#    source ~/.bashrc.local.loadbefore
#elif [ -f ~/.shellrc.local.loadbefore ]; then
#    source ~/.shellrc.local.loadbefore
#fi
#
## Load common config
#if [ -f ~/.shellrc ]; then
#    source ~/.shellrc
#fi
#
## Load FZF configuration
#[ -f ~/.fzf.bash ] && source ~/.fzf.bash
#
## Make up and down arrow use a prefix when cycling through history
#if [ -t 1 ]
#then
#    bind '"\e[A": history-search-backward'
#    bind '"\e[B": history-search-forward'
#    bind '"\C-F": forward-word'
#    bind '"\C-B": backward-word'
#fi

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo " on ${BRANCH}${STAT}"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1`
	declare -a bits

	for I in\
		' !&&&modified:' ' ?&&&Untracked files'\
		' *&&&Your branch is ahead of' ' +&&&new file:'\
		' >&&&renamed:' ' x&&&deleted:'
	{
		[[ "$status" == *"${I#*&&&}"* ]] && bits+=("${I%&&&*}")
	}

	printf "%s" "${bits[@]}"
}

# set nice prompt
export PS1="\[\e[35m\]\u\[\e[m\] in \[\e[32m\]\w\[\e[m\]\[\e[36m\]\`parse_git_branch\`\[\e[m\] \\$ "

## Load custom config
#if [ -f ~/.bashrc.local ]; then
#    source ~/.bashrc.local
#elif [ -f ~/.shellrc.local ]; then
#    source ~/.shellrc.local
#fi
