#!/bin/bash

# VARIABLES:
declare -a EXECS=(
    "nvim"
    "zsh"
    "ag"
    "pyls"
    "go-langserver"
    "tsserver"
    "pandoc"
    "pdflatex"
)
declare -a NAMES=(
    "NeoVim" 
    "ZShell"
    "The Silver Searcher"
    "Python LSP Server"
    "Go LSP Server"
    "TypeScript LSP-ish Server"
    "Pandoc"
    "TeX Live"
)
declare -a ADDITIONAL=(
    "Vim, but with integrated terminal."
    "Bash, but better. NOTE: \`chsh -s \$(which zsh)\` to change default terminal to zsh."
    "Provides cross-file fuzzy text searching for vim."
    "Allows linting, go-to-def, autocomplete, etc. features for Python code."
    "Allows linting, go-to-def, autocomplete, etc. features for Go code."
    "Allows linting, go-to-def, autocomplete, etc. features for TypeScript and JavaScript code."
    "Required for vim command to convert .md to .pdf."
    "Required for vim command to convert .md to .pdf. NOTE: For mac, install BasicTeX. For debian derivatives, apt install texlive texlive-latex-extra."
)

# SCRIPT:
arraylength=${#EXECS[@]}

echo "Cl9fICBfXyAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fICAgXyAgICAgICAgICBfX19fX18gICAgICAgICAgICAgICBfX19fIF8gICAgICAgClwgXC8gL19fX18gICBfX19fIF8gX19fICAgX19fX18gLyAvXyAoIClfX19fXyAgIC8gX19fXy9fX19fICAgX19fXyAgIC8gX18vKF8pX19fXyBfCiBcICAvLyBfXyBcIC8gX18gYC8vIF8gXCAvIF9fXy8vIF9fIFx8Ly8gX19fLyAgLyAvICAgIC8gX18gXCAvIF9fIFwgLyAvXyAvIC8vIF9fIGAvCiAvIC8vIC9fLyAvLyAvXy8gLy8gIF9fLyhfXyAgKS8gLyAvIC8gKF9fICApICAvIC9fX18gLyAvXy8gLy8gLyAvIC8vIF9fLy8gLy8gL18vIC8gCi9fLyBcX19fXy8gXF9fLCAvIFxfX18vL19fX18vL18vIC9fLyAvX19fXy8gICBcX19fXy8gXF9fX18vL18vIC9fLy9fLyAgL18vIFxfXywgLyAgCiAgICAgICAgICAvX19fXy8gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgL19fX18vICAgCg==" | base64 --decode && echo ""

echo "Welcome!"

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
