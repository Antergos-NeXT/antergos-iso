---
title: Development
layout: default
nav_order: 7
---

# Development

## Critical gotchas

### `./buildiso` vs `buildiso`

Always use the repo's `./buildiso`, **not** the system Artix `/usr/bin/buildiso`. The system version lacks `--overwrite='*'` and will fail with file conflicts between `calamares` and `calamares-branding-antergos-next`.

### `sudo -E` is required

Without `-E`, `WORKSPACE_DIR` is stripped and `load_profile()` returns empty `HAS_LIVE`/`LIVEUSER`, causing build failures.

### Pacman config must be user-overridden

`buildiso` reads from `~/.config/artools/pacman.conf.d/iso-x86_64.conf`. If missing, it falls back to the Artix default at `/usr/share/artools/pacman.conf.d/iso-x86_64.conf` which lacks `[antergos-pkgs]`.

```bash
mkdir -p ~/.config/artools/pacman.conf.d
cp pacman.conf.d/iso-x86_64.conf ~/.config/artools/pacman.conf.d/
```

### Squashfs compression

If `$COMPRESSION` is unset in config, `mksquashfs` produces a sparse zero file instead of a valid squashfs. Always verify compression is set, or remove stale images before retry.

### Calamares module precedence

`/etc/calamares/modules/` overrides `/usr/share/calamares/modules/`. Live-overlay online/offline directories override both.

### Live-overlay is not overlay-mounted

Live-overlay files are copied via `cp -LR` in `make_livefs()`. Deleting a file from live-overlay exposes the package version, not hides it. Use `NoDisplay=true` in `.desktop` files instead.

### `plasma-wayland-session` does not exist on Artix

Artix bundles the Wayland session into `plasma-workspace` itself. Do not add it to package lists.

### File conflicts

`calamares` and `calamares-branding-antergos-next` both install to `/usr/share/calamares/branding/default/`. Handled by `--overwrite='*'`.

### `calamares-next.sh SetConfig()`

Must `rm -f` the symlink at `/etc/calamares/settings.conf` before `cp`, otherwise `cp` follows the symlink and overwrites the offline config file instead of replacing it.

### Do not push commits while IA keys are set

Test ISOs manually first. IA credentials are set as repo secrets and will trigger an upload on push to master.

## Profile structure

```
iso-profiles/
├── antergos/
│   ├── profile.yaml          # Packages, services (rootfs + livefs)
│   ├── root-overlay/         # Merged into squashfs rootfs
│   └── live-overlay/         # Merged into live environment
└── common/
    └── common.yaml           # Shared base packages
```

## Building locally

```bash
export WORKSPACE_DIR="$PWD"
sudo -E ./buildiso -p antergos
```

### A Note to the "Branding Police"

If you came here to hate and you're about to type "why are you using Antergos's branding" — pack your bags and go to **Manjaro**. We have Dustin's blessing. We are respectful. We are not them. Move on.

## Testing

Boot the resulting ISO in a VM. Verify:
- Wayland is the default display server (SDDM session is `plasma.desktop`)
- No "Install Artix Linux" entry in the app menu
- Wallpaper is set on first login
- Online mode: init selector + DE selector both work
- Slideshow renders correctly
