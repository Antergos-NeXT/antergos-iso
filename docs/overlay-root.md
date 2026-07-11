---
title: Root Overlay
layout: default
parent: Overlays
nav_order: 1
---

# Root Overlay

Files in `iso-profiles/antergos/root-overlay/` are merged into the root squashfs and become part of the installed system.

## Contents

```
root-overlay/
├── etc/
│   ├── pacman.conf               # Includes [antergos-pkgs] repo
│   ├── sddm.conf.d/
│   │   └── kde_settings.conf     # SDDM theme + Wayland session
│   └── skel/
│       └── .config/
│           └── autostart/
│               └── antergos-wallpaper.desktop  # One-shot wallpaper setter
├── usr/
│   └── local/
│       └── bin/
│           └── set-antergos-wallpaper.sh       # Wallpaper script
```

## Key files

### `etc/pacman.conf`

Adds the `[antergos-pkgs]` custom repo so installed systems can receive updates from our package repository. The `SigLevel = Optional TrustAll` is needed because our packages are not signed with official Artix keys.

### `etc/sddm.conf.d/kde_settings.conf`

Sets the SDDM session to `plasma.desktop` (Wayland) by default. Also controls the SDDM theme — see the note below.

> **Note:** The SDDM theme is set to `Current=antergos` in this file. However, KDE's SDDM KCM may overwrite this file on first login to `Current=breeze`. To ensure the Antergos theme persists, the `antergos-sddm-theme` package ships a `theme.conf` that sorts after `kde_settings.conf` alphabetically, so its `Current=antergos` always wins.

### `etc/skel/.config/autostart/antergos-wallpaper.desktop`

Runs the wallpaper setter on first login. Uses `X-KDE-autostart-phase=2` to run after Plasma has initialized. This is necessary because Plasma overwrites the wallpaper config from `/etc/skel/` on first login.

### `usr/local/bin/set-antergos-wallpaper.sh`

Applies the wallpaper via `plasma-apply-wallpaperimage` and creates `~/.config/antergos-wallpaper-set` marker to prevent re-running on subsequent logins.
