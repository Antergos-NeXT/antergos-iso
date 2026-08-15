# Antergos NeXT ISO

> Looking for the old Arch/systemd version? See the [`before-systemd-change` branch](https://github.com/Antergos-NeXT/antergos-iso/tree/before-systemd-change).

[![Build ISO](https://github.com/Antergos-NeXT/antergos-iso/actions/workflows/build.yml/badge.svg)](https://github.com/Antergos-NeXT/antergos-iso/actions/workflows/build.yml)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)
[![Maintenance](https://img.shields.io/maintenance/yes/2026.svg)]()
[![Artix Linux](https://img.shields.io/badge/Artix%20Linux-rolling-1793d1.svg)](https://artixlinux.org)
[![DE-KDE](https://img.shields.io/badge/DE-KDE%20Plasma-4A86CF.svg)]()
[![Init](https://img.shields.io/badge/init-Dinit-brightgreen.svg)]()
[![Docs](https://img.shields.io/badge/docs-site-blue.svg)](https://antergos-next.github.io/antergos-iso/)
[![Dla mojego narodu](https://img.shields.io/badge/README-Polski-crimson.svg)](README.pl.md)

A community revival of Antergos — built on **Artix Linux** with **Dinit**, **KDE Plasma** desktop, the **Calamares** installer (online mode), and a BYODE script for offline installs.

## What changed

| Before | After |
|--------|-------|
| Arch Linux (systemd) | Artix Linux (Dinit) |
| GNOME desktop | KDE Plasma desktop |
| archiso build system | artools (`buildiso`) |
| Custom Cnchi installer | Calamares (mature, upstream-supported) |
| Symlinked overlays | Resolved, self-contained profile overlays |

## Why Artix?

The Antergos NeXT project prefers init system flexibility over systemd lock-in. Artix Linux provides a clean Arch-like experience with your choice of **Dinit** (default), Runit, or S6 — see `changing-init.md` if you want something else.

> **Why Dinit?** We shipped OpenRC. Then Calamares kidnapped pacman's resolver and every `--noconfirm` call picked `elogind-dinit` (alphabetically before `elogind-openrc`). Dinit works great and OpenRC's service enabling was broken on installed systems anyway. Dinit wins by alphabetical destiny.

## Building

### Option A: Build in a container (non-pacman distros — recommended)

No Artix/Arch needed. Works on Gentoo, Fedora, Debian — anything **without
pacman** that has podman. This is the same path GitHub Actions CI uses.

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

### Option B: Native build (just pacman + artools)

You do **not** need an Artix-based system — `buildiso` is plain bash on top of
`pacman`. You need:

- `pacman` (native on Arch/Artix/**KaOS**; on other distros, install it or
  extract the `.pkg.tar.zst` files)
- the artools libraries from the Artix repo: `artools-base` (provides
  `basestrap`, `artix-chroot`, `fstabgen`) and `artools-iso` (provides
  `buildiso`) plus their deps
- `squashfs-tools`, `grub`, `xorriso`/`libisoburn`, `dosfstools`, `mtools`

```bash
# On Arch/Artix:
pacman -S artools squashfs-tools
modprobe loop

# On KaOS (pacman native, but artools not in KaOS repos — extract from Artix):
pacman -S squashfs-tools
# grab artools-base/artools-iso from the Artix repo and extract over /

# On other distros: grab the packages from the Artix repo and extract
# them over / (e.g. into /usr/share/artools and /usr/bin), then install
# pacman and the deps listed above.

# Clone and enter
git clone https://github.com/Antergos-NeXT/antergos-iso.git
cd antergos-iso

# Set workspace to repo root
export WORKSPACE_DIR="$PWD"

# Must use our pacman.conf (has antergos-pkgs repo)
mkdir -p ~/.config/artools/pacman.conf.d
cp pacman.conf.d/iso-x86_64.conf ~/.config/artools/pacman.conf.d/

# Build
sudo ./buildiso -p antergos
```

> **⚠️ VERY IMPORTANT**: Use `./buildiso`, not `buildiso`. The Artix system `buildiso` at `/usr/bin/buildiso` lacks the `--overwrite='*'` flag passed to `basestrap`, causing file conflicts (e.g. `calamares` vs `calamares-branding-antergos-next` both claiming `/usr/share/calamares/branding/default/`). Our repo's `./buildiso` has it.

The `.iso` appears in `/var/lib/artools/buildiso/iso/antergos/`.

First build pulls ~5 GB from the internet. Subsequent builds use pacman cache.

> **Which option do I use?**
>
> - **Arch / Artix / KaOS / any pacman-based distro** → Option B (native).
> - **Anything else** (Gentoo, Fedora, Debian, ...) → Option A (podman).

### Custom packages

The ISO pulls custom packages (branding, Calamares config, wallpapers) from our repo. Add it to your system:

```ini
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://antergos-next.github.io/antergos-packages
```

## Profile structure

```
iso-profiles/
├── antergos/
│   ├── profile.yaml          # Packages, services, build config
│   ├── root-overlay/         # Files merged into rootfs (os-release, pacman.conf, sddm)
│   └── live-overlay/         # Files for the live environment (Calamares configs, etc.)
├── common/
│   └── common.yaml           # Shared base packages
├── pacman.conf.d/
│   └── iso-x86_64.conf       # Pacman config used during ISO build
└── buildiso                  # Modified buildiso with Antergos branding
```

Overlays are self-contained (no symlinks to external directories) so the repo builds standalone.

## Installer

| Mode | Description |
|------|-------------|
| **Online** | Full Calamares netinstall with desktop selection (KDE Plasma, Xfce, Cinnamon, MATE, LXQt, i3, Sway, Hyprland) |
| **BYODE** | Bare system + btrfs + snapper — you `pacman -Sy` your own DE. Script available on the live desktop. |

## Download

[GitHub Releases](https://github.com/Antergos-NeXT/antergos-iso/releases)

## Sources

- [Artix Linux](https://artixlinux.org) — base distribution
- [artools](https://gitea.artixlinux.org/artix/artools) — ISO build tools
- [Calamares](https://codeberg.org/calamares/calamares) — installer framework
- [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) — custom PKGBUILDs
- [Antergos wallpapers](https://github.com/Antergos/wallpapers) — original wallpapers

## License

[GPL-3.0](LICENSE)

---

*Antergos launched in 2012 as **Cinnarch** (Cinnamon + Arch), renamed in 2013, and ran until 2019. NeXT continues the spirit with a modernized, Artix-based foundation — KDE Plasma, Calamares, and the same multi-desktop ambition you remember.*

*Dustin Falgout, one of the original Antergos developers, has given his blessing for this community revival ([see NOTICES](NOTICES)). Antergos NeXT is not affiliated with, endorsed by, or connected to the original Antergos project.*
