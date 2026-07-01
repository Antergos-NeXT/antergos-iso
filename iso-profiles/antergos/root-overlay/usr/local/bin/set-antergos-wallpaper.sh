#!/usr/bin/env bash
# One-shot wallpaper setter for Antergos NeXT
# Runs at first login via autostart, then disables itself

LOG="/tmp/antergos-wallpaper.log"
MARKER="$HOME/.config/antergos-wallpaper-set"
WALLPAPER="/usr/share/wallpapers/antergos-wallpaper/contents/images/adwaita-morning.webp"

echo "[$(date)] Starting" > "$LOG"

if [[ -f "$MARKER" ]]; then
  echo "[$(date)] Marker exists, exiting" >> "$LOG"
  exit 0
fi

if [[ ! -f "$WALLPAPER" ]]; then
  echo "[$(date)] Wallpaper not found: $WALLPAPER" >> "$LOG"
  ls -la /usr/share/wallpapers/antergos-wallpaper/contents/images/ >> "$LOG" 2>&1
  touch "$MARKER"
  exit 1
fi

echo "[$(date)] Wallpaper found, applying..." >> "$LOG"

# Retry a few times in case desktop isn't ready yet
for i in 1 2 3; do
  /usr/bin/plasma-apply-wallpaperimage "$WALLPAPER" >> "$LOG" 2>&1
  RC=$?
  echo "[$(date)] plasma-apply-wallpaperimage attempt $i exit code: $RC" >> "$LOG"
  if [[ $RC -eq 0 ]]; then
    break
  fi
  sleep 2
done

touch "$MARKER"
echo "[$(date)] Done" >> "$LOG"
