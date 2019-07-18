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

# Make up and down arrow use a prefix when cycling through history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\C-F": forward-word'
bind '"\C-B": backward-word'

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
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

# set nice prompt
export PS1="\[\e[35m\]\u\[\e[m\] in \[\e[32m\]\w\[\e[m\]\[\e[36m\]\`parse_git_branch\`\[\e[m\] \\$ "

# Load custom config
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
elif [ -f ~/.shellrc.local ]; then
    source ~/.shellrc.local
fi
