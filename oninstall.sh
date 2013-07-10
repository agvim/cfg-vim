#!/bin/sh
#install spf13 and the configured bundles
$(dirname $0)/oninstall/installspf13.sh
#Install statusline fonts
$(dirname $0)/oninstall/statuslinefonts.sh
