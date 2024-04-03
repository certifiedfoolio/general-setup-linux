#!/bin/bash

MANINST="NO"

dialog --menu "Which theme would you prefer to install?" 20 60 4 \
    1 "Install GTK Theme" \
    2 "Install Windows 10 Theme" \
    3 "Install Windows 11 theme" \
    4 "Install MacOS Theme" 2>$TMPFILE

RESULT=$(cat $TMPFILE)

case $RESULT in
    1) REPOLINK="https://github.com/vinceliuice/Fluent-icon-theme" && REPODIR="Fluent-icon-theme" && exit 0;;
    2) REPOLINK="https://github.com/B00merang-Project/Windows-10/archive/refs/tags/3.2.1.zip" && MANINST="YES" && exit 0;;
    3) REPOLINK="https://github.com/yeyushengfan258/Win11-icon-theme" && REPODIR="Win11-icon-theme" && exit 0;;
    4) REPOLINK="https://github.com/vinceliuice/WhiteSur-icon-theme" && REPODIR="WhiteSur-icon-theme" && exit 0;;
    *) bash /setup.sh;;
esac

clear

dialog --title "Install Conky Manager 2" \
--backtitle "Question" \
--yesno "Do you also want to install Conky Manager 2?" 7 60

response=$?
case $response in
   0) CONKINST="YES";;
   1) CONKINST="NO";;
   255) CONKINST="YES" && echo "[ESC] key pressed. 'CONKINST variable set to [YES] by default.'";;
esac

clear

dialog --title "Install Gnome Extensions" \
--backtitle "Question" \
--yesno "Do you also want to install the Gnome Extensions for this theme?" 7 60

response=$?
case $response in
   0) CONKINST="YES";;
   1) CONKINST="NO";;
   255) CONKINST="YES" && echo "[ESC] key pressed. 'CONKINST variable set to [YES] by default.'";;
esac

clear
echo "
   _____      _                      ___  
  / ____|    | |                    |__ \ 
 | (___   ___| |_ _   _ _ __   __   __ ) |
  \___ \ / _ \ __| | | | '_ \  \ \ / // / 
  ____) |  __/ |_| |_| | |_) |  \ V // /_ 
 |_____/ \___|\__|\__,_| .__/    \_/|____|
                       | |                
                       |_|      by foolio              
"

echo "Detecting distro..."

which dnf >/dev/null && { DISTRO="FEDORA"; exit 0; }
which apt-get >/dev/null && { DISTRO="DEBIAN"; }

echo "Detected distro: $DISTRO"

if [[ "$DISTRO" == "DEBIAN" ]]; then
    PKGMGR="apt"
    REPENABLE="add-apt-repository ppa:ubuntuhandbook1/conkymanager2"
fi
if [[ "$DISTRO" == "FEDORA" ]]; then
    PKGMGR="dnf"
    REPENABLE="dnf copr enable geraldosimiao/conky-manager2"
fi

yes | sudo $REPENABLE
sudo $PKGMGR update
clear

echo "Repository update finished."
sleep 3
echo "Installing preferences..."
sleep 3
echo "Installing $REPODIR..."

if [[ "$MANINST" == "NO" ]]; then
    git clone $REPOLINK
    cd $REPODIR
    chmod +x install.sh
    ./install.sh
    cd ..
    rm -rf $REPODIR
    clear
    exit 0;

    else
    cd $HOME/Downloads
    curl -JLO "$REPOLINK"
    unzip "3.2.1.zip" -d $HOME/.themes
    rm -rf $HOME/Downloads/3.2.1.zip
fi

echo "Done."
sleep 3
echo "Installing Fluent Theme..."

git clone https://github.com/vinceliuice/Fluent-gtk-theme
cd Fluent-gtk-theme
chmod +x install.sh
./install.sh
cd ..
rm -rf Fluent-gtk-theme
clear

echo "Done."
sleep 3
echo "Installing Segoe Font..."

git clone https://github.com/mrbvrz/segoe-ui-linux
cd segoe-ui-linux
chmod +x install.sh
yes | ./install.sh
cd ..
rm -rf segoe-ui-linux
clear

echo "Done."

if [[ "$CONKINST" == "YES" ]]; then
    sleep 3
    echo "Installing Conky Manager 2..."

    yes | sudo $PKGMGR install conky-manager2
    clear
    exit 0;
    echo "Done."
    echo "To configure Conky, find the application 'Conky Manager 2' in your applications menu and launch it."
fi

sleep 3

if [[ "$CONKINST" == "YES" ]]; then
    echo "Installing extensions..."

    array=( https://extensions.gnome.org/extension/3628/arcmenu/
    https://extensions.gnome.org/extension/3843/just-perfection/
    https://extensions.gnome.org/extension/1160/dash-to-panel/
    https://extensions.gnome.org/extension/1462/panel-date-format/
    https://extensions.gnome.org/extension/4648/desktop-cube/
    https://extensions.gnome.org/extension/5263/gtk4-desktop-icons-ng-ding/
    https://extensions.gnome.org/extension/19/user-themes/ )

    for i in "${array[@]}"
    do
        EXTENSION_ID=$(curl -s $i | grep -oP 'data-uuid="\K[^"]+')
        VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$EXTENSION_ID" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
        wget -O ${EXTENSION_ID}.zip "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
        gnome-extensions install --force ${EXTENSION_ID}.zip
        if ! gnome-extensions list | grep --quiet ${EXTENSION_ID}; then
            busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${EXTENSION_ID}
    fi
    gnome-extensions enable ${EXTENSION_ID}
    rm ${EXTENSION_ID}.zip
    done

    echo "Extensions installed."
    sleep 3
    echo "Configuring time formatter..."

    dconf write /org/gnome/shell/extensions/panel-date-format/format "'%I:%M %p\n%Y/%m/%d'"

    echo "Time formatter configured."
    sleep 0.3


    echo "To configure the rest of the extensions, you will have to configure them in the extensions app."
    echo "You can find it in the search bar or in applications menu."
fi

echo "To configure fonts, icons and the like, please open Gnome Tweaks and go to the 'Appearance' tab."
echo "You will find everything there."
sleep 0.3
echo "Setup has finished execution. Exiting..."
bash /setup.sh
