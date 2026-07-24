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
│   │   └── settings.conf           # Replaced at runtime by online config
│   ├── calamares-online/
│   │   ├── settings.conf           # Online install config (two packagechooser instances)
│   │   └── modules/
│   │       ├── packagechooser_de.conf         # Desktop environment selector
│   │       ├── packagechooser_dm.conf         # Display manager selector
│   │       ├── initcpiocfg.conf
│   │       ├── initcpio.conf
│   │       ├── locale.conf
│   │       ├── mount.conf
│   │       ├── partition.conf
│   │       ├── umount.conf
│   │       ├── users.conf
│   │       └── welcome.conf
│   └── sddm.conf.d/
│       └── kde_settings.conf       # SDDM autologin + Wayland session
└── usr/
    └── share/
        └── applications/
            ├── calamares.desktop               # Branded launcher
            └── calamares-config-switcher.desktop  # Hidden (NoDisplay=true)
```

## Key files

### `etc/calamares/settings.conf`

Placeholder — replaced at runtime by `calamares-next.sh` which copies the online settings file.

### `etc/calamares-online/settings.conf`

Defines two `packagechooser` instances:

- `packagechooser@de` — desktop environment selector using `method: netinstall-add`. Writes the selected DE's package group to the `netinstallAdd` global storage key. The DE group is dynamically appended to the netinstall tree when the netinstall module loads.
- `packagechooser@dm` — display manager selector using `method: netinstall-select`. Marks the chosen DM group as checked in the netinstall tree.

The `modules-search: [ local ]` directive resolves module configs from the same directory as the settings file (`/etc/calamares/modules/`).

### `etc/calamares/modules/` vs `etc/calamares-online/modules/`

- `calamares/modules/` — active module configs at runtime. The settings file resolves modules from this directory after being copied to `/etc/calamares/`.
- `calamares-online/modules/` — reference copies and additional modules (e.g. `partition.conf`, `mount.conf`) that are used during the online install flow. These are not loaded directly but serve as the source of truth for the install sequence.

### `etc/calamares/modules/basestrap.conf`

Controls package installation during bootstrapping. The `operations` list includes packages that must be installed with `--overwrite`. This is where `antergos-release` is listed to ensure it overwrites `/usr/lib/os-release` from the `filesystem` package.

### `etc/calamares-online/modules/*.conf`

Additional modules required for the online install flow:

| File | Purpose |
|------|---------|
| `initcpio.conf` | mkinitcpio generation |
| `initcpiocfg.conf` | mkinitcpio configuration |
| `locale.conf` | Locale and timezone |
| `mount.conf` | Filesystem mounting |
| `partition.conf` | Disk partitioning |
| `umount.conf` | Unmounting |
| `users.conf` | User creation |
| `welcome.conf` | Welcome page |

### `usr/share/applications/calamares-config-switcher.desktop`

Has `NoDisplay=true` to hide it from the app menu. The upstream Artix "Install Artix Linux" entry is suppressed this way while keeping the binary available.

## Module configs removed

The following files were removed during the transition away from the init system selector:

- `packagechooser.conf` — the old init system selector (dinit/openrc/runit/s6). Replaced by `packagechooser_de.conf` (DE selector).
- `images/` — SVG icons for init systems (dinit.svg, openrc.svg, runit.svg, s6.svg). No longer needed.

These changes were made in the v2026.07.24 release cycle.

## DE selector package lists

The two copies of `packagechooser_de.conf` differ in their package granularity:

- `calamares/modules/packagechooser_de.conf` — **explicit package lists** (e.g. all 44 Plasma packages listed individually). Users see the full list in the netinstall refinement step.
- `calamares-online/modules/packagechooser_de.conf` — **meta/group packages** (e.g. `plasma`, `xfce4`, `mate`). Simpler but less granular for refinement.

Both use the same DE IDs and `method: netinstall-add`. The active copy at runtime is the one in `calamares/modules/`.
