# Antergos NeXT ISO

[![Build ISO](https://github.com/Antergos-NeXT/antergos-iso/actions/workflows/build.yml/badge.svg)](https://github.com/Antergos-NeXT/antergos-iso/actions/workflows/build.yml)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)
[![Maintenance](https://img.shields.io/maintenance/yes/2026.svg)]()
[![Arch Linux](https://img.shields.io/badge/arch%20linux-rolling-1793d1.svg)](https://archlinux.org)
[![GNOME](https://img.shields.io/badge/DE-GNOME-4A86CF.svg)]()
[![Multi-DE](https://img.shields.io/badge/DE-Cinnamon%20%7C%20XFCE%20%7C%20GNOME%20%7C%20Budgie%20%7C%20Deepin%20%7C%20LXQT%20%7C%20Openbox%20%7C%20i3-ff69b4.svg)]()

Modern revival of the Antergos live installer ISO, based on the maintained EndeavourOS-ISO.

Provides a live GNOME environment to install Arch Linux using **Cnchi**, the original Antergos installer — now patched for modern Python, with multi-DE support and the original installer experience.

## Desktop Editions

| Desktop | Edition | Status |
|---------|---------|--------|
| GNOME | antergos-gnome | default |
| KDE Plasma | antergos-kde | available |
| XFCE | antergos-xfce | available |
| Cinnamon | antergos-cinnamon | available |
| Budgie | antergos-budgie | available |
| Deepin | antergos-deepin | available |
| LXQt | antergos-lxqt | available |
| Openbox | antergos-openbox | available |
| i3 | antergos-i3 | available |
| MATE | antergos-mate | available |

## Community

Join us on Matrix: [#antergos-next:matrix.org](https://matrix.to/#/%23antergos-next:matrix.org)

## Download

ISO images exceed GitHub's 2 GB release limit. They are uploaded to **SourceForge**
[![Download antergos-next](https://a.fsdn.com/con/app/sf-download-button)](https://sourceforge.net/projects/pulsar-linux/files/Antergos_NeXT/latest/download)

**⚠️ Early releases may have incomplete DE package lists.** The latest `packages.xml` is always in the [cnchi-next repo](https://github.com/Antergos-NeXT/cnchi-next/blob/cnchi-dev/data/packages.xml). Building from source after a fresh clone ensures you have the most up-to-date package selection.

## How to build

You need an Arch-based system with `archiso` available.

```bash
sudo pacman -S archiso git squashfs-tools --needed
git clone https://github.com/Antergos-NeXT/antergos-iso.git
cd Antergos-NeXT-ISO
./prepare.sh
sudo ./mkarchiso -v "."
```

The `.iso` appears in the `out/` directory.

## Custom packages

The ISO uses the `antergos-packages` repo for custom packages (Cnchi, keyring, mirrorlist, desktop settings, wallpapers). Add it to your system:

```ini
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://Antergos-NeXT.github.io/antergos-packages/$repo/os/$arch
Server = https://Antergos-NeXT.github.io/antergos-packages
```

## Sources

- [EndeavourOS-ISO](https://github.com/endeavouros-team/EndeavourOS-ISO) — base ISO build system
- [Arch-ISO](https://gitlab.archlinux.org/archlinux/archiso) — archiso tools
- [cnchi-next](https://github.com/Antergos-NeXT/cnchi-next) — our patched Cnchi fork
- [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) — custom package repo
- [Antergos wallpapers](https://github.com/Antergos/wallpapers) — original wallpapers

## License

[GPL-3.0](LICENSE)

---

*Antergos launched in 2012 as **Cinnarch** (Cinnamon + Arch), renamed in 2013, and ran until 2019. NeXT revives it GNOME first, with the original installer experience and all the desktop choices you remember.*

*Dustin Falgout, one of the original Antergos developers, has given his blessing for this community revival ([see NOTICES](NOTICES)). Antergos NeXT is not affiliated with, endorsed by, or connected to the original Antergos project.*
