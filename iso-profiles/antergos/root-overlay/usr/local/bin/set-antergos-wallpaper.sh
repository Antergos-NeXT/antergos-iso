#!/usr/bin/env bash
# One-shot wallpaper setter for Antergos NeXT
# Runs at first login via autostart, then disables itself

MARKER="$HOME/.config/antergos-wallpaper-set"

if [[ -f "$MARKER" ]]; then
  exit 0
fi

WALLPAPER="/usr/share/wallpapers/antergos-wallpaper/contents/images/adwaita-morning.webp"

if [[ -f "$WALLPAPER" ]]; then
  plasma-apply-wallpaperimage "$WALLPAPER" 2>/dev/null
fi

touch "$MARKER"
