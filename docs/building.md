---
title: Building
layout: default
nav_order: 2
---

# Building the ISO

The ISO is built with `buildiso` (from Artix `artools` package) plus a customized profile. You need an **Artix-based** system to build.

## Prerequisites

```bash
pacman -S artools squashfs-tools
modprobe loop
```

`squashfs-tools` is needed for `mksquashfs`. The `loop` module must be loaded for `mount -o loop` during image assembly.

## Clone and configure

```bash
git clone https://github.com/Antergos-NeXT/antergos-iso.git
cd antergos-iso

export WORKSPACE_DIR="$PWD"

# Override pacman config with our repo (antergos-pkgs)
mkdir -p ~/.config/artools/pacman.conf.d
cp pacman.conf.d/iso-x86_64.conf ~/.config/artools/pacman.conf.d/
```

Without this override, `buildiso` uses `/usr/share/artools/pacman.conf.d/iso-x86_64.conf` (from the artools package), which lacks the `[antergos-pkgs]` repository. The build will then try to fetch our custom packages (branding, Calamares config, wallpapers) from Artix repos and fail.

## Build

```bash
sudo -E ./buildiso -p antergos
```

- **Use `./buildiso`**, not `buildiso`. The system `/usr/bin/buildiso` lacks `--overwrite='*'`, which causes file conflicts between `calamares` and `calamares-branding-antergos-next` (both claim `/usr/share/calamares/branding/default/`). Our repo's `./buildiso` has it.
- **`sudo -E`** is required. Without `-E`, `WORKSPACE_DIR` is stripped and `load_profile()` returns empty `HAS_LIVE`/`LIVEUSER`, causing the build to fail early.

## Output

The ISO appears in `/var/lib/artools/buildiso/iso/antergos/`:

```
/var/lib/artools/buildiso/iso/antergos/
├── antergos-<date>.iso       # Bootable ISO
└── antergos-<date>.sha1sum   # Checksum
```

First build pulls ~5 GB from the internet (package downloads). Subsequent builds use pacman cache.

## Environment variables

| Variable | Purpose |
|----------|---------|
| `WORKSPACE_DIR` | Must point to repo root. `buildiso` looks for profiles under `$WORKSPACE_DIR/iso-profiles/` |
| `COMPRESSION` | Squashfs compression type (e.g. `zstd`, `gzip`, `xz`). If unset, `mksquashfs` produces a zero-size sparse file instead of a valid squashfs |

## Troubleshooting

### "File conflict" errors during build

This means `--overwrite='*'` is not being passed to `basestrap`. Make sure you're using the repo's `./buildiso`, not the system one:

```bash
# Wrong — system buildiso without --overwrite:
buildiso -p antergos

# Correct:
./buildiso -p antergos
```

### Build fails with "HAS_LIVE is empty"

Forgetting `sudo -E`:

```bash
# Wrong — WORKSPACE_DIR not preserved:
sudo ./buildiso -p antergos

# Correct:
sudo -E ./buildiso -p antergos
```

### buildiso can't find our custom repo

The pacman config override is missing:

```bash
mkdir -p ~/.config/artools/pacman.conf.d
cp pacman.conf.d/iso-x86_64.conf ~/.config/artools/pacman.conf.d/
```

### Zero-size squashfs (ISO exists but is tiny)

`$COMPRESSION` is unset. Either set it in `profile.yaml` or pass it via environment:

```bash
export COMPRESSION=zstd
sudo -E ./buildiso -p antergos
```

Remove the stale image before retrying:

```bash
rm -rf /var/lib/artools/buildiso/iso/antergos/
```

### Corrupted pacman cache

If `basestrap` fails with checksum errors, clear the cache:

```bash
rm -rf /var/lib/artools/buildiso/pkg/antergos/cache/
```

Then rebuild.

## CI builds

The CI pipeline (`.github/workflows/build.yml`) handles all of the above automatically. It runs in an Artix container, sets `WORKSPACE_DIR`, overrides pacman config, mounts a 12 GB tmpfs, and uploads the resulting ISO to the Internet Archive.

Trigger CI manually from the GitHub Actions tab (push trigger is disabled).

## Local pacman repo

To use the custom packages repo on an installed system:

```ini
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://antergos-next.github.io/antergos-packages
```
