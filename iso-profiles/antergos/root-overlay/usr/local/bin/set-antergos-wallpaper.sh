#!/usr/bin/env bash
# One-shot wallpaper setter for Antergos NeXT
# Runs at first login via autostart, then disables itself
# Configures Smart Video Wallpaper Reborn plugin

LOG="/tmp/antergos-wallpaper.log"
MARKER="$HOME/.config/antergos-wallpaper-set"
CONFIG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
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

echo "[$(date)] Getting desktop containment IDs..." >> "$LOG"

IDS=$(qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript \
  "desktops().map(function(d) { return d.id; }).join(' ');" 2>/dev/null)

if [[ -z "$IDS" ]]; then
  echo "[$(date)] Failed to get containment IDs" >> "$LOG"
  touch "$MARKER"
  exit 1
fi

echo "[$(date)] Containment IDs: $IDS" >> "$LOG"

for ID in $IDS; do
  echo "[$(date)] Configuring containment $ID..." >> "$LOG"

  kwriteconfig6 --file "$CONFIG" \
    --group "Containments" --group "$ID" \
    --key "wallpaperplugin" "$PLUGIN" >> "$LOG" 2>&1

  kwriteconfig6 --file "$CONFIG" \
    --group "Containments" --group "$ID" \
    --group "Wallpaper" --group "$PLUGIN" --group "General" \
    --key "VideoUrls" '[{"filename": "/usr/share/backgrounds/antergos/antergos-wallpaper.mp4", "enabled": true}]' >> "$LOG" 2>&1

  kwriteconfig6 --file "$CONFIG" \
    --group "Containments" --group "$ID" \
    --group "Wallpaper" --group "$PLUGIN" --group "General" \
    --key "Volume" "0" >> "$LOG" 2>&1

  kwriteconfig6 --file "$CONFIG" \
    --group "Containments" --group "$ID" \
    --group "Wallpaper" --group "$PLUGIN" --group "General" \
    --key "MuteMode" "5" >> "$LOG" 2>&1
done

qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.refreshCurrentShell >> "$LOG" 2>&1

touch "$MARKER"
echo "[$(date)] Done" >> "$LOG"
