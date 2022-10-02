alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
changes=$(dotfiles status --porcelain)
if [[ ${changes} ]]; then
	echo "dotfiles uncommitted local changes"
fi
