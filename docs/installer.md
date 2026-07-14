---
title: Installer
layout: default
nav_order: 4
---

# Calamares Installer

Antergos NeXT uses [Calamares](https://codeberg.org/calamares/calamares) as its installer, with a custom launcher (`calamares-next`) that presents a mode picker before launching Calamares.

## Modes

| Mode | Description |
|------|-------------|
| **Offline** | Unpacks a pre-built KDE Plasma squashfs — no internet needed. Fast, deterministic, single option. |
| **Online** | Netinstall with init system choice + desktop selection. Downloads packages from the internet. |

## Fixed issues (v2026.07.11)

### Audio on installed systems

The offline install works because `pipewire.desktop` is baked into the root squashfs via `root-overlay`. But in online mode, packages are installed fresh — and the upstream `artix-pipewire-launcher` doesn't support dinit. The XDG autostart entry was also missing.

**Fix**: The `pipewire` package in `[antergos-pkgs]` now includes `pipewire.desktop` installed to `/etc/xdg/autostart/`, and the `artix-pipewire-launcher` script is patched to recognize dinit (`dinit|runit|s6) SUPPORT='YES'`). This way both offline and online installs get working audio.

### SDDM theme showing Breeze

KDE's SDDM KCM writes a `kde_settings.conf` with `Current=breeze`. The Antergos theme never took effect in the live session.

**Fix**: The `antergos-sddm-theme` package now ships `theme.conf` at `/etc/sddm.conf.d/theme.conf` with `Current=antergos`. SDDM reads `conf.d` files alphabetically, so `theme.conf` (reads after `kde_settings.conf`) wins.

### `/usr/lib/os-release` showing "Artix Linux"

The `filesystem` package from Artix owns `/usr/lib/os-release`. Our `antergos-release` also needs to install there, but it wasn't included in the basestrap operations list.

**Fix**: Added `antergos-release` to the `operations` list in `basestrap.conf` so it's installed during bootstrapping with `--overwrite`.

## Key differences from upstream Calamares

- `dracut`/`dracutlukscfg` replaced with `initcpiocfg`/`initcpio`/`luksopenswaphookcfg` (Artix uses mkinitcpio, not dracut)
- `services-openrc` module instead of `services-systemd` (supports all four inits via init-specific variants)
- `removeuser` step removed, `postcfg` added
- `packagechooser` module compiled in (upstream Calamares skips it by default)

## Init system selector (online)

Users choose from: **Dinit**, **OpenRC**, **Runit**, **S6**.

> **Note:** OpenRC is currently broken in Antergos NeXT — services don't enable correctly on installed systems. Choose Dinit (default), Runit, or S6 instead.

Implemented as a `packagechooser` instance with `method: netinstall-add`. The selected init pulls its associated packages (e.g. `elogind-dinit`, `connman-dinit`, `sddm-dinit`). The init packages are defined in `netinstall.yaml` as separate groups.

Dinit is preselected by default.

## Desktop selector (online)

Users choose from: **Plasma**, **Xfce**, **Cinnamon**, **MATE**, **LXQt**, **i3**, **Sway**, **Hyprland**, **COSMIC**, or **No Desktop**.

Implemented as a separate `packagechooser` instance with `method: legacy`. "No Desktop" installs only the base system (TTY/login — no DE, no display manager).

## Available desktops

| Desktop | Artix Repo | Group/Packages | Notes |
|---------|------------|----------------|-------|
| Plasma | world | `plasma` group | Default. Wayland + X11. Includes Discover |
| Xfce | galaxy | `xfce4` group | |
| Cinnamon | galaxy | Individual packages | |
| MATE | galaxy | `mate` + `mate-extra` | |
| LXQt | galaxy | `lxqt` group | |
| i3 | world | `i3` group | Tiling WM |
| Sway | world | `sway` + related | Wayland-native tiling |
| Hyprland | world | `hyprland` | Wayland compositor |
| COSMIC | galaxy | `cosmic` group | Rust/Wayland. Uses greetd. Alpha quality |

## Not available

- **Budgie** — not in any Artix repo (system, world, galaxy, lib32). Slideshow entries removed.
- **GNOME** — dropped non-systemd support upstream. "You really think you can get GNOME here?"

## Offline mode

No packagechooser. Uses `unpackfs` to deploy a pre-built KDE Plasma squashfs, then `initcpiocfg` + `initcpio` for mkinitcpio configuration.

## Branding

Custom branding lives in the `calamares-branding-antergos-next` package, installed to `/etc/calamares/branding/default/`. The `componentName` in `branding.desc` must match its directory name — this is enforced by Calamares (see `Branding.cpp`).

## Launcher

The `calamares-next` script (`/usr/bin/calamares-next`) handles the installer boot flow:

1. **Mode picker** — `kdialog`/`zenity` dialog asking Offline or Online install
2. **Configuration** — copies the appropriate `settings.conf` (offline or online) to `/etc/calamares/settings.conf`
3. **Launch** — runs `calamares` with the selected config

Launched via the desktop entry in the live session: `Exec=sudo -E calamares-next`.
