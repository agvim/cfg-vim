#!/bin/sh
#we need the vimrc files to be linked in order to avoid installing unnecessary
#stuff and installing custom stuff
homeshick=$HOME/.homesick/repos/homeshick/bin/homeshick

#clone the spf13-vim repo
git_branch='3.0'
git_uri='https://github.com/spf13/spf13-vim.git'
app_name='spf13-vim'
endpath="$HOME/.$app_name-3"
git clone --recursive -b "$git_branch" "$git_uri" "$endpath"

#before setting up plugins with bundle, link the homeshick vim config files so
#we do not download unwanted plugins
$homeshick link cfg-vim

#run the bootstrap script to download plugins and install spf13
$endpath/bootstrap.sh

#FIXME: As long as UnBundle does not work in bootstrap, manually clean the
#UnBundled plugins afterwards
vim +BundleInstall +BundleClean! +qall
