---
title: Packages
layout: default
nav_order: 6
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

Built and published in this order (from `packages.yaml` in `antergos-packages`):

| Package | Purpose |
|---------|---------|
| `antergos-lsb-release` | LSB release identification |
| `antergos-next-desktop-settings` | Default desktop settings for the live session |
| `antergos-next-keyring` | GPG keyring for the `[antergos-pkgs]` repo |
| `antergos-next-mirrorlist` | Mirror list for `[antergos-pkgs]` |
| `antergos-release` | `/usr/lib/os-release` with "Antergos NeXT" identification |
| `pixie-sddm-git` | Material Design 3 SDDM theme (from AUR) |
| `antergos-wallpapers` | Default wallpapers for KDE and other DEs |
| `antergos-welcome` | "About Antergos NeXT" welcome app (KF6 + Qt6) |
| `antergos-grub-theme` | GRUB boot theme |
| `antergos-live` | Live session meta package (per-init: `antergos-live-base`, `antergos-live-dinit`, `antergos-live-openrc`) |
| `pipewire` (forked) | Patched `artix-pipewire-launcher` for dinit support + XDG autostart entry |
| `calamares` | Built with `packagechooser` module enabled |
| `calamares-branding-antergos-next` | Branding: slideshow, `branding.desc`, launcher script, packagechooser configs |
| `antergos-xfce-theme` | Xfce theme |
| `downgrade` | AUR package (downgrade helper) |
| `yay` | AUR helper |
| `antergos-layan-theme` | Layan theme suite: KDE configs, Kvantum, SDDM theme, plasmoids, video wallpaper |
| `tela-circle-icon-theme-git` | Icon theme (from AUR) |
| `kwin-zones` | KWin window tiling zones |
| `oh-my-posh-bin` | Shell prompt (from AUR) |
| `pacseek` | Package search GUI (from AUR) |
| `antergos-i3-config` | i3 configuration |
| `antergos-sway-config` | Sway configuration |
| `antergos-hyprland-config` | Hyprland configuration |

## PKGBUILD notes

### calamares

- `_skip_modules` includes `dracut`, `initramfs`, `initramfscfg` — these are systemd-holdovers not needed on Artix (uses mkinitcpio)
- **`-DCMAKE_DISTRIBUTION_NAME` is a no-op** — Calamares ignores it completely. The "for \<distro\>" text in the about dialog comes from `versionedName` in the active branding component at runtime. Do NOT add this flag.

### calamares-branding-antergos-next

- Ships `calamares-next.sh` — installed as `/usr/bin/calamares-next`, the online installer launcher
- Ships the online settings file as `/etc/calamares-online/settings.conf`. It also ships an `settings_offline.conf` installed as `/etc/calamares-offline/settings.conf` (with `/etc/calamares/settings.conf` symlinked to it by default) — but this is **unused**: the launcher's `SetConfig()` always replaces it with the online config at runtime. Calamares is online-only.
- Ships module configs to `/etc/calamares/modules/`: `unpackfs.conf`, `initcpiocfg.conf`, `initcpio.conf`, `netinstall.conf`, `netinstall.yaml`, `packagechooser_de.conf`, `packagechooser_dm.conf`, `services-artix.conf`, `welcome.conf`
- Also overwrites `/usr/share/calamares/branding/default/` so the Artix default branding can't sneak in
- `SetConfig()` must `rm -f` the symlink at `/etc/calamares/settings.conf` before copying, otherwise `cp` follows the symlink and overwrites the wrong file

### pipewire (forked)

- Ships `pipewire.desktop` at `/etc/xdg/autostart/` so installed systems get the XDG autostart entry
- Patches `artix-pipewire-launcher`: sets `dinit|runit|s6) SUPPORT='YES'` (upstream only supported `openrc`/`systemd`). Without this, the launcher silently exits on dinit systems and pipewire never starts.

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

Packages are built and published via CI in the `antergos-packages` repo. Build order is defined in `packages.yaml`. AUR packages (`yay`, `downgrade`, `pixie-sddm-git`, etc.) are included with retry logic for transient clone failures. The repo index is generated as `antergos-pkgs.db` / `antergos-pkgs.files` under `antergos-pkgs/os/x86_64/` and published to GitHub Pages, served by `repo-add`.
