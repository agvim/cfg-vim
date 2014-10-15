#!/bin/bash
# we need the vimrc files to be linked in order to avoid installing unnecessary
# stuff and installing custom stuff

# if the homeshick repo has an update, re-link cfg-vim files before updating vim
if [[ $1 == 1 ]]; then
    homeshick=$HOME/.homesick/repos/homeshick/bin/homeshick
    $homeshick link cfg-vim
fi

# FIXME: As long as UnBundle does not work in bootstrap, manually do the pull
# and the vundle commands
# #bootstrap works both for updating and for fresh setup
# $HOME/.spf13-vim-3/bootstrap.sh

# pull only the interesting spf13 branch
currdir=`pwd`
spf13_branch='3.0'
cd $HOME/.spf13-vim-3 && git pull origin "$spf13_branch"
vim +BundleInstall! +BundleClean! +qall
cd $currdir

# clean up old views to avoid problems with updated plugins
rm -f $HOME/.vimviews/*
