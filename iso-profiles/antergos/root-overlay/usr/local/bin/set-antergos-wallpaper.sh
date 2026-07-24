#!/usr/bin/env bash
# One-shot wallpaper setter for Antergos NeXT
# Runs at first login via autostart, then disables itself
# Configures Smart Video Wallpaper Reborn plugin

LOG="/tmp/antergos-wallpaper.log"
MARKER="$HOME/.config/antergos-wallpaper-set"
VIDEO="/usr/share/backgrounds/antergos/antergos-wallpaper.mp4"
PLUGIN="luisbocanegra.smart.video.wallpaper.reborn"

echo "[$(date)] Starting" > "$LOG"

if [[ -f "$MARKER" ]]; then
  echo "[$(date)] Marker exists, exiting" >> "$LOG"
  exit 0
fi

if [[ ! -f "$VIDEO" ]]; then
  echo "[$(date)] Video not found: $VIDEO" >> "$LOG"
  touch "$MARKER"
  exit 1
fi

echo "[$(date)] Applying video wallpaper via qdbus6..." >> "$LOG"

qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
var allDesktops = desktops();
for (var i = 0; i < allDesktops.length; i++) {
    var d = allDesktops[i];
    d.wallpaperPlugin = '$PLUGIN';
    d.currentConfigGroup = Array('Wallpaper', '$PLUGIN', 'General');
    d.writeConfig('VideoUrls', '[{\"filename\": \"/usr/share/backgrounds/antergos/antergos-wallpaper.mp4\", \"enabled\": true}]');
    d.writeConfig('Volume', '0');
    d.writeConfig('MuteMode', '5');
}
" >> "$LOG" 2>&1

touch "$MARKER"
echo "[$(date)] Done" >> "$LOG"
