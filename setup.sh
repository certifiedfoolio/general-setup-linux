#!/bin/bash

DIR=/.git/setup
MDIR=/.git

TMPFILE=$(mktemp)

dialog --menu "Welcome to Setup! Please choose an option:" 20 60 5 \
    --backtitle "Theme Installer" \
    1 "Install GTK Theme" \
    2 "Install Gnome Extensions" \
    3 "Install Gnome Tweaks" \
    4 "Install Flathub Apps" \
    5 "Uninstall Setup" 2>$TMPFILE

RESULT=$(cat $TMPFILE)

echo $RESULT

case $RESULT in
    1) sudo bash $DIR/gtk-inst.sh;;
    2) INSTEXT="YES";;
    3) sudo bash $DIR/install-twe.sh;;
    4) sudo bash $DIR/appinstaller.sh;;
    5) sudo bash $DIR/uninst.sh;;
    *) echo "Setup has quit." && echo "If you wish to run setup again, please run 'bash /setup.sh'.";;
esac

if [[ "$INSTEXT" == "YES" ]]; then
    flatpak install flathub org.gnome.Extensions
    dialog --msgbox "Gnome Extensions has been installed successfully." 20 60
fi  