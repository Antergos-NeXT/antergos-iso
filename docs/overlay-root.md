---
title: Root Overlay
layout: default
parent: Overlays
nav_order: 1
---

# Root Overlay

Files in `iso-profiles/antergos/root-overlay/` are merged into the live rootfs — the filesystem the ISO boots. root-overlay settings (os-release, issue, SDDM config, wallpapers) therefore apply to the live session too.

> **Important:** The Calamares online install does **not** copy root-overlay files to the installed system. The installed system is built fresh from packages via `basestrap`. Anything you want on installed systems must ship as a package (e.g. `antergos-release` for os-release, `antergos-layan-theme` for the SDDM theme), not live in root-overlay.

## Contents

```
root-overlay/
├── etc/
│   ├── default/
│   │   └── grub                       # GRUB default options
│   ├── issue / issue.live             # Login banners
│   ├── lsb-release                    # LSB metadata
│   ├── os-release                     # "Antergos NeXT" in the live session
│   ├── pacman.conf                    # Includes [antergos-pkgs] repo
│   ├── sddm.conf                      # SDDM general config (Wayland compositor, theme dirs)
│   ├── sddm.conf.d/
│   │   └── kde_settings.conf          # SDDM autologin + theme (live only)
│   ├── skel/.config/autostart/
│   │   ├── antergos-wallpaper.desktop # First-login wallpaper setter
│   │   └── pipewire.desktop           # PipeWire autostart
│   └── xdg/autostart/
│       └── antergos-wallpaper.desktop # System-wide wallpaper autostart
├── usr/
│   ├── bin/systemd-machine-id-setup   # Keeps live machine-id stable
│   ├── lib/os-release                 # Mirrors etc/os-release
│   ├── local/bin/set-antergos-wallpaper.sh
│   └── share/
│       ├── icons/hicolor/{128x128,256x256}/apps/antergos-logo.png
│       ├── pixmaps/antergos-logo.png
│       └── plasma/wallpapers/org.kde.image/contents/config/main.xml
```

## Key files

### `etc/pacman.conf`

Adds the `[antergos-pkgs]` custom repo so the live session can install our packages during the Calamares online install. `SigLevel = Optional TrustAll` is needed because our packages are not signed with official Artix keys.

### `etc/sddm.conf.d/kde_settings.conf`

Sets the live session to **autologin as user `antergos`** with `Session=plasma.desktop` (Wayland). Also sets `HaltCommand`/`RebootCommand` to loginctl (dinit-compatible) and the theme to `Current=antergos` (the bundled Antergos theme).

> This file only affects the **live session**. On installed systems the `antergos-layan-theme` package owns `kde_settings.conf` with `Current=pixie` — see [Installer — SDDM theme](installer).

### `etc/skel/.config/autostart/antergos-wallpaper.desktop`

Runs the wallpaper setter on first login. Uses `X-KDE-autostart-phase=2` so it runs after Plasma has initialized — necessary because Plasma overwrites the wallpaper config from `/etc/skel/` on first login. A matching copy lives at `etc/xdg/autostart/` for system-wide autostart.

### `usr/local/bin/set-antergos-wallpaper.sh`

Configures the **Smart Video Wallpaper Reborn** Plasma plugin (`luisbocanegra.smart.video.wallpaper.reborn`) via `qdbus6` to play `/usr/share/backgrounds/antergos/antergos-wallpaper.mp4` muted, then writes `~/.config/antergos-wallpaper-set` as a marker so it only runs once. See [Wallpapers](wallpapers).
