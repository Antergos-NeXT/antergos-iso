---
title: Desktop Environments
layout: default
nav_order: 7
---

# Desktop Environments

Available desktops in online mode, sourced from Artix repos.

## Plasma (KDE)

| | |
|---|---|
| **Repo** | world |
| **Group** | `plasma` |
| **Session** | `plasma.desktop` (Wayland) / `plasmax11.desktop` (X11) |
| **Notes** | Default DE. Wayland is the default session. `plasma-wayland-session` is NOT a separate package on Artix — it's bundled in `plasma-workspace` |

## Xfce

| | |
|---|---|
| **Repo** | galaxy |
| **Group** | `xfce4` |
| **Session** | `xfce.desktop` |

## Cinnamon

| | |
|---|---|
| **Repo** | galaxy |
| **Packages** | Individual (no meta-group) |
| **Session** | `cinnamon.desktop` |

## MATE

| | |
|---|---|
| **Repo** | galaxy |
| **Groups** | `mate` + `mate-extra` |
| **Session** | `mate.desktop` |

## LXQt

| | |
|---|---|
| **Repo** | galaxy |
| **Group** | `lxqt` |
| **Session** | `lxqt.desktop` |

## i3

| | |
|---|---|
| **Repo** | world |
| **Group** | `i3` |
| **Session** | `i3.desktop` |

## Sway

| | |
|---|---|
| **Repo** | world |
| **Packages** | `sway` + related |
| **Session** | `sway.desktop` |

## Hyprland

| | |
|---|---|
| **Repo** | world |
| **Packages** | `hyprland` |
| **Session** | `hyprland.desktop` |

## GNOME

| | |
|---|---|
| **Repo** | imaginary |
| **Group** | `gnome-systemd-hub` |
| **Session** | `does-not-exist.desktop` |
| **Status** | ❌ |

> You really think you can get GNOME here? GNOME deleted all other init support. Take a walk.

## Not available

- **Budgie** — not in any Artix repo (system, world, galaxy, lib32). Slideshow entries removed.
- **GNOME** — see above.

## No Desktop

Installs the base system only (TTY/login). Useful for servers or custom setups.
