#!/bin/sh
# install the configured vim bundles
mkdir -p ~/.vim/autoload/
wget -O ~/.vim/autoload/plug.vim -- https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# neovim compatibility
mkdir -p ~/.local/share/nvim/site/autoload/
ln -s ~/.vim/autoload/plug.vim ~/.local/share/nvim/site/autoload/plug.vim
mkdir -p ~/.config/nvim/
ln -s ~/.vimrc ~/.config/nvim/init.vim
homeshick link cfg-vim
vim "+PlugInstall" '+qa!'

# install statusline fonts
# $(dirname $0)/oninstall/powerlinefonts.sh
