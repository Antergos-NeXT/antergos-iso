#!/usr/bin/env bash

# Make sure build scripts are executable
chmod +x "./"{"mkarchiso","run_before_squashfs.sh"}

# Get Antergos wallpaper for installed system
wget -qN --show-progress -P "airootfs/root/" "https://raw.githubusercontent.com/Antergos/wallpapers/master/antergos-wallpaper.png"

# Get live session wallpaper
wget -qN --show-progress -P "airootfs/root/" "https://raw.githubusercontent.com/Antergos/wallpapers/master/antergos-wallpaper.png"
cp airootfs/root/antergos-wallpaper.png airootfs/root/livewall.png

# Build liveuser skel
cd "airootfs/root/antergos-skel-liveuser"
makepkg -f
