alias dotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias "dotfiles-check"="cd ~ && chmod +x .check_environment.sh && ./.check_environment.sh && cd -"

if [[ "$((1 + $RANDOM % 20))" == 9 ]]; then
	rm /tmp/dotfiles-prompt-remote.txt
	dotfiles remote show origin > /tmp/dotfiles-prompt-remote.txt

	rm /tmp/dotfiles-prompt-status.txt
	dotfiles status --porcelain > /tmp/dotfiles-prompt-status.txt
fi

if [[ "$1" == "dotfiles" ]]; then
	printf '%s' "(dotfiles"
	allgood=1

	changes=$(cat /tmp/dotfiles-prompt-status.txt)
	output=$(cat /tmp/dotfiles-prompt-remote.txt)
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

elif [[ "$1" == "programs" ]]; then
	printf '%s' " (environment"
	need_programs=$(echo "$(dotfiles-check)" | tr -d '\n' | tr -d ' ' | grep "ProgramsnotfoundinPATH:.\+\*\*\*Localconfigurationoverridefilesloaded")
	if [[ "${need_programs}" ]]; then
		printf '%s' " missing programs"
	else
		printf '%s' " ✓"
	fi
	printf '%s' ")"

elif [[ "$1" == "locals" ]]; then
	has_locals=$(echo "$(dotfiles-check)" | tr -d '\n' | tr -d ' ' | grep "Localconfigurationoverridefilesloaded:.\+\*\*\*Localconfigurationoverridefileschecked")

	if [[ "${has_locals}" ]]; then
		printf '%s' " (local overrides)"
	fi
fi
