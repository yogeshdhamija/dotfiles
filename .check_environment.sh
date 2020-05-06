#!/bin/bash

# VARIABLES:
declare -a NOTES=(
    "Welcome!"
    "Here is some software integrated into this config (or just that I recommend)."
)
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
    "Text Editor"
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
    "https://neovim.io/"
    ""
    "https://github.com/BurntSushi/ripgrep"
    "https://stedolan.github.io/jq/"
    "https://github.com/kislyuk/yq"
    "https://pandoc.org/"
    "https://www.tug.org/texlive/ | apt: texlive texlive-latex-extra | BasicTeX mac package"
    "https://nodejs.org/"
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
    if command -v ${EXECS[$i-1]} > /dev/null ; then
        echo '    -' ${NAMES[$i-1]} '('${EXECS[$i-1]}')'
        [[ ! -z ${ADDITIONAL1[$i-1]} ]] && echo '        ' ${ADDITIONAL1[$i-1]}
        [[ ! -z ${ADDITIONAL2[$i-1]} ]] && echo '        ' ${ADDITIONAL2[$i-1]}
        echo ""
    fi
done

echo ""

echo "Not found:" && echo ""
for (( i=1; i<${arraylength}+1; i++ ));
do
    if ! command -v ${EXECS[$i-1]} > /dev/null ; then
        echo '    -' ${NAMES[$i-1]} '('${EXECS[$i-1]}')'
        [[ ! -z ${ADDITIONAL1[$i-1]} ]] && echo '        ' ${ADDITIONAL1[$i-1]}
        [[ ! -z ${ADDITIONAL2[$i-1]} ]] && echo '        ' ${ADDITIONAL2[$i-1]}
        echo ""
    fi
done
