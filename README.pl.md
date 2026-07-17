# Antergos NeXT ISO

> Szukasz starej wersji Arch/systemd? Zobacz gałąź [`before-systemd-change`](https://github.com/Antergos-NeXT/antergos-iso/tree/before-systemd-change).

Odrodzenie społeczności Antergos — zbudowane na **Artix Linux** z **Dinit**, **KDE Plasma** i instalatorem **Calamares** (tryb online) + skrypt BYODE do instalacji offline.

## Co się zmieniło

| Przed | Po |
|-------|-----|
| Arch Linux (systemd) | Artix Linux (Dinit) |
| GNOME | KDE Plasma |
| archiso | artools (`buildiso`) |
| Cnchi | Calamares |

## Dlaczego Artix?

Systemd przestał być "tylko initem" gdy zaczął zbierać daty urodzenia. Zostaliśmy przy Artix i Dinit. Chcesz coś innego? Jest `changing-init.md`.

## Budowanie

Wymaga systemu **Artix**:

```bash
pacman -S artools squashfs-tools
modprobe loop

export WORKSPACE_DIR="$PWD"
mkdir -p ~/.config/artools/pacman.conf.d
cp pacman.conf.d/iso-x86_64.conf ~/.config/artools/pacman.conf.d/

sudo -E ./buildiso -p antergos
```

> **⚠️ Używaj `./buildiso`, nie `buildiso`.** Systemowy `/usr/bin/buildiso` nie ma flagi `--overwrite='*'`.

ISO pojawi się w `/var/lib/artools/buildiso/iso/antergos/`.

## Instalator

| Tryb | Opis |
|------|------|
| **Online** | Calamares z wyborem środowiska (Plasma, Xfce, Cinnamon, MATE, LXQt, i3, Sway, Hyprland) |
| **BYODE** | Goły system + btrfs + snapper — sam `pacman -Sy` swoje DE. Skrypt na pulpicie. |

## Pobieranie

[GitHub Releases](https://github.com/Antergos-NeXT/antergos-iso/releases)

## Źródła

- [Artix Linux](https://artixlinux.org)
- [Calamares](https://codeberg.org/calamares/calamares)
- [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages)
- [Oryginalne tapety Antergos](https://github.com/Antergos/wallpapers)

## Licencja

[GPL-3.0](LICENSE)

---

*Antergos wystartował w 2012 jako **Cinnarch**, przemianowany w 2013, działał do 2019. NeXT kontynuuje ducha oryginału na nowoczesnym, Artixowym fundamencie — KDE Plasma, Calamares, ta sama wielośrodowiskowa ambicja.*

*Dustin Falgout, jeden z oryginalnych twórców Antergos, pobłogosławił to odrodzenie ([NOTICES](NOTICES)). Antergos NeXT nie jest powiązane z oryginalnym projektem Antergos.*
