---
title: Home
layout: home
nav_order: 1
---

# Antergos NeXT

A community revival of Antergos for the post-systemd era — **Artix Linux** base with **Dinit** (OpenRC / Runit / S6 available), **KDE Plasma**, and the **Calamares** installer (offline + online modes).

## Download

[**Download the latest ISO**](https://github.com/Antergos-NeXT/antergos-iso/releases)
_Published to GitHub Releases. ISO also archived on the Internet Archive._

### First stable release — v2026.07.11

This is the first stable ISO. What works:

- KDE Plasma 6 on Wayland (with SDDM)
- Full audio support on both offline and online installs
- Custom SDDM theme (Antergos brand, not Breeze)
- Correct `/usr/lib/os-release` (shows "Antergos NeXT", not "Artix Linux")
- Offline mode: unpack pre-built Plasma squashfs, no internet required
- Online mode: choose your init (Dinit/OpenRC/Runit/S6) and desktop (Plasma/Xfce/Cinnamon/MATE/LXQt/i3/Sway/Hyprland)
- GRUB with Antergos theme
- Custom Calamares slideshow
- Xlibre X server included

## Quick links

- [Building the ISO](building) — set up and build locally
- [Installer](installer) — Calamares modes, init & DE selectors
- [Custom packages](packages) — PKGBUILDs, pipewire fork, branding
- [CI/CD](ci) — GitHub Actions pipeline, Internet Archive upload
- [Development](development) — contributing, gotchas, conventions

## Learn about Antergos NeXT

- [Init Systems](init-systems) — Dinit, OpenRC, S6, Runit compared
- [Desktop Environments](desktop-environments) — available DEs in online mode
- [Wallpapers](wallpapers) — where they go, how they work

## What changed from original Antergos

| Area | Original Antergos | Antergos NeXT |
|------|-------------------|---------------|
| Base | Arch Linux (systemd) | Artix Linux (Dinit / OpenRC / Runit / S6) |
| Default init | systemd | Dinit |
| Desktop | GNOME | KDE Plasma |
| Installer | Custom Cnchi | Calamares |
| Build system | archiso | artools (`buildiso`) |
| Display server | X11 | Wayland (X11 via Xlibre) |

## Project scope

This repo (`antergos-iso`) contains the ISO build configuration — overlays, Calamares modules, pacman config, CI pipeline. Custom PKGBUILDs live in the separate [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) repo.

## Sources

- [Artix Linux](https://artixlinux.org)
- [artools](https://gitea.artixlinux.org/artix/artools)
- [Calamares](https://codeberg.org/calamares/calamares)
- [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages)
- [Original Antergos wallpapers](https://github.com/Antergos/wallpapers)
