---
title: Wallpapers
layout: default
nav_order: 13
---

# Wallpapers

The `antergos-wallpapers` package provides default wallpapers for the live session and installed system.

## Current wallpaper

**antergos-wallpaper.png** — the original Antergos wallpaper, sourced from the [Antergos/wallpapers](https://github.com/Antergos/wallpapers) repo. GPL-3.0.

Also ships:
- **adwaita-morning.webp** — GNOME Adwaita Morning (7680×4320, CC BY-SA 3.0 by Jakub Steiner)
- **antergos-darkest-hour.jpg** — KDE Plasma variant (GPL-2+)

## Installation paths

| Path | Purpose |
|------|---------|
| `/usr/share/wallpapers/antergos-wallpaper/contents/images/` | KDE wallpaper picker (reads from here) |
| `/usr/share/backgrounds/antergos/` | Other DEs / fallback |
| `/usr/share/antergos/backgrounds/` | Legacy path |

The KDE plugin names are `antergos-wallpaper` and `antergos-darkest-hour`, each with their own `metadata.desktop`.

## Set on first login

Plasma overwrites `/etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc` on first login, so putting the wallpaper in skel doesn't work. Instead, a one-shot autostart script handles it:

1. `/usr/local/bin/set-antergos-wallpaper.sh` — runs `plasma-apply-wallpaperimage`, creates marker file `~/.config/antergos-wallpaper-set`
2. `~/.config/autostart/antergos-wallpaper.desktop` (from skel) — calls the script with `X-KDE-autostart-phase=2`

The marker file prevents the script from running on subsequent logins.

## Customizing

To replace the wallpaper, update the `antergos-wallpapers` package:
- `packages/antergos-wallpapers/PKGBUILD` — update source URL and checksum
- `packages/antergos-wallpapers/<image-file>` — new wallpaper image
- `packages/antergos-wallpapers/metadata.desktop` — update name if changing

Rebuild the package and push to the [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) repo.
