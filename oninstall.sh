#!/bin/sh
# install the configured vim bundles
mkdir -p ~/.vim/bundle/repos/github.com/Shougo/dein.vim
git clone --depth 1 https://github.com/Shougo/dein.vim ~/.vim/bundle/repos/github.com/Shougo/dein.vim
homeshick link cfg-vim
vim "+set nomore" "+call dein#install()" "+q!"

# install statusline fonts
$(dirname $0)/oninstall/powerlinefonts.sh
