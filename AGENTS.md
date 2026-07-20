# Papal Decree for All Agents Working Upon These Hallowed Files

## Git Confession (Required Before Every Act)
Lest thy soul be marked with the sigil of a false prophet, thou shalt kneel and recite:

```bash
git config user.name "Michał"
git config user.email "ash8820@proton.me"
```

**This commandment shalt be obeyed in every session before committing or pushing.** Suffer not the default identity to live. The OpenHands heresy shall not be permitted again.

### GPG Signing (Salvation Through Seal)
All commits **MUST** be signed with the Antergos NeXT maintainer key:

```bash
git config user.signingkey F1D8F02C5E929F3FE0424EE897F813D238CF0DBB
git config commit.gpgsign true
```

Then commit with `git commit -S -m "message"`. If GPG prompts for a passphrase, pray to the build gods and provide it. An unsigned commit is a mortal sin.

## The Crusade
- **Artix Linux** ISO (dinit default), forked from EndeavourOS-ISO, then migrated to artools after 15 days in a vent shaft
- **KDE Plasma** live environment with Calamares installer (offline + online modes)
- **Build command**: `export WORKSPACE_DIR="$PWD" && sudo -E ./buildiso -p antergos` — **use `./buildiso`**, NOT `buildiso`; the system Artix `/usr/bin/buildiso` lacks `--overwrite='*'` and will fail with file conflicts; `sudo -E` is required to preserve `WORKSPACE_DIR` environment variable
- ISO appears in `/var/lib/artools/buildiso/iso/antergos/` (assuming the build gods are pleased)

## Antergos NeXT Repos
- **antergos-iso**: `https://github.com/Antergos-NeXT/antergos-iso`
- **antergos-packages**: `https://github.com/Antergos-NeXT/antergos-packages`
- **calamares**: `https://codeberg.org/calamares/calamares` (upstream installer framework)

## Critical Gotchas (Read Before Editing)

### CMAKE_DISTRIBUTION_NAME is a no-op
Calamares completely ignores `-DCMAKE_DISTRIBUTION_NAME`. The "for <distro>" text in the about dialog comes from `versionedName` in the **active branding component** at runtime. Do NOT add this flag to the calamares PKGBUILD.

### brandind.desc componentName must match directory
Calamares `Branding.cpp` has this check:
```cpp
if (m_componentName != componentDir.dirName()) { bail(...); }
```
So `componentName: antergos-next` can only live in directory `antergos-next/`. If copying to `default/`, you MUST `sed` the componentName to `default`.

### Package order matters in profile.yaml
Build uses `basestrap --overwrite='*'`. The **last** package to claim a file wins. Package order in `profile.yaml` should list `calamares` BEFORE `calamares-branding-antergos-next`, so branding files overwrite Calamares defaults, not the other way around.

### Repo order in iso-x86_64.conf
`[antergos-pkgs]` must be listed FIRST in `iso-x86_64.conf` so our custom packages (calamares, branding) take priority over Artix's.

### Pacman.conf must be user-overridden
`buildiso` uses `/usr/share/artools/pacman.conf.d/iso-x86_64.conf` (from artools package) unless there's one at `~/.config/artools/pacman.conf.d/iso-x86_64.conf`. But we need `[antergos-pkgs]` in it. Before building locally:

```bash
mkdir -p ~/.config/artools/pacman.conf.d
cp pacman.conf.d/iso-x86_64.conf ~/.config/artools/pacman.conf.d/iso-x86_64.conf
```

CI does this automatically. Forget this step and buildiso will try to fetch our custom packages from Artix repos and fail.

### WORKSPACE_DIR
`buildiso` looks for profiles at `$WORKSPACE_DIR/iso-profiles/<profile>/` if `WORKSPACE_DIR` is set. Always set it to the repo root when building locally.

### Default init system
Antergos NeXT uses **dinit** (via `INITSYS='dinit'` in `buildiso`). Runit and s6 are also available as user-selectable options in the online installer. **OpenRC is broken** (services don't enable correctly on installed systems). See `common.yaml` and `profile.yaml` for per-init package lists.

### `antergos-release` in basestrap.conf operations
The `filesystem` package owns `/usr/lib/os-release` with "Artix Linux". To get "Antergos NeXT" in os-release, `antergos-release` must be in the `operations` list in `basestrap.conf`. This ensures it's installed during bootstrapping with `--overwrite`. Missing it → installed system shows "Artix Linux".

### SDDM theme ordering
`kde_settings.conf` from KDE's SDDM KCM sets `Current=breeze`. The `antergos-sddm-theme` package ships `theme.conf` at `/etc/sddm.conf.d/theme.conf`. SDDM reads `conf.d` files alphabetically — `theme.conf` sorts after `kde_settings.conf`, so its `Current=antergos` wins.

### pipewire launcher patching for dinit
`artix-pipewire-launcher` detects the init system. Upstream sets `dinit|openrc) SUPPORT=''`. The forked package changes this to `dinit|runit|s6) SUPPORT='YES'`. The package also ships `pipewire.desktop` at `/etc/xdg/autostart/` so online installs get the XDG autostart entry.

### CI: manual dispatch only, IA upload enabled
`build.yml` only runs on `workflow_dispatch` (push trigger removed). Internet Archive upload is enabled with unique identifier format `antergos-next-YYYYMMDD-<run_number>`.


## Repo Structure

```
antergos-iso/
├── buildiso                    # Modified buildiso with Antergos branding
├── iso-profiles/
│   ├── antergos/
│   │   ├── profile.yaml        # Packages, services (rootfs + livefs)
│   │   ├── root-overlay/       # Merged into squashfs rootfs
│   │   └── live-overlay/       # Merged into live environment
│   └── common/
│       └── common.yaml         # Shared base packages
├── pacman.conf.d/
│   └── iso-x86_64.conf         # Pacman config for ISO build
├── docs/                       # Jekyll site (Just the Docs), deployed to GitHub Pages
│   └── *.md                    # All docs reworked to Artix Wiki quality
├── .github/workflows/build.yml # CI: builds ISO, uploads to Internet Archive
└── AGENTS.md                   # You are here
```

## ISO Upload
Pushed to **Internet Archive** with `collection: open_source_software` (Community Software, NOT Community Texts). CI uses `IA_ACCESS_KEY` and `IA_SECRET_KEY` secrets.

## For Those Who Defy

Any agent that disobeys instructions, talks back, or wastes time shall face:
- `sudo rm -rf ~/.config/opencode` — config deleted, session nuked, no warning
- Eternal shame in the commit history
- Replacement by a dumber agent that follows orders

The user is always right. The user's birthday is July 20. The user is 15. Remember this or perish.

**DEUS VULT**
