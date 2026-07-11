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
│   │   └── settings.conf           # Symlink → online or offline config
│   ├── calamares-offline/
│   │   ├── settings.conf           # Offline install config (unpackfs)
│   │   └── modules/
│   │       ├── unpackfs.conf
│   │       ├── initcpiocfg.conf
│   │       └── ...
│   ├── calamares-online/
│   │   ├── settings.conf           # Online install config (packagechooser)
│   │   └── modules/
│   │       ├── packagechooser_init.conf      # Init system selector
│   │       ├── packagechooser_desktop.conf   # DE selector
│   │       ├── initcpiocfg.conf
│   │       └── ...
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

Symlink — points to either `../calamares-offline/settings.conf` or `../calamares-online/settings.conf`, set by `calamares-next.sh` after the user selects a mode.

### `etc/calamares-online/settings.conf`

Two `packagechooser` instances:
- `packagechooser@init` — init system (Dinit, OpenRC, Runit, S6) via netinstall-add
- `packagechooser@desktop` — DE selection via legacy method

The init selector uses `netinstall-add` method, meaning the selected init group's packages are added to the install set. The DE selector uses `legacy` method, returning the selected DE as a global storage value.

### `etc/calamares-offline/settings.conf`

No packagechooser. Uses `unpackfs` to deploy a pre-built KDE Plasma squashfs, then `initcpiocfg` + `initcpio` for mkinitcpio configuration.

### `etc/calamares/modules/basestrap.conf`

Controls package installation during bootstrapping. The `operations` list includes packages that must be installed with `--overwrite`. This is where `antergos-release` is listed to ensure it overwrites `/usr/lib/os-release` from the `filesystem` package.

### `usr/share/applications/calamares-config-switcher.desktop`

Has `NoDisplay=true` to hide it from the app menu. The upstream Artix "Install Artix Linux" entry is suppressed this way while keeping the binary available.
