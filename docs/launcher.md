---
title: Launcher
layout: default
nav_order: 10
---

# Calamares Launcher

The `calamares-next` script (`calamares-next.sh`) handles the installer boot flow. It's installed by `calamares-branding-antergos-next` to `/usr/bin/calamares-next`.

## Boot flow

1. **Notice** — explains why the so-called "Offline Install" was removed (it wasn't actually offline)
2. **Welcome** — branded splash screen with an "Install" button
3. **Configuration** — copies `calamares-online/settings.conf` to `/etc/calamares/settings.conf`
4. **Launch** — runs `calamares` with the online config

## Desktop entry

`/usr/share/applications/calamares.desktop` in the live-overlay launches with:

```
Exec=sudo -E calamares-next
```

`sudo -E` preserves environment variables (`WAYLAND_DISPLAY`, `XDG_CURRENT_DESKTOP`, etc.) when launched from the SDDM session. Without it, Calamares may not detect the display server correctly.

## Installer flow

The launcher shows a YAD info notice explaining the removal of the offline mode, then presents a branded splash with a single "Install" button. Calamares launches in online mode with the DE selector.

## Config switching

`SetConfig()` in `calamares-next.sh`:

1. `rm -f` the existing settings file at `/etc/calamares/settings.conf`
2. `cp` the online settings file to `/etc/calamares/settings.conf`
3. Calamares reads the config on launch

## Hiding "Install Artix"

The live-overlay includes `calamares-config-switcher.desktop` with `NoDisplay=true`. This hides the upstream Artix "Install Artix Linux" desktop entry while keeping the binary available for other uses.

## Module configs

Configs live in `live-overlay/etc/calamares-online/modules/`:

- `packagechooser_dm.conf` — display manager selector using `method: netinstall-select`
- `initcpiocfg.conf` — mkinitcpio configuration
- `services-artix.conf` — service enablement via `artix-service`
