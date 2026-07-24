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

## Calamares sequence

The installer runs two `packagechooser` instances in sequence, followed by the `netinstall` module:

| Step | Instance | Module Config | Method | Purpose |
|------|----------|---------------|--------|---------|
| 4 | `packagechooser@de` | `packagechooser_de.conf` | `netinstall-add` | Desktop environment picker (required, default Plasma) |
| 5 | `packagechooser@dm` | `packagechooser_dm.conf` | `netinstall-select` | Display manager picker (required, default SDDM) |
| 6 | `netinstall` | `netinstall.yaml` | — | Refine packages, add optional groups |

### How `netinstall-add` works

When the user selects a DE, `packagechooser@de` writes a group definition to the `netinstallAdd` global storage key. When the `netinstall` module loads, it reads this key and appends the DE's package group to the tree. This allows users to see and refine the packages for their chosen DE — for example, deselecting specific applications.

The DM selector uses `netinstall-select`, which marks the chosen DM group (e.g. SDDM) as checked in the netinstall tree. Both keys are read by the netinstall module's `onActivate()` method at runtime. See `NetInstallPage.cpp` in the Calamares source for details.

### Available DE groups

Each DE item in `packagechooser_de.conf` includes a `netinstall:` field with its full package list. The groups are mutually exclusive — selecting a new DE replaces the previously selected one in the netinstall tree. Once added, the group behaves identically to a group defined in `netinstall.yaml`: users can expand it, toggle subgroups, or remove individual packages.

## Pacman log capture

During installation, the launcher polls for the existence of a pacman log file within the chroot (at `/tmp/calamares-root-*/var/log/pacman.log`). When detected, a copy is written to `~/pacman-install.log`. No terminal windows are opened to display installation progress.

## Config switching

`SetConfig()` in `calamares-next.sh`:

1. `rm -f` the existing settings file at `/etc/calamares/settings.conf`
2. `cp` the online settings file to `/etc/calamares/settings.conf`
3. Calamares reads the config on launch

## Hiding "Install Artix"

The live-overlay includes `calamares-config-switcher.desktop` with `NoDisplay=true`. This hides the upstream Artix "Install Artix Linux" desktop entry while keeping the binary available for other uses.

## Module configs

Configs live in `live-overlay/etc/calamares/modules/`:

- `packagechooser_de.conf` — desktop environment selector using `method: netinstall-add`
- `packagechooser_dm.conf` — display manager selector using `method: netinstall-select`
- `initcpiocfg.conf` — mkinitcpio configuration
- `services-artix.conf` — service enablement via `artix-service`
- `grubcfg.conf` — GRUB default configuration (`/etc/default/grub`)
- `bootloader.conf` — bootloader installation parameters
