#!/bin/zsh

# Make a .zshrc file if there isn't one already. The NVM install will use this at least.
[[ -f !/.zshrc ]] || touch ~/.zshrc

printf "** David's dev tools installer for a new Mac\n** It is restartable: re-run anytime to add just the missing tools\n\n"

if [[ -f /usr/local/bin/brew ]]; then
  printf "Homebrew package manager is installed OK"
else
  printf "Installing Homebrew from https://brew.sh\n * Brew is the de-facto package manager for MacOS.\n\n * Enter your login password to install it\n     ...then run this $0 script again when that's installed\n\n"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  exit
fi

InstallBrewCaskIfNotPresent()
{
  printf "Ensuring Brew Cask installed: $1\n"
  brew list --cask $1 > /dev/null || brew install --quiet --cask $1
}  

printf "# Checking for Homebrew 'casks' - non command-line tools that can also be installed easily with Homebrew\n\n"

InstallBrewCaskIfNotPresent visual-studio-code 
InstallBrewCaskIfNotPresent iterm2 


printf "\n# Checking for Node Version Manager (NVM)\n\n"

# Install nvm without Brew - you could use Brew, but there are post-install
# steps and it's harder to automate. So just use the NVM script which updates
# the .bash_rc / .zsh_rc files etc


if [[ -d ~/.nvm ]]; then
 printf "NVM seems to be installed because ~/.nvm exists. Cool\n"
else
 printf "Installing NVM using the direct NVM install script method\n"
 # TODO: maybe use /master/ instead of /v0.37.2/
 curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

 printf "\n\n*** YOU JUST INSTALLED NVM. Let's activate it:\n*** Kill this console and start a new one\n*** Then continue with $0\n\n"
 exit
fi

printf "\n\n# Installing non-cask Homebrew packages\n\n"

InstallBrewPackageIfNotPresent()
{
  printf "Ensuring Brew package installed: $1\n"
  brew list $1 > /dev/null || brew install --quiet $1
} 


InstallBrewPackageIfNotPresent tree # show tree of folders in CLI
InstallBrewPackageIfNotPresent cloc # Count lines of code
InstallBrewPackageIfNotPresent wget # Like curl, but not pre-installed on MacOS
InstallBrewPackageIfNotPresent lolcat # Sometimes you just want color. try   ls | lolcat
InstallBrewPackageIfNotPresent mdcat # Markdown cat. Try  mdcat README.ms

printf "\n$0 has completed its checks and installs.\n\n"