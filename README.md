# Antergos NeXT ISO

> **✅ Migration complete!** Antergos NeXT has officially migrated from systemd/Arch to OpenRC/Artix. The builds are stable, the installer works, and we can say officially that the migration was a success!
>
> See the [`before-systemd-change` branch](https://github.com/Antergos-NeXT/antergos-iso/tree/before-systemd-change) for the old systemd-based version and the reasoning behind the change.

[![Build ISO](https://github.com/Antergos-NeXT/antergos-iso/actions/workflows/build.yml/badge.svg)](https://github.com/Antergos-NeXT/antergos-iso/actions/workflows/build.yml)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)
[![Maintenance](https://img.shields.io/maintenance/yes/2026.svg)]()
[![Artix Linux](https://img.shields.io/badge/Artix%20Linux-rolling-1793d1.svg)](https://artixlinux.org)
[![DE-KDE](https://img.shields.io/badge/DE-KDE%20Plasma-4A86CF.svg)]()
[![Init](https://img.shields.io/badge/init-OpenRC-brightgreen.svg)]()

A community revival of Antergos — now built on **Artix Linux** with **OpenRC**, **KDE Plasma** desktop, and the **Calamares** installer (offline + online modes).

> *"We can say officially that the migration was a success!"*

## What changed

| Before | After |
|--------|-------|
| Arch Linux (systemd) | Artix Linux (OpenRC) |
| GNOME desktop | KDE Plasma desktop |
| archiso build system | artools (`buildiso`) |
| Custom Cnchi installer | Calamares (mature, upstream-supported) |
| Symlinked overlays | Resolved, self-contained profile overlays |

## Why Artix + OpenRC?

The systemd migration in the Linux ecosystem has been controversial, and the original Antergos community had a strong preference for alternatives. Artix Linux provides a clean Arch-like experience without systemd, using OpenRC as the default init system. This keeps the familiar Pacman/Arch ecosystem while giving users the init freedom they want.

## Building

Requires an **Artix-based** system:

```bash
# Install build deps
pacman -S artools squashfs-tools
modprobe loop

# Clone and enter
git clone https://github.com/Antergos-NeXT/antergos-iso.git
cd antergos-iso

# Set workspace to repo root
export WORKSPACE_DIR="$PWD"

# Must use our pacman.conf (has antergos-pkgs repo)
mkdir -p ~/.config/artools/pacman.conf.d
cp pacman.conf.d/iso-x86_64.conf ~/.config/artools/pacman.conf.d/

# Build
sudo buildiso -p antergos
```

The `.iso` appears in `/var/lib/artools/buildiso/iso/antergos/`.

First build pulls ~5 GB from the internet. Subsequent builds use pacman cache.

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

## Installer modes

| Mode | Description |
|------|-------------|
| **Offline** | Unpacks a KDE Plasma squashfs — no internet needed |
| **Online** | Netinstall with init system choice (OpenRC, Dinit, Runit, S6) + desktop selection |

The launcher (`calamares-next`) presents a mode picker before launching Calamares.

## Download

No prebuilt ISOs yet. See [Building](#building) above.

## Sources

- [Artix Linux](https://artixlinux.org) — base distribution
- [artools](https://gitea.artixlinux.org/artix/artools) — ISO build tools
- [Calamares](https://codeberg.org/calamares/calamares) — installer framework
- [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) — custom PKGBUILDs
- [Antergos wallpapers](https://github.com/Antergos/wallpapers) — original wallpapers

## License

[GPL-3.0](LICENSE)

---

## A Note to the "Branding Police"

If you came here to hate and you're about to type "why are you using Antergos's branding" — pack your bags and go to **Manjaro**. We have Dustin's blessing. We are respectful. We are not them. Move on.

---

*Antergos launched in 2012 as **Cinnarch** (Cinnamon + Arch), renamed in 2013, and ran until 2019. NeXT continues the spirit with a modernized, Artix-based foundation — KDE Plasma, Calamares, and the same multi-desktop ambition you remember.*

*Dustin Falgout, one of the original Antergos developers, has given his blessing for this community revival ([see NOTICES](NOTICES)). Antergos NeXT is not affiliated with, endorsed by, or connected to the original Antergos project.*
