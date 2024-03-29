#!/bin/bash
# we need the vimrc files to be linked in order to avoid installing unnecessary
# stuff and installing custom stuff

# if the homeshick repo has an update, re-link cfg-vim files before updating vim
if [[ $1 == 1 ]]; then
    homeshick=$HOME/.homesick/repos/homeshick/bin/homeshick
    $homeshick link cfg-vim
fi

which nvim &> /dev/null
if [ $? ]
then
    vim="nvim"
else
    vim="vim"
fi
$vim "+PlugUpgrade" "+PlugUpdate" '+qa!'
