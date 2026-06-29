---
title: Building
layout: default
nav_order: 2
---

# Building the ISO

Requires an **Artix-based** system with `artools` and `squashfs-tools`.

## Prerequisites

```bash
pacman -S artools squashfs-tools
modprobe loop
```

## Clone and configure

```bash
git clone https://github.com/Antergos-NeXT/antergos-iso.git
cd antergos-iso

export WORKSPACE_DIR="$PWD"

# Override pacman config with our repo (antergos-pkgs)
mkdir -p ~/.config/artools/pacman.conf.d
cp pacman.conf.d/iso-x86_64.conf ~/.config/artools/pacman.conf.d/
```

## Build

```bash
sudo -E ./buildiso -p antergos
```

> **⚠️ Use `./buildiso`, not `buildiso`.** The Artix system `/usr/bin/buildiso` lacks the `--overwrite='*'` flag, causing file conflicts between `calamares` and `calamares-branding-antergos-next` (both claim `/usr/share/calamares/branding/default/`). Our repo's `./buildiso` has it.

## Output

The ISO appears in `/var/lib/artools/buildiso/iso/antergos/`.

First build pulls ~5 GB from the internet. Subsequent builds use pacman cache. Go make a coffee. Or two. Maybe three.

## Environment variables

| Variable | Purpose |
|----------|---------|
| `WORKSPACE_DIR` | Must point to repo root. `buildiso` looks for profiles under `$WORKSPACE_DIR/iso-profiles/` |
| `COMPRESSION` | Squashfs compression type (e.g. `zstd`). If unset, `mksquashfs` fails silently with a zero-size image |

## Custom packages repo

The ISO pulls branding, Calamares config, and wallpapers from our custom repo. To use it on your system:

```ini
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://antergos-next.github.io/antergos-packages
```
