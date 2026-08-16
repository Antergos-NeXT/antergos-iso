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

### Latest release — v2026.08.17 (Arranxo)

Hotfix release. What's fixed in v2026.08.17 "Arranxo":

- **COSMIC display manager now works** — `cosmic-greeter-dinit` ships as its own package and the online `displaymanager.conf` lists `greetd`, so `/etc/greetd/config.toml` gets written and the greeter starts. The Xeitoso-era COSMIC-breaks-DM bug is gone.
- **zsh login lockout fixed** — `users.conf` forces `/bin/zsh` but nothing installed it, so a freshly installed system couldn't log in. `zsh` is now in the netinstall Default group. Thanks to jtadlock91 for reporting it.
- **New KDE Plasma (Minimal) entry** — a stripped-down Wayland-only Plasma for low-end hardware: `plasma-meta`, kitty, pcmanfm-qt, featherpad, grim, slurp. No XWayland, no branding, no bloat.

Only KDE Plasma was tested this release. The other DEs are in the installer but best-effort — see the [release notes](https://github.com/Antergos-NeXT/antergos-iso/releases/tag/v2026.08.17-release). The offline installer is also **experimental and best-effort** — the online Calamares flow is the supported path.

### Known issues in this release

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
