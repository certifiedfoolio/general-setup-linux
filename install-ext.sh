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
echo "Please authorize this program first."
sudo echo "Authorized."

sudo flatpak install org.gnome.Extensions
clear

echo "Installed. Now returning to setup menu..." && bash /setup.sh
