alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

changes=$(dotfiles status --porcelain)
pushed=$(dotfiles remote show origin | grep 'master pushes to master (up to date)')

printf '%s' "dotfiles"
if [[ "${changes}" ]]; then
	printf '%s' " uncommitted"
fi
if [[ ! "${pushed}" ]]; then
	printf '%s' " unpushed"
fi
