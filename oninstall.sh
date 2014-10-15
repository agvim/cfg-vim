#!/bin/sh
# install spf13 and the configured bundles
$(dirname $0)/oninstall/installspf13.sh
# install statusline fonts
$(dirname $0)/oninstall/powerlinefonts.sh
# not installing YouCompleteMe now since it is not being cloned
# $(dirname $0)/oninstall/youcompleteme.sh
