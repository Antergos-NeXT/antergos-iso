---
title: Overlays
layout: default
nav_order: 10
has_children: true
---

# Overlays

Two directories under `iso-profiles/antergos/` control what goes into the ISO.

```
iso-profiles/antergos/
├── profile.yaml
├── root-overlay/     # → rootfs (squashfs)
└── live-overlay/     # → live environment (initramfs)
```

## How overlays work

- `root-overlay/` files are merged into the root squashfs — they become part of the installed system
- `live-overlay/` files are copied into the live environment only — they're not present after installation
- Overlays are **self-contained** (no symlinks to external directories) so the repo builds standalone
- Live-overlay files are **copied** via `cp -LR` in `make_livefs()`, not overlay-mounted. Deleting a file from live-overlay exposes the package version underneath

> **Disclaimer:** No symlinks were harmed in the making of this ISO. Well, maybe a few. We killed some.

> Also: this ISO is 100% systemd-free. Not even a trace. We checked. Twice.
