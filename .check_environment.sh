#!/bin/bash

# VARIABLES:
declare -a EXECS=(
    "nvim"
    "zsh"
    "ag"
    "pyls"
    "typescript-language-server"
    "go-langserver"
    "bash-language-server"
)
declare -a NAMES=(
    "neovim"
    "zsh"
    "the_silver_searcher"
    "python-language-server"
    "typescript-language-server"
    "go-langserver"
    "bash-language-server"
)
declare -a ADDITIONAL=(
    ""
    "\`chsh -s \$(which zsh)\` to change default terminal to zsh"
    ""
    ""
    ""
    ""
    ""
)


# SCRIPT:
arraylength=${#EXECS[@]}

echo ""

echo "Already installed:" && echo ""
for (( i=1; i<${arraylength}+1; i++ ));
do
    if [ -x "$(command -v ${EXECS[$i-1]})" ]; then
        echo '    ' ${NAMES[$i-1]} '('${EXECS[$i-1]}')'
        [[ ! -z ${ADDITIONAL[$i-1]} ]] && echo '        ' ${ADDITIONAL[$i-1]} && echo ""
    fi
done

echo ""

echo "Not found:" && echo ""
for (( i=1; i<${arraylength}+1; i++ ));
do
    if ! [ -x "$(command -v ${EXECS[$i-1]})" ]; then
        echo '    ' ${NAMES[$i-1]} '('${EXECS[$i-1]}')'
        [[ ! -z ${ADDITIONAL[$i-1]} ]] && echo '        ' ${ADDITIONAL[$i-1]} && echo ""
    fi
done

echo "" && echo "" && echo "IMPORTANT: Remember not to \`config add .\` or run other git commands with \`.\`"
