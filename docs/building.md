---
title: Building
layout: default
nav_order: 2
---

# Building the ISO

The ISO is built with `buildiso` (from Artix `artools` package) plus a customized profile. There are two supported paths: **Option A (container)** for systems without pacman, and **Option B (native)** for pacman-based systems.

## Option A: Build in a container (non-pacman distros — recommended)

No Artix/Arch needed. Works on Gentoo, Fedora, Debian — anything **without pacman** that has podman. This is the same path GitHub Actions CI uses.

```bash
# Build the image (installs artools + deps inside an Artix container)
podman build -t antergos-build .

# Build the ISO (rootful podman required — artools chroots mount devtmpfs,
# which rootless containers cannot do)
sudo podman run --rm --privileged \
  -v /var/lib/artools-buildiso:/var/lib/artools/buildiso \
  -v "$(pwd)/iso-output:/workspace/iso-output" \
  -e WORKSPACE_DIR=/workspace \
  antergos-build
```

Or use the helper script:

```bash
./build-iso-podman.sh
```

The finished `.iso` lands in `iso-output/`.

## Option B: Native build (just pacman + artools)

You do **not** need an Artix-based system — `buildiso` is plain bash on top of `pacman`. You need:

- `pacman` (native on Arch/Artix/**KaOS**; on other distros, install it or extract the `.pkg.tar.zst` files)
- the artools libraries from the Artix repo: `artools-base` (provides `basestrap`, `artix-chroot`, `fstabgen`) and `artools-iso` (provides `buildiso`) plus their deps
- `squashfs-tools`, `grub`, `xorriso`/`libisoburn`, `dosfstools`, `mtools`

## Prerequisites (native path)

```bash
# On Arch/Artix:
pacman -S artools squashfs-tools
modprobe loop

# On KaOS (pacman native, but artools not in KaOS repos — extract from Artix):
pacman -S squashfs-tools

# On other distros: grab artools-base/artools-iso from the Artix repo and
# extract them over /, then install pacman and the deps listed above.
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

## Which option do I use?

> - **Arch / Artix / KaOS / any pacman-based distro** → Option B (native).
> - **Anything else** (Gentoo, Fedora, Debian, ...) → Option A (podman).

## CI builds

The CI pipeline (`.github/workflows/build.yml`) handles all of the above automatically. It runs in an Artix container, sets `WORKSPACE_DIR`, overrides pacman config, mounts a 12 GB tmpfs, and builds the ISO. It also runs the AI community moderator on issues/PRs (`.github/workflows/ai-moderator.yml`).

An Internet Archive upload step exists in the workflow but is **currently disabled** (`if: false`) — builds are manually verified first. When enabled it uploads with identifier `antergos-next-YYYYMMDD-<run_number>`.

Trigger CI manually from the GitHub Actions tab (push trigger is disabled).

## Local pacman repo

To use the custom packages repo on an installed system:

```ini
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://antergos-next.github.io/antergos-packages
```
