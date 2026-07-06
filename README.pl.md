# Antergos NeXT ISO

> **✅ Migracja zakończona!** Antergos NeXT oficjalnie przeniósł się z systemd/Arch na Artix Linux z Dinit. Budowanie jest stabilne, instalator działa.

Odrodzenie społeczności Antergos — zbudowane na **Artix Linux** z **Dinit**, **KDE Plasma** i instalatorem **Calamares** (tryb offline + online).

## Co się zmieniło

| Przed | Po |
|-------|-----|
| Arch Linux (systemd) | Artix Linux (Dinit / OpenRC / Runit / S6) |
| GNOME | KDE Plasma |
| archiso | artools (`buildiso`) |
| Cnchi | Calamares |

## Dlaczego Artix + OpenRC?

Systemd wyrósł na monolit — przejął logind, resolved, timedated, homed, journald, networkd i zaczął wprowadzać pola daty urodzenia do systemu. GNOME 49+ wyrzuciło obsługę init innych niż systemd. Artix Linux usunął GNOME w 2025 z tego powodu.

Antergos NeXT opuścił systemd zanim ten mógł zacząć inwigilować użytkowników.

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

## Tryby instalatora

| Tryb | Opis |
|------|------|
| **Offline** | Rozpakowuje squashfs z KDE Plasma — bez internetu |
| **Online** | Wybór init (Dinit, OpenRC, Runit, S6) + wybór środowiska (Plasma, Xfce, Cinnamon, MATE, LXQt, i3, Sway, Hyprland) |

## Pobieranie

Wkrótce — budujemy stabilne ISO.

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
