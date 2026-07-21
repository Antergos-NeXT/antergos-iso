---
title: Launcher
layout: default
nav_order: 11
---

# Calamares Launcher

The `calamares-next` script (`calamares-next.sh`) handles the installer boot flow. It is installed by the `calamares-branding-antergos-next` package to `/usr/bin/calamares-next`.

## Boot flow

1. **Notice** — displays a YAD information dialog explaining why the offline install mode was removed
2. **Welcome** — presents a branded splash screen with a single "Install" button
3. **Configuration** — copies `calamares-online/settings.conf` to `/etc/calamares/settings.conf` after removing any existing file (the removal is necessary to prevent `cp` from following symlinks)
4. **Launch** — runs `calamares -D8` with the online config; debug output is redirected to a log file at `~/antergos-install.log`

## Desktop entry

`/usr/share/applications/calamares.desktop` in the live-overlay launches with:

```
Exec=sudo -E calamares-next
```

`sudo -E` preserves environment variables (`WAYLAND_DISPLAY`, `XDG_CURRENT_DESKTOP`, etc.) when launched from the SDDM session. Without it, Calamares may not detect the display server correctly.

## Module config resolution

The online settings file specifies `modules-search: [ local ]`, which resolves to the directory containing the settings file itself. After `SetConfig()` copies the file to `/etc/calamares/settings.conf`, modules are loaded from `/etc/calamares/modules/`. The `calamares-online/modules/` directory in the live-overlay is not used as a module source during installation — its contents exist only as a reference; the active module configs are those under `calamares/modules/`.

## Pacman log capture

During installation, the launcher polls for the existence of a pacman log file within the chroot (at `/tmp/calamares-root-*/var/log/pacman.log`). When detected, a copy is written to `~/pacman-install.log`. No terminal windows are opened to display installation progress.

## Installer flow

The launcher shows a YAD info notice explaining the removal of the offline mode, then presents a branded splash with a single "Install" button. Calamares launches in online mode with the desktop environment selector.

## Config switching

`SetConfig()` in `calamares-next.sh`:

1. `rm -f` the existing settings file at `/etc/calamares/settings.conf`
2. `cp` the online settings file to `/etc/calamares/settings.conf`
3. Calamares reads the config on launch

## Hiding "Install Artix"

The live-overlay includes `calamares-config-switcher.desktop` with `NoDisplay=true`. This hides the upstream Artix "Install Artix Linux" desktop entry while keeping the binary available for other uses.

## Module configs

Configs live in `live-overlay/etc/calamares/modules/`:

- `packagechooser_dm.conf` — display manager selector using `method: netinstall-select`
- `initcpiocfg.conf` — mkinitcpio configuration
- `services-artix.conf` — service enablement via `artix-service`
- `grubcfg.conf` — GRUB default configuration (`/etc/default/grub`)
- `bootloader.conf` — bootloader installation parameters
