---
title: Wallpapers
layout: default
nav_order: 8
---

# Wallpapers

The `antergos-wallpapers` package provides default wallpapers for the live session and installed system.

## Current wallpaper

GNOME **Adwaita Morning** (`adwaita-morning.webp`) — 7680×4320, CC BY-SA 3.0 by Jakub Steiner / GNOME Project.

## Installation paths

| Path | Purpose |
|------|---------|
| `/usr/share/wallpapers/antergos-wallpaper/` | KDE wallpaper picker (requires `metadata.desktop`) |
| `/usr/share/backgrounds/antergos/` | Other DEs / fallback |

## How it appears in KDE

KDE's wallpaper picker scans `/usr/share/wallpapers/` for directories containing a `metadata.desktop` file. The `metadata.desktop` format:

```ini
[Wallpaper]
name=Antergos NeXT
filename=adwaita-morning.webp
```

## Set on first login

Since Plasma overwrites `/etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc` on first login, the wallpaper is applied via a one-shot autostart script:

1. `/usr/local/bin/set-antergos-wallpaper.sh` — runs `plasma-apply-wallpaperimage`, creates marker file `~/.config/antergos-wallpaper-set`
2. `~/.config/autostart/antergos-wallpaper.desktop` — calls the script with `X-KDE-autostart-phase=2`

The marker file prevents the script from running on subsequent logins.

## Customizing

To replace the wallpaper, update:
- `packages/antergos-wallpapers/PKGBUILD` (source + checksum)
- `packages/antergos-wallpapers/adwaita-morning.webp`
- `packages/antergos-wallpapers/metadata.desktop` (if changing name)
