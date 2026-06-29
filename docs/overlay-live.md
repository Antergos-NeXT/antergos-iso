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
│   │   ├── settings.conf           # -> symlinks to online or offline
│   ├── calamares-offline/
│   │   ├── settings.conf           # Offline install config (unpackfs)
│   │   └── modules/
│   │       └── ...
│   ├── calamares-online/
│   │   ├── settings.conf           # Online install config (packagechooser)
│   │   └── modules/
│   │       ├── packagechooser_init.conf      # Init system selector
│   │       ├── packagechooser_desktop.conf   # DE selector
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

Symlink — points to either `../calamares-offline/settings.conf` or `../calamares-online/settings.conf`, set by `calamares-next.sh`.

### `etc/calamares-online/settings.conf`

Two `packagechooser` instances:
- `packagechooser@init` — init system (OpenRC, Runit, S6, Dinit) via netinstall-add
- `packagechooser@desktop` — DE selection via legacy method

### `etc/calamares-online/modules/packagechooser_init.conf`

Init selector config. Uses `method: netinstall-add` — the selected init pulls its associated packages.

### `etc/calamares-online/modules/packagechooser_desktop.conf`

DE selector config. Uses `method: legacy` — returns the selected DE as a global storage value.

### `etc/calamares-offline/settings.conf`

No packagechooser. Uses `unpackfs` to deploy a pre-built KDE Plasma squashfs.

### `usr/share/applications/calamares-config-switcher.desktop`

Has `NoDisplay=true` to hide it from the app menu. The upstream Artix "Install Artix Linux" entry is suppressed this way.
