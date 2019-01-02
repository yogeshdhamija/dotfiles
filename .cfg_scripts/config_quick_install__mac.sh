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

# Homebrew:
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# ZSH:
brew install zsh zsh-completions
chsh -s $(which zsh)

# Brew cask:
brew update
brew tap homebrew/cask-versions

# Brew packages:
brew install vim neovim the_silver_searcher pandoc python go node
brew cask install java

# BasicTeX: TODO

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
echo "#!/usr/bin/env sh\nserver='$(pwd)'\njava -Declipse.application=org.eclipse.jdt.ls.core.id1 -Dosgi.bundles.defaultStartLevel=4 -Declipse.product=org.eclipse.jdt.ls.core.product -noverify -Xms1G -jar $server/plugins/org.eclipse.equinox.launcher_1.*.jar -configuration $server/config_mac/ "$@"\n" > jdtls
chmod +x ./jdtls
export PATH=$PATH:$(pwd)
echo "export PATH=\$PATH:$(pwd)" >> ~/.localshellrc

cd ~

source ~/.bash_aliases
config-check
