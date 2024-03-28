#!/bin/bash

sudo ln -s /.git/setup-installer/setup.sh /setup.sh

TMPFILE=$(mktemp)
DIR=/.git/setup
MDIR=/.git

dialog --menu "Welcome to Setup! Please choose an option:" 20 60 5 \
    1 "Install GTK Theme" \
    2 "Install Gnome Extensions" \
    3 "Install Gnome Tweaks" \
    4 "Install Flathub Apps" \
    5 "Uninstall Setup" 2>$TMPFILE

RESULT=$(cat $TMPFILE)

case $RESULT in
    1) bash $DIR/gtk-inst.sh;;
    2) clear && flatpak install org.gnome.Extensions && echo "Installed successfully." && sleep 1 && bash /setup.sh;;
    3) bash $DIR/install-twe.sh;;
    4) bash $DIR/appinstaller.sh;;
    5) clear && rm -rf $MDIR && echo "Setup has uninstalled successfully." && exit 0;;
    *) echo "Setup has quit." && echo "If you wish to run setup again, please run 'bash /setup.sh'.";;
esac
