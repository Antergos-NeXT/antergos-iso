---
title: Changing init
layout: default
nav_order: 10
---

# Changing init on an installed system

Antergos NeXT ships with **Dinit** as the default and only install-time init.
If you prefer a different init (OpenRC, Runit, or S6), you can switch after
installation.

> **Warning:** Switching init is for advanced users. In general, a fresh
> installation is safer. Keep a bootable Artix LiveUSB handy in case
> something goes wrong.
>
> OpenRC has known conflicts with Dinit on Antergos NeXT. If switching to
> OpenRC fails, the recommended course of action is to reinstall the ISO
> and use Dinit. A fresh install with Dinit is simpler and more reliable
> than troubleshooting a broken init migration. Tutorials on using Dinit
> are available on the Artix Linux wiki and in the Dinit documentation.



## Overview

1. Stop your display manager and get to a TTY
2. Save a list of installed `-dinit` service packages
3. Download the corresponding `-<newinit>` packages
4. Remove the dinit packages
5. Install the new init packages
6. Enable services for the new init
7. Cold reboot

## Step-by-step

### 1. Stop the display manager

```bash
dinitctl stop sddm     # or lightdm / lxdm / greetd / ly
```

Switch to a text TTY with Ctrl+Alt+F2 and log in as root.

### 2. Save your service list

```bash
pacman -Qsq dinit > services.list
```

This captures every installed package with `-dinit` in its name.
The list will include things like `sddm-dinit`, `networkmanager-dinit`,
`elogind-dinit`, etc.

### 3. Download packages for the new init

Replace `openrc` with `runit`, `s6`, or your init of choice:

```bash
pacman -Sw $(sed 's/dinit/openrc/g' < services.list)
```

This fetches the packages into pacman's cache without installing them.
If this fails for any package, you'll need to install it manually later.

### 4. Remove the old init packages

```bash
pacman -Rdd $(cat services.list)
```

The `-dd` flag bypasses dependency checks — required because we're
ripping out the entire init layer at once.

### 5. Install the new init

First install the base init package and elogind:

| Target   | Base packages |
|----------|---------------|
| OpenRC   | `openrc`, `elogind-openrc` |
| Runit    | `runit`, `elogind-runit` |
| S6       | `s6-base`, `elogind-s6` |

```bash
pacman -S openrc elogind-openrc
```

Then install the service packages:

```bash
pacman -S $(sed 's/dinit/openrc/g' < services.list)
```

### 6. Enable services

#### Switching to OpenRC

```bash
rc-update add sddm default
rc-update add NetworkManager default
# ... repeat for each service
```

Common services: `acpid`, `bluetoothd`, `cronie`, `cupsd`, `dbus`,
`dhcpcd`, `NetworkManager`, `power-profiles-daemon`, `syslog-ng`.

#### Switching to Runit

```bash
ln -s /etc/runit/sv/NetworkManager /etc/runit/runsvdir/default/
ln -s /etc/runit/sv/sddm /etc/runit/runsvdir/default/
# ... repeat for each service
```

#### Switching to S6

```bash
s6-service add default NetworkManager
s6-service add default sddm
# ... repeat for each service
```

### 7. Cold reboot

A normal reboot won't work because the symlinks for `/sbin/init` and
`/sbin/reboot` still point to the old init. Instead, synchronize
disks and trigger a cold reboot:

```bash
sync
mount / -o remount,ro
echo b > /proc/sysrq-trigger
```

Or use the reset button on your machine.

## Troubleshooting

### System won't boot

Boot from an Artix LiveUSB, chroot in, and check:

```bash
mount /dev/sdXn /mnt
artix-chroot /mnt
```

From the chroot, you can reinstall packages, fix service symlinks,
or regenerate the initramfs with `mkinitcpio -p linux`.

### Missing service packages

Some daemons may not have init scripts for your chosen init.
Check the Artix repos:

```bash
pacman -Ss <daemon-name>-openrc   # or -runit, -s6
```

If a package doesn't exist, you can write a custom service file
or use a different daemon.

### OpenRC: services don't enable on installed systems

This was a known bug in earlier Antergos NeXT builds (the installer
used `artix-service` which didn't set up OpenRC correctly).
If you're switching to OpenRC manually on an already-installed system,
`rc-update add` works fine — the bug was specific to the installer flow.
