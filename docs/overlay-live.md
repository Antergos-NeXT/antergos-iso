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
│   │   ├── settings.conf           # Online install config (packagechooser)
│   │   └── modules/
│   │       ├── packagechooser_dm.conf        # Display manager selector
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

Placeholder — replaced at runtime by `calamares-next.sh` which copies the online settings file.

### `etc/calamares-online/settings.conf`

One `packagechooser` instance for DM selection (`packagechooser@dm`) using `netinstall-select`.

### Offline config (archived)

The offline install mode was removed in v2026.07.16 — it was never truly offline (all DE packages were still downloaded via basestrap). The configs are preserved at `iso-profiles/antergos/calamares-offline/` for reference.

### `etc/calamares/modules/basestrap.conf`

Controls package installation during bootstrapping. The `operations` list includes packages that must be installed with `--overwrite`. This is where `antergos-release` is listed to ensure it overwrites `/usr/lib/os-release` from the `filesystem` package.

### `usr/share/applications/calamares-config-switcher.desktop`

Has `NoDisplay=true` to hide it from the app menu. The upstream Artix "Install Artix Linux" entry is suppressed this way while keeping the binary available.
