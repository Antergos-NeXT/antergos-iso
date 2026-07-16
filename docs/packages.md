---
title: Packages
layout: default
nav_order: 5
---

# Custom Packages

Custom PKGBUILDs live in the [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) repo. Built and published via CI to GitHub Pages as a pacman repository.

## Repo setup

```ini
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://antergos-next.github.io/antergos-packages
```

## Package list

| Package | Purpose |
|---------|---------|
| `calamares` | Built with `packagechooser` module enabled; `dracut`/`initramfs` modules skipped |
| `calamares-branding-antergos-next` | Branding: slideshow, `branding.desc`, launcher script (`calamares-next.sh`), packagechooser configs, initcpio configs |
| `antergos-wallpapers` | Default wallpapers for KDE and other DEs |
| `linux-next` | Custom kernel based on `linux-artix` |
| `winver` | "About Antergos NeXT" dialog (KF6 + Qt6) |
| `pipewire` (forked) | Patched `artix-pipewire-launcher` for dinit support + XDG autostart entry |
| `antergos-sddm-theme` | SDDM theme files + `theme.conf` override for `kde_settings.conf` |
| `antergos-release` | `/usr/lib/os-release` with "Antergos NeXT" identification |

## PKGBUILD notes

### calamares

- `_skip_modules` includes `dracut`, `initramfs`, `initramfscfg` — these are systemd-holdovers not needed on Artix (uses mkinitcpio)
- **`-DCMAKE_DISTRIBUTION_NAME` is a no-op** — Calamares ignores it completely. The "for \<distro\>" text in the about dialog comes from `versionedName` in the active branding component at runtime. Do NOT add this flag.

### calamares-branding-antergos-next

- Ships `calamares-next.sh` — the launcher script that presents the mode picker and manages config switching
- `packagechooser.conf` provides a DM-only fallback for standalone use
- `SetConfig()` must `rm -f` the symlink at `/etc/calamares/settings.conf` before copying, otherwise `cp` follows the symlink and overwrites the wrong file

### pipewire (forked)

- Ships `pipewire.desktop` at `/etc/xdg/autostart/` so both offline and online installs get the XDG autostart entry
- Patches `artix-pipewire-launcher`: changes `dinit|openrc) SUPPORT=''` to `dinit|runit|s6) SUPPORT='YES'`. Without this, the launcher silently exits on dinit systems and pipewire never starts.
- Also modifies `dinit|runit|s6) SUPPORT='YES'` line handling to include dinit in the regex

### antergos-sddm-theme

- Ships `theme.conf` at `/etc/sddm.conf.d/theme.conf` with `[Theme]\nCurrent=antergos`
- SDDM reads `conf.d` files in alphabetical order. Since `theme.conf` sorts after `kde_settings.conf` (from KDE's SDDM KCM), its `Current=antergos` wins
- The theme directory must be named to match `componentName` in the theme descriptor (`antergos`)

### antergos-wallpapers

- Installs to `/usr/share/wallpapers/antergos-wallpaper/contents/images/` with `metadata.desktop` for KDE picker support
- Also available at `/usr/share/backgrounds/antergos/` for other DEs
- Ships three wallpapers: original Antergos PNG (default), Adwaita Morning, and antergos-darkest-hour

## File conflicts

| Package 1 | Package 2 | File | Resolution |
|-----------|-----------|------|------------|
| `calamares` | `calamares-branding-antergos-next` | `/usr/share/calamares/branding/default/branding.desc`, `show.qml` | `--overwrite='*'` in `./buildiso` |
| `filesystem` | `antergos-release` | `/usr/lib/os-release` | `antergos-release` in basestrap operations list (uses `--overwrite`) |

## Build system

Packages are built and published via CI in the `antergos-packages` repo. Build order is defined in `packages.yaml`. AUR packages (`yay`, `downgrade`) are included with retry logic for transient clone failures. The package index (`index.db`, `index.files`) is generated with timestamps in Europe/Berlin timezone.
