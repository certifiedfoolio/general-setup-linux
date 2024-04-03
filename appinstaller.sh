#!/bin/bash

dialog --menu "Please choose an app to install:" 20 60 5 \
    1 "Install Discord" \
    2 "Install Vencord Patch"
    3 "Install Chromium" \
    4 "Install Spotify" \
    5 "Install Visual Studio Code" 2>$TMPFILE

RESULT=$(cat $TMPFILE)

case $RESULT in
    1) clear && echo "Installing Discord..." && yes | flatpak install flathub com.discordapp.Discord && clear;;
    2) clear && sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)" && clear;;
    3) clear && echo "Installing Chromium..." && yes | flatpak install flathub org.chromium.Chromium && clear;;
    4) clear && echo "Installing Spotify..." && yes | flatpak install flathub com.spotify.Client && clear;;
    5) clear && echo "Installing Visual Studio Code..." && yes | flatpak install flathub com.visualstudio.code && clear;;
    *) clear && bash /setup.sh;;
esac

echo "Installed."
sleep 0.3
bash /setup.sh


