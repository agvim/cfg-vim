#!/bin/sh
#install spf13 and the configured bundles
$(dirname $0)/oninstall/installspf13.sh
#install statusline fonts
$(dirname $0)/oninstall/statuslinefonts.sh
#install YouCompleteMe
$(dirname $0)/oninstall/youcompleteme.sh
