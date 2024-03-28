#!/bin/bash

which dnf >/dev/null && { DISTRO="FEDORA"; exit 0; }
which apt-get >/dev/null && { DISTRO="DEBIAN"; }

if [ "$DISTRO" == "DEBIAN" ]; then sudo apt update && sudo apt install gnome-tweaks && echo "Finished." && exit 0;
if [ "$DISTRO" == "FEDORA" ]; then sudo yum update && sudo yum install gnome-tweak-tool && echo "Finished." && exit 0;

bash /setup.sh