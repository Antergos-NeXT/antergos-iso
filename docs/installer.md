---
title: Installer
layout: default
nav_order: 3
---

# Calamares Installer

Uses [Calamares](https://codeberg.org/calamares/calamares) with two modes and custom branding.

## Modes

| Mode | Description |
|------|-------------|
| **Offline** | Unpacks a KDE Plasma squashfs — no internet needed |
| **Online** | Netinstall with init system choice + desktop selection |

The launcher (`calamares-next`) presents a mode picker before launching Calamares.

## Key differences from upstream

- `dracut`/`dracutlukscfg` replaced with `initcpiocfg`/`initcpio`/`luksopenswaphookcfg` (Artix uses mkinitcpio, not dracut)
- `services-openrc` module instead of `services-systemd`
- `removeuser` step removed, `postcfg` added
- `packagechooser` module compiled in (upstream skips it)

## Init system selector (online)

Users choose from: **OpenRC**, **Runit**, **S6**, **Dinit**.

Implemented as a `packagechooser` instance with `method: netinstall-add` — the selected init pulls its associated packages.

## Desktop selector (online)

Users choose from: **Plasma**, **Xfce**, **Cinnamon**, **MATE**, **LXQt**, **i3**, **Sway**, **Hyprland**, or **No Desktop**.

Implemented as a separate `packagechooser` instance with `method: legacy`. "No Desktop" installs only the base system (TTY-only).

## Available desktops

| Desktop | Artix Repo | Group/Packages |
|---------|------------|----------------|
| Plasma | world | `plasma` group |
| Xfce | galaxy | `xfce4` group |
| Cinnamon | galaxy | Individual packages |
| MATE | galaxy | `mate` + `mate-extra` groups |
| LXQt | galaxy | `lxqt` group |
| i3 | world | `i3` group |
| Sway | world | `sway` + related packages |
| Hyprland | world | `hyprland` |

> **Note:** Budgie is not available in any Artix repo and has been removed from all configs and slideshows.

## Offline mode

No packagechooser. Uses `unpackfs` to deploy a pre-built KDE Plasma squashfs, then `initcpiocfg` + `initcpio` for mkinitcpio configuration.

## Branding

Custom branding lives in the `calamares-branding-antergos-next` package, installed to `/etc/calamares/branding/default/`. The `componentName` in `branding.desc` must match its directory name.
