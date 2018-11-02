#!/bin/bash

# VARIABLES:
declare -a EXECS=(
    "nvim"
    "zsh"
    "ag"
    "pyls"
    "go-langserver"
    "bash-language-server"
    "pandoc"
    "pdflatex"
)
declare -a NAMES=(
    "NeoVim" 
    "ZShell"
    "The Silver Searcher"
    "Python LSP Server"
    "Go LSP Server"
    "Bash LSP Server"
    "Pandoc"
    "BasicTeX"
)
declare -a ADDITIONAL=(
    "vim, but with integrated terminal"
    "\`chsh -s \$(which zsh)\` to change default terminal to zsh"
    "Provides cross-file fuzzy text searching for vim"
    ""
    ""
    ""
    "Required for vim command to convert .md to .pdf"
    "Required for vim command to convert .md to .pdf"
)

# SCRIPT:
arraylength=${#EXECS[@]}

echo "Here is some software integrated into this config (or just that I recommend)." && echo ""

echo "Already installed:" && echo ""
for (( i=1; i<${arraylength}+1; i++ ));
do
    if [ -x "$(command -v ${EXECS[$i-1]})" ]; then
        echo '    -' ${NAMES[$i-1]} '('${EXECS[$i-1]}')'
        [[ ! -z ${ADDITIONAL[$i-1]} ]] && echo '        ' ${ADDITIONAL[$i-1]} 
        echo ""
    fi
done

echo ""

echo "Not found:" && echo ""
for (( i=1; i<${arraylength}+1; i++ ));
do
    if ! [ -x "$(command -v ${EXECS[$i-1]})" ]; then
        echo '    -' ${NAMES[$i-1]} '('${EXECS[$i-1]}')'
        [[ ! -z ${ADDITIONAL[$i-1]} ]] && echo '        ' ${ADDITIONAL[$i-1]}
        echo ""
    fi
done
