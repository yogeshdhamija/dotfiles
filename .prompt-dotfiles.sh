alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

allgood=1
changes=$(dotfiles status --porcelain)
output=$(dotfiles remote show origin)
unpushed=$(echo "${output}" | grep 'master pushes to master (fast-forwardable)')
unpulled=$(echo "${output}" | grep 'master pushes to master (local out of date)')

printf '%s' "dotfiles"
if [[ "${changes}" ]]; then
	printf '%s' " uncommitted"
	allgood=0
fi
if [[ "${unpushed}" ]]; then
	printf '%s' " unpushed"
	allgood=0
fi
if [[ "${unpulled}" ]]; then
	printf '%s' " unpulled"
	allgood=0
fi
if [[ "${allgood}" == 1 ]]; then
	printf '%s' " ✓"
fi
