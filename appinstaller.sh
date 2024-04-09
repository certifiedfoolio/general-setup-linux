#!/bin/bash

TMPFILE=$(mktemp)

dialog --menu "Please choose an app to install:" 20 60 5 \
    --backtitle "Theme Installer" \
    1 "Install Discord" \
    2 "Install Vencord Patch"
    3 "Install Chromium" \
    4 "Install Spotify" \
    5 "Install Blender" \
    6 "Install Audacity"
    7 "Install Visual Studio Code" 2>$TMPFILE

RESULT=$(cat $TMPFILE)

case $RESULT in
    1) clear && APPECHO="Discord" && echo "Installing Discord..." && yes | flatpak install flathub com.discordapp.Discord && clear;;
    2) clear && APPECHO="Vencord Patch" && sh -c "$(curl -sS https://raw.githubusercontent.com/Vendicated/VencordInstaller/main/install.sh)" && clear;;
    3) clear && APPECHO="Chromium" && echo "Installing Chromium..." && yes | flatpak install flathub org.chromium.Chromium && clear;;
    4) clear && APPECHO="Spotify" && echo "Installing Spotify..." && yes | flatpak install flathub com.spotify.Client && clear;;
    5) clear && APPECHO="Blender" && echo "Installing Blender..." && yes | flatpak install flathub org.blender.Blender && clear;;
    6) clear && APPECHO="Audacity" && echo "Installing Audacity..." && yes | flatpak install flathub install flathub org.audacityteam.Audacity && clear;;
    7) clear && APPECHO="Visual Studio Code" && echo "Installing Visual Studio Code..." && yes | flatpak install flathub install flathub com.visualstudio.code && clear;;
    *) clear && bash /setup.sh;;
esac

echo "Installed $APPECHO successfully."
sleep 0.3
bash /setup.sh


