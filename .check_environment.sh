#!/bin/bash

# VARIABLES:
declare -a NOTES=(
    "Welcome!"
    "Here is some software integrated into this config (or just that I recommend)."
    "NOTE: Remember to set your terminal to use one of the provided fonts in the ~/.fonts directory."
)
declare -a EXECS=(
    "nvim"
    "zsh"
    "ag"
    "pandoc"
    "pdflatex"
    "pyls"
    "go-langserver"
    "jdtls"
    "javascript-typescript-stdio"
)
declare -a NAMES=(
    "NeoVim" 
    "ZShell"
    "The Silver Searcher"
    "Pandoc"
    "TeX Live"
    "Python LSP Server"
    "Go LSP Server"
    "Java LSP Server"
    "Javascript + Typescript LSP Server"
)
declare -a ADDITIONAL=(
    ""
    "NOTE: \`chsh -s \$(which zsh)\` to change default terminal to zsh."
    ""
    ""
    "NOTE: For mac, install BasicTeX. For debian derivatives, apt install texlive texlive-latex-extra."
    ""
    ""
    "NOTE: Add an executable file 'jdtls' to your PATH which runs the langserver (see: https://github.com/autozimu/LanguageClient-neovim/wiki/Java)."
    ""
)

# SCRIPT:
noteslength=${#NOTES[@]}
arraylength=${#EXECS[@]}

echo "Cl9fICBfXyAgICAgICAgICAgICAgICAgICAgICAgICAgIF9fICAgXyAgICAgICAgICBfX19fX18gICAgICAgICAgICAgICBfX19fIF8gICAgICAgClwgXC8gL19fX18gICBfX19fIF8gX19fICAgX19fX18gLyAvXyAoIClfX19fXyAgIC8gX19fXy9fX19fICAgX19fXyAgIC8gX18vKF8pX19fXyBfCiBcICAvLyBfXyBcIC8gX18gYC8vIF8gXCAvIF9fXy8vIF9fIFx8Ly8gX19fLyAgLyAvICAgIC8gX18gXCAvIF9fIFwgLyAvXyAvIC8vIF9fIGAvCiAvIC8vIC9fLyAvLyAvXy8gLy8gIF9fLyhfXyAgKS8gLyAvIC8gKF9fICApICAvIC9fX18gLyAvXy8gLy8gLyAvIC8vIF9fLy8gLy8gL18vIC8gCi9fLyBcX19fXy8gXF9fLCAvIFxfX18vL19fX18vL18vIC9fLyAvX19fXy8gICBcX19fXy8gXF9fX18vL18vIC9fLy9fLyAgL18vIFxfXywgLyAgCiAgICAgICAgICAvX19fXy8gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgL19fX18vICAgCg==" | base64 --decode && echo ""

for (( i=1; i<${noteslength}+1; i++ ));
do
    echo ${NOTES[$i-1]}
    echo ""
done

echo ""
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
