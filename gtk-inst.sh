#!/bin/bash

MANINST="NO"

TMPFILE=$(mktemp)

dialog --menu "Which theme would you prefer to install?" 20 60 4 \
    --backtitle "Theme Installer" \
    1 "Install GTK Theme" \
    2 "Install Windows 10 Theme" \
    3 "Install Windows 11 theme" \
    4 "Install MacOS Theme" 2>$TMPFILE

RESULT=$(cat $TMPFILE)

case $RESULT in
    1) REPOLINK="https://github.com/vinceliuice/Fluent-icon-theme";;
    2) REPOLINK="https://github.com/B00merang-Project/Windows-10/archive/refs/tags/3.2.1.zip";;
    3) REPOLINK="https://github.com/yeyushengfan258/Win11-icon-theme";;
    4) REPOLINK="https://github.com/vinceliuice/WhiteSur-icon-theme";;
    *) bash /setup.sh;;
esac

REPODIR=${REPOLINK##*/}
clear

dialog --title "Install Conky Manager 2" \
--backtitle "Theme Installer" \
--yesno "Do you also want to install Conky Manager 2?" 7 60

response=$?
case $response in
   0) CONKINST="YES";;
   1) CONKINST="NO";;
   255) CONKINST="YES" && echo "[ESC] key pressed. 'CONKINST variable set to [YES] by default.'";;
esac

clear

dialog --title "Install Gnome Extensions" \
--backtitle "Theme Installer" \
--yesno "Do you also want to install the Gnome Extensions for this theme?" 7 60

response=$?
case $response in
   0) CONKINST="YES";;
   1) CONKINST="NO";;
   255) CONKINST="YES" && echo "[ESC] key pressed. 'CONKINST variable set to [YES] by default.'";;
esac

which dnf >/dev/null && { DISTRO="FEDORA"; exit 0; }
which apt-get >/dev/null && { DISTRO="DEBIAN"; }

if [[ "$DISTRO" == "DEBIAN" ]]; then
    PKGMGR="apt"
    REPENABLE="add-apt-repository ppa:ubuntuhandbook1/conkymanager2"
fi
if [[ "$DISTRO" == "FEDORA" ]]; then
    PKGMGR="dnf"
    REPENABLE="dnf copr enable geraldosimiao/conky-manager2"
fi

MFUNC="yes | sudo $REPENABLE
yes | sudo $PKGMGR update
clear"

FUNC1="if [[ "$MANINST" == "NO" ]]; then
    git clone $REPOLINK
    cd $REPODIR
    chmod +x install.sh
    ./install.sh
    cd ..
    rm -rf $REPODIR
    clear;

    else
    cd $HOME/Downloads
    curl -JLO "$REPOLINK"
    unzip "3.2.1.zip" -d $HOME/.themes
    rm -rf $HOME/Downloads/3.2.1.zip
fi"

FUNC2="git clone https://github.com/vinceliuice/Fluent-gtk-theme
cd Fluent-gtk-theme
chmod +x install.sh
./install.sh
cd ..
rm -rf Fluent-gtk-theme
clear"

FUNC3="git clone https://github.com/mrbvrz/segoe-ui-linux
cd segoe-ui-linux
chmod +x install.sh
yes | ./install.sh
cd ..
rm -rf segoe-ui-linux
clear"

FUNC4="if [[ "$CONKINST" == "YES" ]]; then
    sleep 3
    yes | sudo $PKGMGR install conky-manager2
    clear;
fi"

FUNC5="if [[ "$GEXINST" == "YES" ]]; then

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

    dconf write /org/gnome/shell/extensions/panel-date-format/format "'%I:%M %p\n%Y/%m/%d'"
fi"

( echo 10;$MFUNC;echo 50;$FUNC1;echo 60;$FUNC2;echo 70;$FUNC3;echo 80;$FUNC4;echo 90;$FUNC5;echo 100 ) | dialog --gauge 'text' 10 60 0

if [[ "$GEXINST" == "YES" ]]; then dialog --backtitle "Theme Installer" --msgbox "To configure the rest of the extensions, you will have to configure them in the extensions app. You can find the extensions app via search bar or the Applications menu." 20 60
fi
dialog --backtitle "Theme Installer" --msgbox "To configure fonts, icons and the like, please open Gnome Tweaks and go to the 'Appearance' tab. You will find everything there." 20 60
bash /setup.sh