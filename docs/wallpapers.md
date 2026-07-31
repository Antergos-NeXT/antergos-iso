---
title: Wallpapers
layout: default
nav_order: 13
---

# Wallpapers

The live session and installed system use a **video wallpaper** — `/usr/share/backgrounds/antergos/antergos-wallpaper.mp4` — played by the **Smart Video Wallpaper Reborn** Plasma plugin.

The video ships from the **`antergos-layan-theme`** package (`depends=('kvantum' 'yakuake' 'antergos-wallpapers' 'mpv')`). The same package installs the Smart Video Wallpaper Reborn plugin into the user's `~/.local/share/plasma/wallpapers/` from its `Configs/Home/` tree.

The `antergos-wallpapers` package provides the still images:
- **antergos-wallpaper.png** — the original Antergos wallpaper, sourced from the [Antergos/wallpapers](https://github.com/Antergos/wallpapers) repo. GPL-3.0.
- **adwaita-morning.webp** — GNOME Adwaita Morning (7680×4320, CC BY-SA 3.0 by Jakub Steiner)
- **antergos-darkest-hour.jpg** — KDE Plasma variant (GPL-2+)

## Installation paths

| Path | Purpose |
|------|---------|
| `/usr/share/backgrounds/antergos/` | Default wallpaper location + video wallpaper |
| `/usr/share/wallpapers/antergos-wallpaper/contents/images/` | KDE wallpaper picker (still images) |
| `/usr/share/antergos/backgrounds/` | Legacy path |
| `/usr/share/icons/hicolor/*/apps/antergos-logo.png` | App icon |

The KDE plugin names are `antergos-wallpaper` and `antergos-darkest-hour`, each with their own `metadata.desktop`.

## Set on first login

Plasma overwrites `/etc/skel/.config/plasma-org.kde.plasma.desktop-appletsrc` on first login, so putting the wallpaper in skel doesn't work. Instead, a one-shot autostart script handles it:

1. `/usr/local/bin/set-antergos-wallpaper.sh` — configures the Smart Video Wallpaper Reborn plugin (`luisbocanegra.smart.video.wallpaper.reborn`) via `qdbus6`, pointing it at `/usr/share/backgrounds/antergos/antergos-wallpaper.mp4` muted, then creates the marker file `~/.config/antergos-wallpaper-set`
2. `~/.config/autostart/antergos-wallpaper.desktop` (from skel, plus a copy in `/etc/xdg/autostart/`) — calls the script with `X-KDE-autostart-phase=2`

The marker file prevents the script from running on subsequent logins.

## Customizing

To replace the wallpaper, update the `antergos-wallpapers` package:
- `packages/antergos-wallpapers/PKGBUILD` — update source URL and checksum
- `packages/antergos-wallpapers/<image-file>` — new wallpaper image
- `packages/antergos-wallpapers/metadata.desktop` — update name if changing

Rebuild the package and push to the [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) repo.
