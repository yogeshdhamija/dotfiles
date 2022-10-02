alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

check(){
	echo "" > '/tmp/dotfiles-status.txt'

	allgood=1
	changes=$(dotfiles status --porcelain)
	unpushed=$(dotfiles remote show origin | grep 'master pushes to master (fast-forwardable)')
	unpulled=$(dotfiles remote show origin | grep 'master pushes to master (local out of date)')

	printf '%s' "dotfiles" >> '/tmp/dotfiles-status.txt'
	if [[ "${changes}" ]]; then
		printf '%s' " uncommitted" >> '/tmp/dotfiles-status.txt'
		allgood=0
	fi
	if [[ "${unpushed}" ]]; then
		printf '%s' " unpushed" >> '/tmp/dotfiles-status.txt'
		allgood=0
	fi
	if [[ "${unpulled}" ]]; then
		printf '%s' " unpulled" >> '/tmp/dotfiles-status.txt'
		allgood=0
	fi
	if [[ "${allgood}" == 1 ]]; then
		printf '%s' " all good" >> '/tmp/dotfiles-status.txt'
	fi
}

if [[ $((1 + $RANDOM % 10)) -eq 9 ]]; then
	check &
fi

cat /tmp/dotfiles-status.txt
