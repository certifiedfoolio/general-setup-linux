#!/bin/bash

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
which dnf >/dev/null && { DISTRO="FEDORA"; exit 0; }
which apt-get >/dev/null && { DISTRO="DEBIAN"; }

if [ "$DISTRO" == "DEBIAN" ]; then yes | sudo apt update && yes | sudo apt install gnome-tweaks && echo "Finished." && exit 0;
if [ "$DISTRO" == "FEDORA" ]; then yes | sudo dnf update && yes | sudo dnf install gnome-tweak-tool && echo "Finished." && exit 0;
sleep 0.3

bash /setup.sh
