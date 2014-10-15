#!/bin/bash
# Simple script that fixes powerline symbols

if [[ -e ~/.vim/bundle/vim-airline  && ! -e ~/.config/fontconfig/conf.d/10-powerline-symbols.conf ]]
then
    # Download the latest version of PowerlineSymbols and the latest version of the fontconfig file.
    # Move PowerlineSymbols.otf to ~/.fonts/ (or another X font directory).
    mkdir -p ~/.fonts/
    wget -nv -O ~/.fonts/PowerlineSymbols.otf https://github.com/Lokaltog/powerline/raw/develop/font/PowerlineSymbols.otf

    # Run fc-cache -vf ~/.fonts to update your font cache.
    fc-cache -vf ~/.fonts

    # Move 10-powerline-symbols.conf to either ~/.fonts.conf.d/ or ~/.config/fontconfig/conf.d/, depending on your fontconfig version.
    mkdir -p ~/.config/fontconfig/conf.d/
    wget -nv -O ~/.config/fontconfig/conf.d/10-powerline-symbols.conf https://github.com/Lokaltog/powerline/raw/develop/font/10-powerline-symbols.conf

    echo "vim airline: If you don't see the arrow symbols, please close all instances of your terminal emulator or gvim. You may also have to restart X for the changes to take effect."
    # If you still don't see the arrow symbols, please submit an issue on GitHub."
fi
