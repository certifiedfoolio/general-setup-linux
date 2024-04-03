#!/bin/bash

which dnf >/dev/null && { DISTRO="FEDORA"; exit 0; }
which apt-get >/dev/null && { DISTRO="DEBIAN"; }

echo "Detected distro: $DISTRO"

if [[ "$DISTRO" == "DEBIAN" ]]; then
    PKGMGR="apt"
fi
if [[ "$DISTRO" == "FEDORA" ]]; then
    PKGMGR="dnf"
fi

dialog --title "Uninstall Setup" \
--backtitle "Question" \
--yesno "Do you also want to uninstall dependencies?" 7 60

response=$?
case $response in
   0) UNDEP="YES";;
   1) UNDEP="NO";;
   255) UNDEP="YES" && echo "[ESC] key pressed. 'UNDEP variable set to [YES] by default.'";;
esac

rm -rf /.git

if [[ "$UNDEP" == "YES" ]]; then
    sudo $PKGMGR remove flatpak
    sudo $PKGMGR remove dialog
    sudo $PKGMGR remove unzip
    sudo $PKGMGR remove git
    echo "Setup has successfully uninstalled. Quitting..."
    exit 0;
    else
    echo "Setup has successfully uninstalled. Quitting..."
    exit 0;
fi
