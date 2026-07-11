---
title: Overlays
layout: default
nav_order: 11
has_children: true
---

# Overlays

Two directories under `iso-profiles/antergos/` control what goes into the ISO:

```
iso-profiles/antergos/
├── profile.yaml          # Package lists, services, compression
├── root-overlay/         # → rootfs (squashfs) — becomes part of installed system
└── live-overlay/         # → live environment only — not present after installation
```

## How overlays work

- **root-overlay** files are merged into the root squashfs. Everything in here becomes part of the installed system — settings, wallpapers, autostart entries.
- **live-overlay** files are copied into the live environment only. They exist in the live session but are **not** present after installation. Calamares configs, the launcher desktop entry, and init-related configs live here.
- Overlays are **self-contained** (no symlinks to external directories) so the repo builds standalone.

## Important: overlay behavior

Live-overlay files are **copied** via `cp -LR` in `make_livefs()`, not overlay-mounted. This means:

- You **cannot** hide a file from a package by placing an empty file in live-overlay — the package version still exists underneath
- To hide a desktop entry, use `NoDisplay=true` in the `.desktop` file
- To replace a file, your live-overlay version wins during copy

## Related pages

- [Root Overlay](overlay-root) — persistent system config, wallpapers, skel
- [Live Overlay](overlay-live) — installer configs, launcher, SDDM session
