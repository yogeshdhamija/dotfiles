#!/bin/bash

declare -a EXECS=(
    "nvim"
    "starship"
    "zsh"
    "rg"
    "bat"
    "exa"
    "jq"
    "yq"
)
declare -a NAMES=(
    "Neovim"
    "Starship"
    "ZShell"
    "Ripgrep"
    "Bat"
    "Exa"
    "jq"
    "yq"
)
declare -a ADDITIONAL1=(
    "Widely used rewrite of Vim that has some new features"
    "Helpful prompt for terminal"
    "Shell"
    "Grep"
    "Like cat, but better"
    "Like ls, but better"
    "JSON Parsing CLI tool"
    "YAML and XML Parsing CLI tool"
)
declare -a ADDITIONAL2=(
    "https://neovim.io/"
    "https://starship.rs"
    ""
    "https://github.com/BurntSushi/ripgrep"
    "https://github.com/sharkdp/bat"
    "https://github.com/ogham/exa"
    "https://stedolan.github.io/jq/"
    "https://github.com/kislyuk/yq"
)
IFS=':' read -r -a local_config_overrides_loaded <<< "$LOCAL_CONFIG_OVERRIDES_LOADED"
IFS=':' read -r -a local_config_overrides_not_loaded <<< "$LOCAL_CONFIG_OVERRIDES_NOT_LOADED"

programs_arraylength=${#EXECS[@]}

echo ""
echo "***            CONFIGURATION STATUS CHECK            ***"
echo ""

echo "Programs found in PATH:"
for (( i=1; i<${programs_arraylength}+1; i++ ));
do
    if command -v ${EXECS[$i-1]} > /dev/null ; then
        echo '    -' ${NAMES[$i-1]} '('${EXECS[$i-1]}')'
    fi
done
echo '   ***'

echo "Programs not found in PATH:" 
for (( i=1; i<${programs_arraylength}+1; i++ ));
do
    if ! command -v ${EXECS[$i-1]} > /dev/null ; then
        echo '    -' ${NAMES[$i-1]} '('${EXECS[$i-1]}')'
        [[ ! -z ${ADDITIONAL1[$i-1]} ]] && echo '        ' ${ADDITIONAL1[$i-1]}
        [[ ! -z ${ADDITIONAL2[$i-1]} ]] && echo '        ' ${ADDITIONAL2[$i-1]}
        echo ""
    fi
done
echo '   ***'

echo "Local configuration override files loaded:"
printf '    %s\n' "${local_config_overrides_loaded[@]}"
printf '   ***\n'

echo "Local configuration override files checked and did not exist, so not loaded:"
printf '    %s\n' "${local_config_overrides_not_loaded[@]}"
printf '   ***\n'

echo ""
echo ""
