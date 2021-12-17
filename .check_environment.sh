#!/bin/bash

declare -a EXECS=(
    "nvim"
    "zsh"
    "rg"
    "jq"
    "yq"
    "pandoc"
    "pdflatex"
    "node"
    "npm"
)
declare -a NAMES=(
    "NeoVim"
    "ZShell"
    "Ripgrep"
    "jq"
    "yq"
    "Pandoc"
    "TeX Live"
    "node"
    "npm"
)
declare -a ADDITIONAL1=(
    "The Bettitor Text Editor"
    "Shell"
    "Grep"
    "JSON Parsing CLI tool"
    "YAML and XML Parsing CLI tool"
    "Document converter, vim uses it for .md -> .pdf"
    "Document converter, vim uses it for .md -> .pdf"
    "JS runtime, vim uses it to run coc.nvim plugin (https://github.com/neoclide/coc.nvim), used for LSP"
    "JS package manager, vim uses it to install coc.nvim plugin (https://github.com/neoclide/coc.nvim), used for LSP"
)
declare -a ADDITIONAL2=(
    "https://github.com/neovim/neovim"
    ""
    "https://github.com/BurntSushi/ripgrep"
    "https://stedolan.github.io/jq/"
    "https://github.com/kislyuk/yq"
    "https://pandoc.org/"
    "https://www.tug.org/texlive/ | apt: texlive texlive-latex-extra | BasicTeX mac package"
    "https://nodejs.org/"
    ""
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

echo "Local configuration override files loaded:"
printf '    %s\n' "${local_config_overrides_loaded[@]}"

echo "Local configuration override files checked and did not exist, so not loaded:"
printf '    %s\n' "${local_config_overrides_not_loaded[@]}"

echo ""
echo ""
