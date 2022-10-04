alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias "dotfiles-check"="cd ~ && chmod +x .check_environment.sh && ./.check_environment.sh && cd -"

printf '%s' "(dotfiles"
allgood=1

changes=$(dotfiles status --porcelain)
output=$(dotfiles remote show origin)
unpushed=$(echo "${output}" | grep 'master pushes to master (fast-forwardable)')
unpulled=$(echo "${output}" | grep 'master pushes to master (local out of date)')

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
printf '%s' ")"


printf '%s' " (environment"
need_programs=$(echo "$(dotfiles-check)" | tr '\n' '|' | tr -d ' ' | grep "ProgramsnotfoundinPATH:|.\+---|")

if [[ "${need_programs}" ]]; then
	printf '%s' " missing programs"
else
	printf '%s' " ✓"
fi
printf '%s' ")"
