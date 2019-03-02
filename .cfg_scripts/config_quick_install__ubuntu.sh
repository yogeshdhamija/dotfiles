read -r -p "WARNING!!! This may seriously mess up your current setup. Are you sure you want to continue? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo "Okay! Please wait."
        ;;
    *)
        echo "Exiting! Nothing was done."
        exit
        ;;
esac

# ZSH:
sudo apt install -y zsh
chsh -s $(which zsh)

# Apt repos:
sudo add-apt-repository -y ppa:longsleep/golang-backports
sudo apt-get update

# Apt packages:
sudo apt install -y vim neovim silversearcher-ag pandoc texlive texlive-latex-extra python3 python3-pip golang-go npm openjdk-8-jdk

# javascript-typescript-langserver:
sudo npm install -g javascript-typescript-langserver

# pyls:
sudo pip3 install -U --system setuptools
sudo pip3 install -U --system 'python-language-server[all]'

# golang, and go-langserver:
mkdir $HOME/Stuff/golang_workdir -p
export GOPATH=$HOME/Stuff/golang_workdir
echo "export GOPATH=$HOME/Stuff/golang_workdir" >> ~/.localshellrc
export PATH=$PATH:$(go env GOPATH)/bin
echo "export PATH=\$PATH:$(go env GOPATH)/bin" >> ~/.localshellrc
go get -u github.com/sourcegraph/go-langserver

# jdtls (java language server):
mkdir -p $HOME/Stuff/Deps/jdtls
cd $HOME/Stuff/Deps/jdtls
curl -OL https://download.eclipse.org/jdtls/snapshots/jdt-language-server-latest.tar.gz
tar -xzvf jdt-language-server-latest.tar.gz
rm -rf ./jdt-language-server-latest.tar.gz
echo "#!/usr/bin/env sh\nserver='$(pwd)'\njava -Declipse.application=org.eclipse.jdt.ls.core.id1 -Dosgi.bundles.defaultStartLevel=4 -Declipse.product=org.eclipse.jdt.ls.core.product -noverify -Xms1G -jar $server/plugins/org.eclipse.equinox.launcher_1.*.jar -configuration $server/config_linux/ "$@"\n" > jdtls
chmod +x ./jdtls
export PATH=$PATH:$(pwd)
echo "export PATH=\$PATH:$(pwd)" >> ~/.localshellrc

cd ~

cd ~ && chmod +x .check_environment.sh && ./.check_environment.sh
