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
│   ├── os-release            # Antergos NeXT branding
│   ├── pacman.conf           # Includes [antergos-pkgs] repo
│   ├── sddm.conf.d/
│   │   └── kde_settings.conf # SDDM theme + Wayland session
│   └── skel/
│       └── .config/
│           └── autostart/
│               └── antergos-wallpaper.desktop  # One-shot wallpaper setter
└── usr/
    └── local/
        └── bin/
            └── set-antergos-wallpaper.sh  # Wallpaper script
```

## Key files

### `etc/os-release`

Identifies the system as "Antergos NeXT" to tools, installers, and the login manager.

### `etc/pacman.conf`

Adds the `[antergos-pkgs]` custom repo so installed systems can receive updates.

### `etc/sddm.conf.d/kde_settings.conf`

Sets the SDDM session to `plasma.desktop` (Wayland) by default.

### `etc/skel/.config/autostart/antergos-wallpaper.desktop`

Runs the wallpaper setter on first login. Uses `X-KDE-autostart-phase=2` to run after Plasma has initialized.

### `usr/local/bin/set-antergos-wallpaper.sh`

Applies the wallpaper via `plasma-apply-wallpaperimage` and creates `~/.config/antergos-wallpaper-set` marker to prevent re-running.
