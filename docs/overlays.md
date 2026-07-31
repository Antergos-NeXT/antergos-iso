---
title: Overlays
layout: default
nav_order: 12
has_children: true
---

# Overlays

Two directories under `iso-profiles/antergos/` control what goes into the ISO:

```
iso-profiles/antergos/
├── profile.yaml          # Package lists, services, compression
├── root-overlay/         # → live rootfs — config for the live session
└── live-overlay/         # → live environment — installer configs and tools
```

## How overlays work

- **root-overlay** files are merged into the live rootfs — the filesystem the ISO boots. Settings here (os-release, SDDM, wallpapers) affect the live session.
- **live-overlay** files are merged into the live environment on top. Calamares configs, the launcher desktop entries, and live-only tools live here.
- **Neither is copied to the installed system.** The Calamares online install builds the target system fresh from packages via `basestrap`. Persistent configuration must ship as a package (`antergos-release`, `antergos-layan-theme`, etc.).
- Overlays are **self-contained** (no symlinks to external directories) so the repo builds standalone.

## Important: overlay behavior

Live-overlay files are **copied** via `cp -LR` in `make_livefs()`, not overlay-mounted. This means:

- You **cannot** hide a file from a package by placing an empty file in live-overlay — the package version still exists underneath
- To hide a desktop entry shipped by a package, use `NoExtract` in `pacman.conf.d/iso-x86_64.conf` (this is how the Artix "Install Artix Linux" entry is suppressed)
- To replace a file, your overlay version wins during copy

## Related pages

- [Root Overlay](overlay-root) — live rootfs config, SDDM, wallpapers
- [Live Overlay](overlay-live) — installer configs, launcher, offline installer
