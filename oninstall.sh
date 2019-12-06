#!/bin/sh
# install the configured vim bundles
mkdir -p ~/.vim/autoload/
wget -O ~/.vim/autoload/plug.vim -- https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
$HOME/.homesick/repos/homeshick/bin/homeshick link cfg-vim
vim "+PlugInstall" '+qa!'
