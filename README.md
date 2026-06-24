# Antergos NeXT ISO

> **ℹ️ Antergos NeXT is migrating away from systemd to OpenRC (Artix-based).**
> See the [`before-systemd-change` branch](https://github.com/Antergos-NeXT/antergos-iso/tree/before-systemd-change) for the old systemd-based version and a full explanation of why this change was necessary.

[![Build ISO](https://github.com/Antergos-NeXT/antergos-iso/actions/workflows/build.yml/badge.svg)](https://github.com/Antergos-NeXT/antergos-iso/actions/workflows/build.yml)
[![License](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)
[![Maintenance](https://img.shields.io/maintenance/yes/2026.svg)]()
[![Arch Linux](https://img.shields.io/badge/arch%20linux-rolling-1793d1.svg)](https://archlinux.org)
[![GNOME](https://img.shields.io/badge/DE-GNOME-4A86CF.svg)]()
[![Multi-DE](https://img.shields.io/badge/DE-Cinnamon%20%7C%20XFCE%20%7C%20GNOME%20%7C%20Budgie%20%7C%20Deepin%20%7C%20LXQT%20%7C%20Openbox%20%7C%20i3-ff69b4.svg)]()

Both a revival **and** a modernization of the Antergos live installer ISO, based on the maintained EndeavourOS-ISO.

Provides a live GNOME environment to install Arch Linux using **Calamares** — the mature, upstream-supported universal installer framework — with offline (GNOME squashfs) and online (netinstall with 8 DE choices) modes, and dracut initramfs.

> *"I can't let you do that, Dave."* — Cnchi, 2012–2026

## Why Calamares and not Cnchi?

Cnchi was the original Antergos installer — a custom GTK+ tool that gave Antergos its identity. For Antergos NeXT, we initially ported it to GTK4 and fought to keep it alive. But after days of fighting with a brittle Python codebase, broken GTK4 bindings, and an ever-growing maintenance burden, the honest call was made:

**Cnchi is not coming back.**

| Reason | Detail |
|--------|--------|
| **GTK4 breakage** | Python GTK4 bindings were unstable; widgets broke on every upstream release |
| **Maintenance hell** | Single developer couldn't keep up with Python dependency churn + GTK4 + systemd + dracut |
| **Calamares is better** | Mature, modular C++/Qt6 framework, upstream-supported, offline+online already built in |
| **Time** | Every hour fixing Cnchi was an hour not spent on actual improvements |

### A brief eulogy

Cnchi (originally written as a Bash script, then Python/GTK2, then GTK3) served Antergos from 2012 to 2019, and was briefly revived for NeXT. It was ambitious, opinionated, and deeply tied to what made Antergos *Antergos*. But the 2026 Linux desktop is not 2012 — dracut replaces mkinitcpio, systemd-boot replaces grub, and a single-dev team can't carry a full custom installer framework.

Calamares is the big boy installer now. It works. It's maintained. And with our custom branding, offline/online split, and dracut support, it's more capable than Cnchi ever was.

*Requiescat in pace, Cnchi. You did your job.*

## Installer modes

| Mode | Description |
|------|-------------|
| **Offline** | Unpacks a GNOME squashfs from the ISO — no internet needed, fast install |
| **Online** | Netinstall with 8 DE choices (GNOME, KDE, Xfce, Budgie, Cinnamon, MATE, LXQt, i3/Sway) |

The launcher (`calamares-next`) presents a zenity/kdialog/dialog GUI to pick offline or online mode before launching Calamares.

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

Join us on Matrix: (uses pulsar's matrix) [#pulsar-linux:matrix.org](https://matrix.to/#/#pulsar-linux:matrix.org)

## Download

ISO images exceed GitHub's 2 GB release limit. They are uploaded to **SourceForge** (waiting for project)

**⚠️ Early releases may have incomplete DE package lists.**

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

The ISO uses the `antergos-packages` repo for custom packages (Calamares branding, keyring, mirrorlist, desktop settings, wallpapers). Add it to your system:

```ini
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://antergos-next.github.io/antergos-packages/$repo/os/$arch
Server = https://antergos-next.github.io/antergos-packages
```

## Sources

- [EndeavourOS-ISO](https://github.com/endeavouros-team/EndeavourOS-ISO) — base ISO build system
- [Arch-ISO](https://gitlab.archlinux.org/archlinux/archiso) — archiso tools
- [Calamares](https://codeberg.org/calamares/calamares) — upstream installer framework
- [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) — custom package repo
- [Antergos wallpapers](https://github.com/Antergos/wallpapers) — original wallpapers

## License

[GPL-3.0](LICENSE)

---

## A Note to the "Branding Police"

If you came here to hate and you're about to type "why are you using Antergos's branding" — pack your bags and go to **Manjaro**. We have Dustin's blessing. We are respectful. We are not them. Move on.

---

*Antergos launched in 2012 as **Cinnarch** (Cinnamon + Arch), renamed in 2013, and ran until 2019. NeXT *modernizes* it GNOME first, with the original installer experience and all the desktop choices you remember.*

*Dustin Falgout, one of the original Antergos developers, has given his blessing for this community revival ([see NOTICES](NOTICES)). Antergos NeXT is not affiliated with, endorsed by, or connected to the original Antergos project.*
