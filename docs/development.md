---
title: Development
layout: default
nav_order: 7
---

# Development

## Repository structure

```
antergos-iso/
├── buildiso                    # Modified buildiso with --overwrite='*' and branding
├── iso-profiles/
│   ├── antergos/
│   │   ├── profile.yaml        # Packages, services (rootfs + livefs), compression
│   │   ├── root-overlay/       # Merged into squashfs rootfs → installed system
│   │   └── live-overlay/       # Merged into live environment only
│   └── common/
│       └── common.yaml         # Shared base packages (kernel, firmware, filesystem)
├── pacman.conf.d/
│   └── iso-x86_64.conf         # Pacman config for ISO build with [antergos-pkgs]
└── .github/workflows/
    ├── build.yml               # ISO build + Internet Archive upload
    └── pages.yml               # Docs deployment to GitHub Pages
```

## Building locally

```bash
export WORKSPACE_DIR="$PWD"
sudo -E ./buildiso -p antergos
```

See [Building the ISO](building) for full setup instructions and troubleshooting.

## Critical gotchas

### `./buildiso` vs `buildiso`

Always use the repo's `./buildiso`, **not** the system Artix `/usr/bin/buildiso`. The system version lacks `--overwrite='*'` and will fail with file conflicts between `calamares` and `calamares-branding-antergos-next`.

### `sudo -E` is required

Without `-E`, `WORKSPACE_DIR` is stripped and `load_profile()` returns empty `HAS_LIVE`/`LIVEUSER`, causing build failures immediately.

### Pacman config must be user-overridden

`buildiso` reads from `~/.config/artools/pacman.conf.d/iso-x86_64.conf`. If missing, it falls back to the Artix default at `/usr/share/artools/pacman.conf.d/iso-x86_64.conf` which lacks `[antergos-pkgs]`.

```bash
mkdir -p ~/.config/artools/pacman.conf.d
cp pacman.conf.d/iso-x86_64.conf ~/.config/artools/pacman.conf.d/
```

CI does this automatically.

### Repo order in iso-x86_64.conf

`[antergos-pkgs]` must be listed **first** in `iso-x86_64.conf` so custom packages (calamares, branding) take priority over Artix's. If Artix repos are first, our custom packages won't be installed.

### Package order matters in profile.yaml

`basestrap` uses `--overwrite='*'`. The **last** package to claim a file wins. Package order in `profile.yaml` should list `calamares` BEFORE `calamares-branding-antergos-next`, so branding files overwrite Calamares defaults, not the other way around.

### `antergos-release` must be in basestrap.conf operations

The `filesystem` package owns `/usr/lib/os-release` with "Artix Linux". To replace it with "Antergos NeXT", `antergos-release` must be listed in the `operations` list in `iso-profiles/antergos/live-overlay/etc/calamares/modules/basestrap.conf`. This ensures it's installed during bootstrapping with `--overwrite`. If it's missing from operations, the installed system will show "Artix Linux" in `/usr/lib/os-release`.

### Squashfs compression

If `$COMPRESSION` is unset in `profile.yaml`, `mksquashfs` produces a sparse zero file instead of a valid squashfs. The ISO will be tiny and unbootable. Always verify compression is set, or remove stale images before retrying.

### Calamares module precedence

`/etc/calamares/modules/` overrides `/usr/share/calamares/modules/`. Live-overlay online/offline directories override both.

### Live-overlay is not overlay-mounted

Live-overlay files are copied via `cp -LR` in `make_livefs()`. Deleting a file from live-overlay exposes the package version underneath. Use `NoDisplay=true` in `.desktop` files to hide entries.

### `plasma-wayland-session` does not exist on Artix

Artix bundles the Wayland session into `plasma-workspace` itself. Do not add it to package lists.

### SDDM theme override

`kde_settings.conf` from KDE's SDDM KCM sets `Current=breeze`. To override this, the `antergos-sddm-theme` package ships a `theme.conf` at `/etc/sddm.conf.d/theme.conf`. SDDM reads config files in alphabetical order — since `theme.conf` sorts after `kde_settings.conf`, its `Current=antergos` wins. If you're adding a new override file, make sure it sorts after `kde_settings.conf`.

### Pipewire launcher on dinit

`artix-pipewire-launcher` detects the init system and only proceeds on supported ones. For dinit, the upstream script returns `SUPPORT=''` (unsupported). The forked version in `[antergos-pkgs]` patches this to `SUPPORT='YES'` for dinit. The XDG autostart entry (`pipewire.desktop` at `/etc/xdg/autostart/`) then starts pipewire on login.

### File conflicts

- `calamares` and `calamares-branding-antergos-next` both install to `/usr/share/calamares/branding/default/` — handled by `--overwrite='*'`
- `filesystem` and `antergos-release` both claim `/usr/lib/os-release` — handled by including `antergos-release` in basestrap operations

### `calamares-next.sh SetConfig()`

Must `rm -f` the symlink at `/etc/calamares/settings.conf` before `cp`, otherwise `cp` follows the symlink and overwrites the offline config file instead of replacing it with the selected one.

### CI does not trigger on push

The `build.yml` workflow only runs on `workflow_dispatch` (manual trigger from GitHub Actions tab). This prevents accidental ISO builds on every push.

### Internet Archive bucket naming

ISO identifier format: `antergos-next-YYYYMMDD-<run_number>`. The `-<run_number>` ensures uniqueness even for multiple builds on the same day.

## Testing a build

Boot the resulting ISO in a VM. Verify:

- Wayland is the default display server (SDDM session is `plasma.desktop`)
- No "Install Artix Linux" entry in the app menu
- Wallpaper is set on first login
- Offline mode installs without internet
- Online mode: init selector + DE selector both work
- Slideshow renders correctly
- Audio works after installation (pipewire should auto-start)
- After install, `/usr/lib/os-release` shows "Antergos NeXT"
- SDDM shows the Antergos theme, not Breeze

## Custom packages repo

Custom PKGBUILDs live in the companion [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) repo. The CI there builds them and publishes to GitHub Pages as a pacman repository:

```ini
[antergos-pkgs]
SigLevel = Optional TrustAll
Server = https://antergos-next.github.io/antergos-packages
```
