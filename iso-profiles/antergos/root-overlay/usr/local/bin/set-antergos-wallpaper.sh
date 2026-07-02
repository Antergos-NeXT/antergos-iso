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

# Wait for Plasma shell to be ready
for i in 1 2 3 4 5; do
  if qdbus org.kde.plasmashell >/dev/null 2>&1; then
    echo "[$(date)] Plasmashell ready on attempt $i" >> "$LOG"
    break
  fi
  echo "[$(date)] Waiting for plasmashell... (attempt $i)" >> "$LOG"
  sleep 2
done

echo "[$(date)] Trying plasma-apply-wallpaperimage..." >> "$LOG"
/usr/bin/plasma-apply-wallpaperimage "$WALLPAPER" >> "$LOG" 2>&1
RC=$?
echo "[$(date)] plasma-apply-wallpaperimage exit code: $RC" >> "$LOG"

if [[ $RC -ne 0 ]]; then
  echo "[$(date)] Falling back to qdbus script..." >> "$LOG"
  qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
    desktops().forEach(function(d) {
      d.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
      d.writeConfig('Image', 'file://${WALLPAPER}');
      d.reloadConfig();
    });
  " >> "$LOG" 2>&1
  FALLBACK_RC=$?
  echo "[$(date)] qdbus fallback exit code: $FALLBACK_RC" >> "$LOG"
fi

touch "$MARKER"
echo "[$(date)] Done" >> "$LOG"
