---
title: Live Overlay
layout: default
parent: Overlays
nav_order: 2
---

# Live Overlay

Files in `iso-profiles/antergos/live-overlay/` exist only in the live environment — they are **not** present after installation.

## Contents

```
live-overlay/
├── etc/
│   ├── calamares/
│   │   └── modules/                # Active runtime module configs (online installer)
│   │       ├── basestrap.conf      # Package installation (operations incl. antergos-release)
│   │       ├── bootloader.conf
│   │       ├── displaymanager.conf # DM selector backend
│   │       ├── finished.conf
│   │       ├── grubcfg.conf
│   │       ├── machineid.conf
│   │       ├── netinstall.conf / netinstall.yaml
│   │       ├── packagechooser_de.conf  # Desktop environment selector
│   │       ├── packagechooser_dm.conf  # Display manager selector
│   │       ├── packages.conf
│   │       ├── postcfg.conf
│   │       └── services-artix.conf
│   ├── calamares-online/
│   │   ├── settings.conf           # Online install sequence
│   │   └── modules/                # Companion module copies (kept in sync)
│   │       ├── packagechooser_de.conf / packagechooser_dm.conf
│   │       ├── initcpio.conf / locale.conf / mount.conf / partition.conf
│   │       ├── umount.conf / users.conf / welcome.conf
│   │       └── ... (mirrors the active set)
│   ├── elogind/{logind.conf,sleep.conf}
│   ├── fstab / hostname / hosts
│   ├── issue / issue.live / os-release
│   ├── pam.d/su
│   ├── polkit-1/rules.d/90-live.rules  # Live-session polkit bypass
│   ├── sddm.conf.d/
│   │   └── kde_settings.conf       # SDDM autologin + Wayland session
│   ├── skel/Desktop/
│   │   ├── calamares.desktop       # Install launcher on the desktop
│   │   └── antergos-offline-install.desktop
│   ├── sudoers.d/{g_wheel,u_root}
│   └── syslog-ng/syslog-ng.conf
├── usr/
│   ├── bin/systemd-machine-id-setup
│   ├── lib/calamares/modules/      # Custom calamares modules (basestrap, packages)
│   ├── local/bin/antergos-offline-install
│   └── share/applications/
│       ├── calamares.desktop               # Branded launcher
│       └── antergos-offline-install.desktop
```

## Key files

### `etc/calamares/` and `etc/calamares-online/` — both online

Both directories serve the **online** installer. There is no offline Calamares config in this overlay (and no offline Calamares mode at all — see [Installer](installer)).

- `etc/calamares/modules/` — the active module configs at runtime. After `calamares-next.sh` copies `calamares-online/settings.conf` to `/etc/calamares/settings.conf`, the `modules-search: [ local ]` directive resolves modules from this directory.
- `etc/calamares-online/` — the online install sequence (`settings.conf`) plus its own `modules/` tree. The two module trees are kept in sync; the `calamares-online/modules/` copies exist so the online flow has a self-contained config source. The copies under `calamares/modules/` are what actually loads at runtime.

### `etc/calamares-online/settings.conf`

The online install sequence. Defines two `packagechooser` instances:

- `packagechooser@de` — desktop environment selector using `method: netinstall-add`. Writes the selected DE's package group to the `netinstallAdd` global storage key. The DE group is dynamically appended to the netinstall tree when the netinstall module loads.
- `packagechooser@dm` — display manager selector using `method: netinstall-add` with inline DM groups. Appends the chosen DM group to the netinstall tree.

The `modules-search: [ local ]` directive resolves module configs from the same directory as the settings file (`/etc/calamares/modules/`).

> There is **no** `settings.conf` at `etc/calamares/` in this overlay. The `/etc/calamares/settings.conf` on a live system is a symlink installed by the `calamares-branding-antergos-next` package (`ln -sf ../calamares-offline/settings.conf`), and `calamares-next.sh` swaps it to the online config at runtime. The `calamares-offline` fallback is unused — the launcher always overwrites the symlink with the online config.

### `etc/calamares/modules/basestrap.conf`

Controls package installation during bootstrapping. The `operations` list includes packages that must be installed with `--overwrite`. This is where `antergos-release` is listed to ensure it overwrites `/usr/lib/os-release` from the `filesystem` package.

### `etc/calamares-online/modules/*.conf`

Additional modules required for the online install flow:

| File | Purpose |
|------|---------|
| `initcpio.conf` | mkinitcpio generation |
| `locale.conf` | Locale and timezone |
| `mount.conf` | Filesystem mounting |
| `partition.conf` | Disk partitioning |
| `umount.conf` | Unmounting |
| `users.conf` | User creation |
| `welcome.conf` | Welcome page |

### `usr/share/applications/calamares.desktop`

The branded "Install Antergos NeXT" launcher (plus `antergos-offline-install.desktop` for the offline installer). Both run with `sudo -E`. The upstream Artix "Install Artix Linux" entry is hidden via `NoExtract` in `pacman.conf.d/iso-x86_64.conf` (see [Launcher](launcher)).

## Module configs removed

The following files were removed during the transition away from the init system selector:

- `packagechooser.conf` — the old init system selector (dinit/openrc/runit/s6). Replaced by `packagechooser_de.conf` (DE selector).
- `images/` — SVG icons for init systems (dinit.svg, openrc.svg, runit.svg, s6.svg). No longer needed.

These files were removed in commit `6ec25cc` (2026-07-24) when the DE selector landed.

## DE selector package lists

The two copies of `packagechooser_de.conf` differ in their package granularity:

- `calamares/modules/packagechooser_de.conf` — **explicit package lists** (e.g. all 44 Plasma packages listed individually). Users see the full list in the netinstall refinement step.
- `calamares-online/modules/packagechooser_de.conf` — **meta/group packages** (e.g. `plasma`, `xfce4`, `mate`). Simpler but less granular for refinement.

Both use the same DE IDs and `method: netinstall-add`. The active copy at runtime is the one in `calamares/modules/`.
