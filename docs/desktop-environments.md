---
title: Desktop Environments
layout: default
nav_order: 9
---

# Desktop Environments

Available desktops in online mode, sourced from Artix repos.

## Plasma (KDE)

| | |
|---|---|
| **Repo** | world |
| **Group** | `plasma` |
| **Session** | `plasma.desktop` (Wayland) / `plasmax11.desktop` (X11) |
| **Notes** | Default DE. Wayland is the default session. `plasma-wayland-session` is NOT a separate package on Artix — it's bundled in `plasma-workspace`. Includes `discover` (KDE's package manager GUI) |

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

## COSMIC

| | |
|---|---|
| **Repo** | galaxy |
| **Group** | `cosmic` |
| **Session** | `cosmic.desktop` |
| **Notes** | Rust-based, Wayland-native. Uses greetd + cosmic-greeter (not SDDM). Alpha quality, not for production. Select `greetd` in the display-manager chooser — `cosmic-greeter` requires the `greetd` daemon. |

## Not available

- **Budgie** — not in any Artix repo (system, world, galaxy, lib32). Slideshow entries removed.
- **GNOME** — dropped non-systemd support upstream. Not available.
- **No Desktop** — a "no desktop / base only" option does not exist in the installer. Pick a DE from the list above.
