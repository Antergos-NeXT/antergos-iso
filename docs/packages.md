---
title: Packages
layout: default
nav_order: 4
---

# Custom Packages

Custom PKGBUILDs live in the [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) repo.

## Package list

| Package | Purpose |
|---------|---------|
| `calamares` | Built with `packagechooser` module enabled, `dracut`/`initramfs` modules skipped |
| `calamares-branding-antergos-next` | Branding files: `branding.desc`, `show.qml`, `settings.conf`, `packagechooser.conf`, `initcpiocfg.conf`, `initcpio.conf`, `calamares-next.sh` |
| `antergos-wallpapers` | Default wallpapers installed to `/usr/share/wallpapers/` (KDE) and `/usr/share/backgrounds/` (other DEs) |
| `linux-next` | Custom kernel based on `linux-artix` |
| `winver` | "About Antergos NeXT" dialog built with KF6 + Qt6 |

## Repo setup

```ini
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://antergos-next.github.io/antergos-packages
```

## Build system

Packages are built and published via CI. The build order is defined in `packages.yaml`. AUR packages (`yay`, `downgrade`) are included with retry logic for transient clone failures.

## Index

The package index (`index.db`, `index.files`) is generated with timestamps in **Europe/Berlin** timezone. See `generate-index.py`.

## PKGBUILD notes

### calamares

- `_skip_modules` includes `dracut`, `initramfs`, `initramfscfg` — these are Artix/systemd-holdovers not needed on OpenRC/mkinitcpio
- `-DCMAKE_DISTRIBUTION_NAME` is a **no-op** — Calamares ignores it. The "for <distro>" text comes from `versionedName` in the active branding component at runtime

### calamares-branding-antergos-next

- `packagechooser.conf` provides a DE-only fallback for standalone use
- `settings_offline.conf` / `settings_online.conf` override live-overlay settings at install time
- `calamares-next.sh` `SetConfig()` must remove the symlink before copying config, or it follows the link and overwrites the wrong file

### antergos-wallpapers

- Installs to `/usr/share/wallpapers/antergos-wallpaper/` with `metadata.desktop` for KDE picker support
- Also available at `/usr/share/backgrounds/antergos/` for other DEs
- Current wallpaper: GNOME Adwaita Morning (`adwaita-morning.webp`, CC BY-SA 3.0 by Jakub Steiner)

## File conflict notes

`calamares` and `calamares-branding-antergos-next` both claim `/usr/share/calamares/branding/default/branding.desc` and `show.qml`. Resolved at ISO build time via `--overwrite='*'` in repo's `./buildiso`.
