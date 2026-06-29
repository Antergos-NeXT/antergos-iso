---
title: Launcher
layout: default
nav_order: 9
---

# Calamares Launcher

The `calamares-next` script (`calamares-next.sh`) handles the installer boot flow.

## Flow

1. **Mode picker** — Dialog asking Offline or Online install
2. **Configuration** — Copies the appropriate `settings.conf` (offline or online) to `/etc/calamares/settings.conf`
3. **Launch** — Runs `calamares` with the selected config

## Launcher location

Installed by `calamares-branding-antergos-next` to `/usr/bin/calamares-next`.

## Desktop entry

`/usr/share/applications/calamares.desktop` in the live-overlay launches with:

```
Exec=sudo -E calamares-next
```

Note: `sudo -E` preserves environment variables (required for `WAYLAND_DISPLAY`, `XDG_CURRENT_DESKTOP`, etc. when launched from the SDDM session).

## Mode picker (dialog)

A simple `kdialog` or `zenity` dialog:
- **Offline** — No internet required, installs KDE Plasma from squashfs
- **Online** — Init system selector + DE selector via packagechooser, downloads packages from the internet

## Config switching

`SetConfig()` in `calamares-next.sh`:
1. Removes existing symlink at `/etc/calamares/settings.conf` (must `rm -f` first, not overwrite, or `cp` follows the symlink)
2. Copies the selected settings file
3. Calamares reads the config on launch

## Hiding "Install Artix"

The live-overlay includes `calamares-config-switcher.desktop` with `NoDisplay=true` — this hides the upstream Artix launcher while keeping the binary available.
