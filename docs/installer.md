---
title: Installer
layout: default
nav_order: 5
---

# Calamares Installer

Antergos NeXT uses [Calamares](https://codeberg.org/calamares/calamares) as its installer, with a custom launcher (`calamares-next`) that launches Calamares directly in online mode.

## Install mode

Online-only (since v2026.07.16). The so-called "Offline Install" was removed — it was never truly offline: the rootfs only contained live session essentials, and all DE packages were still downloaded via basestrap. All installs now use the full netinstall flow with desktop selection.

## Fixed issues

### Audio on installed systems

The upstream `artix-pipewire-launcher` doesn't support dinit. The XDG autostart entry was also missing from the upstream package.

**Fix**: The `pipewire` package in `[antergos-pkgs]` now includes `pipewire.desktop` installed to `/etc/xdg/autostart/`, and the `artix-pipewire-launcher` script is patched to recognize dinit (`dinit|runit|s6) SUPPORT='YES'`).

### SDDM theme showing Breeze

KDE's SDDM KCM writes a `kde_settings.conf` with `Current=breeze`. The Antergos theme never took effect in the live session.

**Fix**: The `antergos-sddm-theme` package now ships `theme.conf` at `/etc/sddm.conf.d/theme.conf` with `Current=antergos`. SDDM reads `conf.d` files alphabetically, so `theme.conf` (reads after `kde_settings.conf`) wins.

### `/usr/lib/os-release` showing "Artix Linux"

The `filesystem` package from Artix owns `/usr/lib/os-release`. Our `antergos-release` also needs to install there, but it wasn't included in the basestrap operations list.

**Fix**: Added `antergos-release` to the `operations` list in `basestrap.conf` so it's installed during bootstrapping with `--overwrite`.

## Key differences from upstream Calamares

- `dracut`/`dracutlukscfg` replaced with `initcpiocfg`/`initcpio`/`luksopenswaphookcfg` (Artix uses mkinitcpio, not dracut)
- `services-artix` module instead of `services-systemd` (uses `artix-service` which detects init and runs the right commands)
- `removeuser` step removed, `postcfg` added
- `packagechooser` module compiled in (upstream Calamares skips it by default)

## Init system

Antergos NeXT ships **Dinit** only. Other init systems (OpenRC, Runit, S6) are available in the Artix repos but are not offered as install-time options. See [Changing init on an installed system](changing-init) for instructions if you need a different init.

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

## Branding

Custom branding lives in the `calamares-branding-antergos-next` package, installed to `/etc/calamares/branding/default/`. The `componentName` in `branding.desc` must match its directory name — this is enforced by Calamares (see `Branding.cpp`).

## GRUB configuration

The installation sequence runs `grubcfg` before `bootloader`. The `grubcfg` module writes `/etc/default/grub` on the target system; the `bootloader` module then runs `grub-install` and `grub-mkconfig -o /boot/grub/grub.cfg`.

The Artix `grub` package ships its own default `/etc/default/grub`. Because this file exists on the target at module runtime, the module's `defaults` block is only applied when `overwrite` is set to `true`. The `grubcfg.conf` at `live-overlay/etc/calamares/modules/grubcfg.conf` therefore sets `overwrite: true` to ensure `GRUB_THEME`, `GRUB_TERMINAL_OUTPUT`, and `GRUB_DISTRIBUTOR` are written.

`GRUB_TERMINAL_OUTPUT` must be `"gfxterm"` for the GRUB theme to render; `"console"` disables graphical output and prevents theme loading.

## Bootloader target detection

The `bootloader` module auto-detects the GRUB target architecture using the system's EFI bitness and CPU type. For UEFI x86_64, it installs with `--target=x86_64-efi`. For Legacy BIOS boots, it falls back to `--target=i386-pc`. There is no configuration key to override this — a system booted in BIOS mode will always receive an i386-pc bootloader.

## Launcher

The `calamares-next` script (`/usr/bin/calamares-next`) handles the installer boot flow:

1. **Notice** — explains why the offline mode was removed
2. **Welcome** — branded splash with Install button
3. **Configuration** — copies `calamares-online/settings.conf` to `/etc/calamares/settings.conf`
4. **Launch** — runs `calamares` with the online config

During installation, the launcher monitors pacman activity and saves the package installation log to `~/pacman-install.log`. No terminal windows are opened to display progress.

Launched via the desktop entry in the live session: `Exec=sudo -E calamares-next`.
