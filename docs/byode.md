---
title: Offline Installer (BYODE)
layout: default
nav_order: 14
---

# Offline Installer (BYODE)

The offline installer (`/usr/local/bin/antergos-offline-install`) is a bare-minimum installer for situations where the Calamares online installer can't work — no internet, or you want a minimal base to build on. It is **experimental** and best-effort; the Calamares online installer remains the primary path.

The script is adapted from Valve's SteamOS `repair_device.sh` (the Zenity prompt and pretty-output helpers are lifted straight from there).

## What it does

1. Verifies it's running as root in a live Antergos NeXT session (checks for `/run/artix/bootmnt/LiveOS/rootfs.img`)
2. Warns that it installs **no desktop environment** — just the base system
3. Lets you pick a target disk via `lsblk` + Zenity, then partitions it:
   - GPT table
   - 512 MiB EFI partition
   - 300 MiB swap
   - Root partition filling the rest
4. Formats: `vfat` (ESP), `swap`, `btrfs` root
5. Creates btrfs subvolumes: `@`, `@home`, `@cache`, `@log`, `@snapshots`
6. Extracts the live rootfs (squashfs) to the target
7. Generates an fstab with `subvol=` mounts and `compress=zstd`
8. Chroots in: runs `mkinitcpio -P`, installs GRUB as `Antergos`, sets hostname
9. Prompts for a root password and a daily user (added to `wheel` + sudoers)
10. Enables services via `artix-service`: NetworkManager, dbus, acpid, bluetoothd, cronie, cupsd, dhcpcd, power-profiles-daemon, syslog-ng, userspawn
11. Configures **snapper** for automatic snapshots (6 hourly + 7 daily + 4 weekly, via cron jobs)
12. Unmounts, syncs, and offers to reboot

## After first boot

Since no desktop environment was installed, connect to the internet and run:

```bash
sudo pacman -Sy plasma-meta
```

or install any other DE you want.

## Caveats

- **Destroys all data** on the selected disk — confirmed via Zenity twice.
- No Calamares integration (no partitioner UI, no locale/keyboard/user pages).
- Package lists are baked into the live squashfs; there is no post-install package installation step, so the system matches the ISO's rootfs as of build time.
- Bootloader is GRUB only — no systemd-boot, no rEFInd.
- Still needs internet on first boot for anything beyond the base.
