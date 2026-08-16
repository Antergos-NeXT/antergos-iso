---
title: Home
layout: home
nav_order: 1
---

# Antergos NeXT

A technical successor to Antergos for the post-systemd era — **Artix Linux** base with **Dinit**, **KDE Plasma**, and the **Calamares** installer. Its own branding, its own identity — the lineage continues, the Antergos feeling doesn't get replaced.

## Download

[**Download the latest ISO**](https://github.com/Antergos-NeXT/antergos-iso/releases)
_Published to GitHub Releases. (The Internet Archive upload step in CI is currently disabled — see [CI](ci).)_

### Latest release — v2026.08.11 (Xeitoso)

What's in the latest release (v2026.08.11 "Xeitoso"):

- KDE Plasma 6 on Wayland (with SDDM) — KDE installs correctly (DE/DM choosers no longer fight over the netinstall queue)
- Clock syncs after install (`ntp-dinit` installed, `ntpd` enabled)
- Full audio support on installed systems (patched pipewire launcher for dinit)
- Custom SDDM theme — `pixie-sddm-git` (Material Design 3, not Breeze)
- Correct `/usr/lib/os-release` (shows "Antergos NeXT", not "Artix Linux")
- Choose your desktop (Plasma/Xfce/Cinnamon/MATE/LXQt/i3/Sway/Hyprland/COSMIC)
- Choose your init during install (dinit/runit/s6)
- GRUB with Antergos theme
- Custom Calamares slideshow + DM selector with screenshots
- LightDM with slick-greeter and proper config out of the box
- Filesystem tools in the default group (btrfs-progs, xfsprogs, f2fs-tools, snapper)
- Xlibre X server included
- Offline bare-minimum installer (`antergos-offline-install`)

Only KDE Plasma was tested this release. The other DEs are in the installer but best-effort — see the [release notes](https://github.com/Antergos-NeXT/antergos-iso/releases/tag/v2026.08.11-release). The offline installer is also **experimental and best-effort** — the online Calamares flow is the supported path.

### Known issues in this release

- **COSMIC breaks the display manager on an online install** — the online `displaymanager.conf` never listed `greetd`, so Calamares skips `DMgreetd` and never writes `/etc/greetd/config.toml`. Fixed on `master` (`00e1390`, hotfix, Aug 13) and will ship in the next release.
- **KDE Plasma is the only tested DE** — Xfce, Cinnamon, MATE, LXQt, i3, Sway, Hyprland and COSMIC are in the installer but unverified. Report results in an issue.
- **The offline installer is experimental and best-effort** — the online Calamares flow is the supported path.

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
- [Offline Installer](byode) — the BYODE bare-minimum installer

## What changed from original Antergos

| Area | Original Antergos | Antergos NeXT |
|------|-------------------|---------------|
| Base | Arch Linux (systemd) | Artix Linux |
| Default init | systemd | Dinit (others via [changing-init](changing-init)) |
| Desktop | GNOME | KDE Plasma |
| Installer | Custom Cnchi | Calamares (online) + BYODE (offline) |
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
