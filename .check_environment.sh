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
    "fzf"
    "jq"
    "xmlstarlet"
    "yq"
    "pandoc"
    "pdflatex"
    "node"
    "yarn"
)
declare -a NAMES=(
    "NeoVim"
    "ZShell"
    "Ripgrep"
    "FZF"
    "jq"
    "XmlStarlet"
    "yq"
    "Pandoc"
    "TeX Live"
    "node"
    "yarn"
)
declare -a ADDITIONAL1=(
    "The Bettitor Editor"
    "Nicer Shell"
    "Grep, vim uses it for find-in-dir"
    "Fuzzy finder, vim uses it"
    "JSON Parsing CLI tool"
    "XML Parsing CLI tool"
    "YAML Parsing CLI tool, it requires jq to be installed"
    "Document converter, vim uses it for .md -> .pdf"
    "Document converter, vim uses it for .md -> .pdf"
    "JS runtime, vim uses it to install LSP plugin"
    "package manager, vim uses it to install LSP plugin"
)
declare -a ADDITIONAL2=(
    ""
    ""
    ""
    ""
    ""
    ""
    ""
    ""
    "apt: texlive texlive-latex-extra; BasicTeX mac package"
    ""
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
