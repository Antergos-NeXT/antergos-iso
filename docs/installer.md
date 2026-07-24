---
title: Installer
layout: default
nav_order: 5
---

# Calamares Installer

Antergos NeXT uses [Calamares](https://codeberg.org/calamares/calamares) as its installer, with a custom launcher (`calamares-next`) that launches Calamares directly in online mode.

## Install mode

Online-only (since v2026.07.16). The so-called "Offline Install" was removed — it was never truly offline: the rootfs only contained live session essentials, and all DE packages were still downloaded via basestrap. All installs now use the full netinstall flow with desktop selection.

A BYODE (Bring Your Own Desktop Environment) offline installer is still available for users who want a bare system installed from the ISO. See [BYODE](../byode).

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

## Desktop selector

The install flow begins with a dedicated desktop environment picker (`packagechooser@de`) before the package selection tree. This replaces the old netinstall-based "Desktop" group that installed all DEs when the parent checkbox was clicked.

The selector uses `method: netinstall-add` — the chosen DE's package group is dynamically added to the netinstall tree. This means users can still refine their DE packages in the subsequent netinstall step, seeing only their selected DE rather than all available options.

| Step | Module | Description |
|------|--------|-------------|
| 1 | `packagechooser@de` | Pick one DE (required, default: Plasma) |
| 2 | `packagechooser@dm` | Pick a display manager (required, default: SDDM) |
| 3 | `netinstall` | Refine package selection, add optional groups |

### Available desktops

| Desktop | Repo | Type | Notes |
|---------|------|------|-------|
| **KDE Plasma** | world | Full DE | Default. Wayland + X11. Uses the `plasma` group with antergos-next-desktop-settings |
| **Xfce** | galaxy | Full DE | Lightweight. GTK-based. Uses `xfce4` group |
| **Cinnamon** | galaxy | Full DE | Traditional layout. GNOME-based |
| **MATE** | galaxy | Full DE | GNOME 2 continuation. Uses `mate` + `mate-extra` |
| **LXQt** | galaxy | Full DE | Lightweight Qt desktop. Uses `lxqt` group |
| **i3** | world | Tiling WM | Keyboard-driven. Ships `i3` group (i3-wm, i3blocks, i3lock, i3status). Requires `antergos-i3-config` for a usable experience |
| **Sway** | world | Tiling WM | i3-compatible Wayland compositor. Requires `antergos-sway-config` |
| **Hyprland** | world | Tiling WM | Dynamic Wayland compositor with eye candy. Requires `antergos-hyprland-config` |
| **COSMIC** | galaxy | Full DE | Rust-based desktop from System76. Alpha quality. Select **greetd** as display manager |

### Not available

- **Budgie** — not in any Artix repo (system, world, galaxy, lib32). Slideshow entries removed.
- **GNOME** — dropped non-systemd support upstream. "You really think you can get GNOME here?"

### Tiling WMs and default configs

i3, Sway, and Hyprland are offered as install options but will present a black screen on first boot without a configuration file. Config packages (`antergos-i3-config`, `antergos-sway-config`, `antergos-hyprland-config`) are available from the `[antergos-pkgs]` repository and are automatically included when the corresponding DE is selected.

If you prefer to supply your own config, you can deselect the config package in the netinstall refinement step.

## Display manager selector

The DM selector (`packagechooser@dm`) uses `method: netinstall-select`. Available options:

- **SDDM** — KDE's QML-based display manager (default). Ships with `pixie-sddm-git` theme.
- **LightDM** — GTK-based, cross-desktop
- **LXDM** — Lightweight (LXDE)
- **greetd** — Minimal, recommended for COSMIC
- **LY** — TUI-based, minimal

The selected DM's group is marked as checked in the netinstall tree automatically.

## Branding

Custom branding lives in the `calamares-branding-antergos-next` package, installed to `/etc/calamares/branding/default/`. The `componentName` in `branding.desc` must match its directory name — this is enforced by Calamares (see `Branding.cpp`).

## GRUB configuration

The installation sequence runs `grubcfg` before `bootloader`. The `grubcfg` module writes `/etc/default/grub` on the target system; the `bootloader` module then runs `grub-install` and `grub-mkconfig -o /boot/grub/grub.cfg`.

The Artix `grub` package ships its own default `/etc/default/grub`. Because this file exists on the target at module runtime, the module's `defaults` block is only applied when `overwrite` is set to `true`. The `grubcfg.conf` at `live-overlay/etc/calamares/modules/grubcfg.conf` therefore sets `overwrite: true` to ensure `GRUB_THEME`, `GRUB_TERMINAL_OUTPUT`, and `GRUB_DISTRIBUTOR` are written.

`GRUB_TERMINAL_OUTPUT` must be `"gfxterm"` for the GRUB theme to render; `"console"` disables graphical output and prevents theme loading.

## Bootloader target detection

The `bootloader` module auto-detects the GRUB target architecture using the system's EFI bitness and CPU type. For UEFI x86_64, it installs with `--target=x86_64-efi`. For Legacy BIOS boots, it falls back to `--target=i386-pc`. There is no configuration key to override this — a system booted in BIOS mode will always receive an i386-pc bootloader.

## Installation flow

The full Calamares sequence is defined in `live-overlay/etc/calamares-online/settings.conf`:

**Show phase:**
1. `welcome` — branding and language
2. `locale` — timezone, locale
3. `keyboard` — keyboard layout
4. `packagechooser@de` — desktop environment selection
5. `packagechooser@dm` — display manager selection
6. `netinstall` — package refinement, optional groups
7. `partition` — disk partitioning
8. `users` — user account creation
9. `summary` — confirmation

**Exec phase:**
10. `partition` — write partitions
11. `mount` — mount target
12. `basestrap` — bootstrap base system
13. `machineid` — generate machine ID
14. `packages` — install all selected packages (DE, DM, optional groups)
15. `fstab` — generate fstab
16. `locale` — apply locale
17. `keyboard` — apply keyboard config
18. `localecfg` — locale configuration
19. `luksopenswaphookcfg` — LUKS config
20. `luksbootkeyfile` — LUKS boot key
21. `initcpiocfg` — mkinitcpio config
22. `initcpio` — generate initramfs
23. `users` — create user
24. `displaymanager` — configure SDDM/greetd/etc.
25. `networkcfg` — network configuration
26. `hwclock` — hardware clock
27. `services-artix` — enable dinit services
28. `grubcfg` — write GRUB defaults
29. `bootloader` — install GRUB
30. `postcfg` — post-install configuration
31. `umount` — unmount and finish

**Show phase:**
32. `finished` — reboot prompt

## Launcher

The `calamares-next` script (`/usr/bin/calamares-next`) handles the installer boot flow:

1. **Notice** — explains why the offline mode was removed
2. **Welcome** — branded splash with Install button
3. **Configuration** — copies `calamares-online/settings.conf` to `/etc/calamares/settings.conf`
4. **Launch** — runs `calamares` with the online config

During installation, the launcher monitors pacman activity and saves the package installation log to `~/pacman-install.log`. No terminal windows are opened to display progress.

Launched via the desktop entry in the live session: `Exec=sudo -E calamares-next`.
