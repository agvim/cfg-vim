#!/bin/bash
#Simple script that fixes powerline symbols

if [ -e ~/.vim/bundle/powerline ]
then
    #Download the latest version of PowerlineSymbols and the latest version of the fontconfig file. (already on the powerline bundle)
    #Move PowerlineSymbols.otf to ~/.fonts/ (or another X font directory).
    mkdir -p ~/.fonts/
    cp ~/.vim/bundle/powerline/font/PowerlineSymbols.otf ~/.fonts/

    #Run fc-cache -vf ~/.fonts to update your font cache.
    fc-cache -vf ~/.fonts

    #Move 10-powerline-symbols.conf to either ~/.fonts.conf.d/ or ~/.config/fontconfig/conf.d/, depending on your fontconfig version.
    mkdir -p ~/.config/fontconfig/conf.d/
    cp ~/.vim/bundle/powerline/font/10-powerline-symbols.conf ~/.config/fontconfig/conf.d/

    echo "vim powerline: If you don't see the arrow symbols, please close all instances of your terminal emulator or gvim. You may also have to restart X for the changes to take effect."
    #If you still don't see the arrow symbols, please submit an issue on GitHub."
fi
