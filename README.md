# 🌙 Antergos NeXT

> *February → July 2026*
>
> *MoonlightOS walked so Solara could run. Solara ran so Antergos NeXT could exist.*
> *And here we are.*

---

**Antergos NeXT** is not just a distribution — it's the final form of a journey that started with a 14-year-old's distro hobby and ended up covered by [9to5Linux](https://9to5linux.com), DistroWatch, Linuxiac, and more.

From a janky custom `mkarchiso` called MoonlightOS NoVa, through the EndeavourOS-based Solara, to a fully-fledged Artix Linux-based ISO with KDE Plasma, Calamares installer (online + offline), Dinit as default init (OpenRC/Runit/S6 still selectable), and proper CI that uploads to the Internet Archive.

**This is the one that worked.**

---

## The Timeline

| Era | Period | Base | Init | DE |
|-----|--------|------|------|----|
| 🌙 MoonlightOS NoVa | ~Feb 2025 | Arch | systemd | KDE |
| 🐱 MoonlightOS meow-v7 | ~2025 | EndeavourOS | systemd | KDE |
| ☀️ Solara | ~2025 | EndeavourOS | systemd | KDE |
| 🟢 Antergos NeXT (systemd) | ~2026 | Arch | systemd | GNOME |
| 🔄 Antergos NeXT (OpenRC) | ~2026 | Artix | OpenRC | KDE |
| ⚡ **Antergos NeXT (Dinit)** | **Now** | **Artix** | **Dinit** | **KDE** |

---

## What's Inside

- **KDE Plasma** live environment — polished, familiar, ready
- **Calamares** installer in two modes:
  - *Online* — init system selection, package chooser, DM picker
  - *Offline* — fully self-contained, no network needed
- **Artix Linux** base — rolling release, pacman, no systemd
- **Dinit** as default init — fast, clean, modern
- **Multi-init support** — OpenRC, Runit, S6 still selectable
- **antergos-pkgs** custom repo — curated packages, Calamares branding, themes

---

## Building

```bash
export WORKSPACE_DIR="$PWD"
sudo -E ./buildiso -p antergos
```

ISO lands at `/var/lib/artools/buildiso/iso/antergos/`.

---

## Why This Exists

Because rolling your own distro at 14 is funny. Because giving up is boring. And because after six iterations, countless broken packages, three init systems, two ISO builders, and one very patient maintainer — you eventually end up with something that actually works.

**MoonlightOS walked. Solara ran. Antergos NeXT flies.**

---

*25-01-2026 → 07-07-2026*
