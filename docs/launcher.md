---
title: Launcher
layout: default
nav_order: 10
---

# Calamares Launcher

The `calamares-next` script (`calamares-next.sh`) handles the installer boot flow. It's installed by `calamares-branding-antergos-next` to `/usr/bin/calamares-next`.

## Boot flow

1. **Mode picker** — `kdialog` or `zenity` dialog asking Offline or Online install
2. **Configuration** — copies the appropriate `settings.conf` (offline or online) to `/etc/calamares/settings.conf`
3. **Launch** — runs `calamares` with the selected config

## Desktop entry

`/usr/share/applications/calamares.desktop` in the live-overlay launches with:

```
Exec=sudo -E calamares-next
```

`sudo -E` preserves environment variables (`WAYLAND_DISPLAY`, `XDG_CURRENT_DESKTOP`, etc.) when launched from the SDDM session. Without it, Calamares may not detect the display server correctly.

## Mode picker

A simple dialog with two options:

- **Offline** — no internet required, installs KDE Plasma from a pre-built squashfs. Fast and deterministic.
- **Online** — internet required, shows an init system selector (Dinit/OpenRC/Runit/S6) and a desktop selector. Downloads packages from the repos.

## Config switching

`SetConfig()` in `calamares-next.sh`:

1. `rm -f` the existing symlink at `/etc/calamares/settings.conf` (must remove first — `cp` follows symlinks and would overwrite the wrong file)
2. `cp` the selected settings file (offline or online) to `/etc/calamares/settings.conf`
3. Calamares reads the config on launch

## Hiding "Install Artix"

The live-overlay includes `calamares-config-switcher.desktop` with `NoDisplay=true`. This hides the upstream Artix "Install Artix Linux" desktop entry while keeping the binary available for other uses.

## Module configs

### Online modules

Configs live in `live-overlay/etc/calamares-online/modules/`:

- `packagechooser_init.conf` — init system selector using `method: netinstall-add`
- `packagechooser_desktop.conf` — DE selector using `method: legacy`
- `initcpiocfg.conf` — mkinitcpio configuration
- `services-openrc.conf` — service enablement (works across all inits via init-specific wrappers)

### Offline modules

Configs live in `live-overlay/etc/calamares-offline/modules/`:

- `unpackfs.conf` — unpack the pre-built squashfs
- `initcpiocfg.conf` — mkinitcpio configuration
- `services-openrc.conf` — service enablement
