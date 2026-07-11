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

A community revival of Antergos — built on **Artix Linux** with **Dinit**, **KDE Plasma** desktop, and the **Calamares** installer (offline + online modes).

## What changed

| Before | After |
|--------|-------|
| Arch Linux (systemd) | Artix Linux (Dinit / OpenRC / Runit / S6) |
| GNOME desktop | KDE Plasma desktop |
| archiso build system | artools (`buildiso`) |
| Custom Cnchi installer | Calamares (mature, upstream-supported) |
| Symlinked overlays | Resolved, self-contained profile overlays |

## Why Artix?

The systemd migration in the Linux ecosystem has been controversial, and the original Antergos community had a strong preference for alternatives. Artix Linux provides a clean Arch-like experience without systemd, with your choice of Dinit, OpenRC, Runit, or S6. This keeps the familiar Pacman/Arch ecosystem while giving users the init freedom they want.

> **Why Dinit?** We originally shipped OpenRC. Then Calamares kidnapped our pacman resolver and forced us to switch. Every `--noconfirm` call picked `elogind-dinit` (alphabetically before `elogind-openrc`), pulling in `dinit-rc` which conflicts with `openrc`. We tried `--ignore`, `--assume-installed`, `--ask=12`, and even a dummy package. Pacman laughed at all of them. Dinit works great. Stop asking.
>
> Proof (our descent into madness):
> ```
> fe4e862 fix: use --ignore instead of separate provider call   ← --ignore: pacman ignored it
> 69da290 fix: add --ask=12 safety net                           ← --ask=12: infinite loop
> 64b08a9 fix: replace with --assume-installed=init-logind       ← assume-installed: not checked for virtuals
> 2c0d242 fix: add --ignore to packages module too               ← same failure, other file
> 8a6fa3f docs: update AGENTS.md with --ignore approach          ← documented the failure
> ```
> The conflict was `dinit-rc` vs `openrc` both providing+conflicting with virtual `init-rc`. Pacman `--noconfirm` picks `elogind-dinit` first alphabetically → `dinit` → `dinit-rc` → conflict. No flag in pacman can pin a virtual provider on a fresh install. Dinit wins by alphabetical destiny.

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
sudo ./buildiso -p antergos
```

> **⚠️ VERY IMPORTANT**: Use `./buildiso`, not `buildiso`. The Artix system `buildiso` at `/usr/bin/buildiso` lacks the `--overwrite='*'` flag passed to `basestrap`, causing file conflicts (e.g. `calamares` vs `calamares-branding-antergos-next` both claiming `/usr/share/calamares/branding/default/`). Our repo's `./buildiso` has it.

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
| **Online** | Netinstall with init system choice (Dinit, OpenRC, Runit, S6) + desktop selection |

The launcher (`calamares-next`) presents a mode picker before launching Calamares.

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

## A Note to the "Branding Police"

If you came here to hate and you're about to type "why are you using Antergos's branding" — pack your bags and go to **Manjaro**. We have Dustin's blessing. We are respectful. We are not them. Move on.

---

*Antergos launched in 2012 as **Cinnarch** (Cinnamon + Arch), renamed in 2013, and ran until 2019. NeXT continues the spirit with a modernized, Artix-based foundation — KDE Plasma, Calamares, and the same multi-desktop ambition you remember.*

*Dustin Falgout, one of the original Antergos developers, has given his blessing for this community revival ([see NOTICES](NOTICES)). Antergos NeXT is not affiliated with, endorsed by, or connected to the original Antergos project.*
