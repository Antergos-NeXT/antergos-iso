#!/usr/bin/env bash
# One-shot wallpaper setter for Antergos NeXT
# Runs at first login via autostart, then disables itself
# Uses multiple fallback methods for Plasma 6 + Wayland compatibility

LOG="/tmp/antergos-wallpaper.log"
MARKER="$HOME/.config/antergos-wallpaper-set"
WALLPAPER="/usr/share/wallpapers/antergos-wallpaper/contents/images/antergos-wallpaper.png"

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

# Method 1: plasma-apply-wallpaperimage (primary, works on Plasma 6)
echo "[$(date)] Method 1: plasma-apply-wallpaperimage..." >> "$LOG"
/usr/bin/plasma-apply-wallpaperimage "$WALLPAPER" >> "$LOG" 2>&1
RC=$?
echo "[$(date)] Method 1 exit code: $RC" >> "$LOG"

if [[ $RC -ne 0 ]]; then
  # Method 2: kwriteconfig6 + qdbus6 config reload
  echo "[$(date)] Method 2: kwriteconfig6 + qdbus6..." >> "$LOG"
  CONFIG="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
  if [[ -f "$CONFIG" ]]; then
    kwriteconfig6 --file "$CONFIG" \
      --group "Containments" --group "1" \
      --group "Wallpaper" --group "org.kde.image" --group "General" \
      --key "Image" "file://${WALLPAPER}" >> "$LOG" 2>&1
    kwriteconfig6 --file "$CONFIG" \
      --group "Containments" --group "1" \
      --group "Wallpaper" --group "org.kde.image" --group "General" \
      --key "FillMode" "2" >> "$LOG" 2>&1
    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.refreshCurrentShell >> "$LOG" 2>&1
    RC2=$?
    echo "[$(date)] Method 2 exit code: $RC2" >> "$LOG"
  else
    echo "[$(date)] Config not found at $CONFIG, skipping method 2" >> "$LOG"
    RC2=1
  fi

  if [[ $RC2 -ne 0 ]]; then
    # Method 3: qdbus6 evaluateScript (legacy API fallback)
    echo "[$(date)] Method 3: qdbus6 evaluateScript..." >> "$LOG"
    qdbus6 org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "
      desktops().forEach(function(d) {
        d.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
        d.writeConfig('Image', 'file://${WALLPAPER}');
        d.reloadConfig();
      });
    " >> "$LOG" 2>&1
    RC3=$?
    echo "[$(date)] Method 3 exit code: $RC3" >> "$LOG"
  fi
fi

touch "$MARKER"
echo "[$(date)] Done" >> "$LOG"
