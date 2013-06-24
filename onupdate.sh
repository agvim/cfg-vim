#!/bin/sh
#we need the vimrc files to be linked in order to avoid installing unnecessary
#stuff and installing custom stuff
homeshick=$HOME/.homesick/repos/homeshick/homeshick.sh
$homeshick link cfg-vim
#bootstrap works both for updating and for fresh setup
$HOME/.spf13-vim-3/bootstrap.sh
