#!/bin/sh
#we need the vimrc files to be linked in order to avoid installing unnecessary
#stuff and installing custom stuff
homeshick=$HOME/.homesick/repos/homeshick/homeshick.sh
$homeshick link cfg-vim
wget http://j.mp/spf13-vim3 -O /tmp/spf13-vim.sh && sh /tmp/spf13-vim.sh
