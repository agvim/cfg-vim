#!/bin/bash
#we need the vimrc files to be linked in order to avoid installing unnecessary
#stuff and installing custom stuff

#if the homeshick repo has an update, re-link cfg-vim files before updating vim
if [[ $1 == 1 ]]; then
    homeshick=$HOME/.homesick/repos/homeshick/homeshick.sh
    $homeshick link cfg-vim
fi

#bootstrap works both for updating and for fresh setup
$HOME/.spf13-vim-3/bootstrap.sh

#clean up old views to avoid problems with updated plugins
rm -f $HOME/.vimviews/*
