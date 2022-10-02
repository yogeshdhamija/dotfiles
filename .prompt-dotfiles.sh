alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

changes=$(dotfiles status --porcelain)
unpushed=$(dotfiles remote show origin | grep 'master pushes to master')

if [[ "${changes}" || "${unpushed}" ]]; then
	printf '%s' "dotfiles"
fi
if [[ "${changes}" ]]; then
	printf '%s' " uncommitted"
fi
if [[ "${unpushed}" ]]; then
	printf '%s' " unpushed"
fi
