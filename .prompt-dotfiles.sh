dotfiles="git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

random="$((1 + $RANDOM % 20))" 

if [[ "$1" == "dotfiles" ]]; then
	printf '%s' "(dotfiles"
	if [[ "${random}" == 1 ]]; then
		remote=$($dotfiles remote show origin)

		rm /tmp/dotfiles-prompt-unpushed.txt
		echo "${remote}" | grep 'master pushes to master (fast-forwardable)' > /tmp/dotfiles-prompt-unpushed.txt
		rm /tmp/dotfiles-prompt-unpulled.txt
		echo "${output}" | grep 'master pushes to master (local out of date)' > /tmp/dotfiles-prompt-unpulled.txt

		rm /tmp/dotfiles-prompt-changes.txt
		$dotfiles status --porcelain > /tmp/dotfiles-prompt-changes.txt

		printf '%s' "!"
	fi

	allgood=1

	changes=$(cat /tmp/dotfiles-prompt-changes.txt)
	unpushed=$(cat /tmp/dotfiles-prompt-unpushed.txt)
	unpulled=$(cat /tmp/dotfiles-prompt-unpulled.txt)

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
	if [[ "${random}" == 2 ]]; then
		rm /tmp/dotfiles-prompt-programs.txt
		res=$(cd ~ && chmod +x .check_environment.sh && ./.check_environment.sh && cd -)
		echo "${res}" | tr -d '\n' | tr -d ' ' | grep "ProgramsnotfoundinPATH:.\+---Localconfigurationoverridefilesloaded" > /tmp/dotfiles-prompt-programs.txt
		printf '%s' "!"
	fi

	need_programs=$(cat /tmp/dotfiles-prompt-programs.txt)
	if [[ "${need_programs}" ]]; then
		printf '%s' " missing programs"
	else
		printf '%s' " ✓"
	fi
	printf '%s' ")"

elif [[ "$1" == "locals" ]]; then
	printf '%s' " (local overrides"
	if [[ "${random}" == 3 ]]; then
		rm /tmp/dotfiles-prompt-locals.txt
		res=$(cd ~ && chmod +x .check_environment.sh && ./.check_environment.sh && cd -)
		echo "${res}" | tr -d '\n' | tr -d ' ' | grep "Localconfigurationoverridefilesloaded:.\+---Localconfigurationoverridefileschecked" > /tmp/dotfiles-prompt-locals.txt
		printf '%s' "!"
	fi

	has_locals=$(cat /tmp/dotfiles-prompt-locals.txt)

	if [[ "${has_locals}" ]]; then
		printf '%s' " present ✓)"
	else
		printf '%s' " absent ✓)"
	fi
fi
