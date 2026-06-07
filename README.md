# Antergos NeXT ISO

[![Maintenance](https://img.shields.io/maintenance/yes/2026.svg)]()

Modern revival of the Antergos live installer ISO, based on the maintained EndeavourOS-ISO.

Provides a live KDE Plasma environment to install Arch Linux using **Cnchi**, the original Antergos installer.

## Download

ISO images are available on [SourceForge](https://sourceforge.net/projects/antergos-next).

## How to build

You need an Arch-based system with `archiso` available.

```
sudo pacman -S archiso git squashfs-tools --needed
```

```
git clone https://github.com/Antergos-NeXT/Antergos-NeXT-ISO.git
cd Antergos-NeXT-ISO
./prepare.sh
sudo ./mkarchiso -v "."
```

The `.iso` appears in the `out/` directory.

## Sources

- [EndeavourOS-ISO](https://github.com/endeavouros-team/EndeavourOS-ISO) (base)
- [Arch-ISO](https://gitlab.archlinux.org/archlinux/archiso)
- [Cnchi](https://github.com/Antergos/Cnchi)
- [Antergos wallpapers](https://github.com/Antergos/wallpapers)

## License

[GPL-2.0](COPYING)
