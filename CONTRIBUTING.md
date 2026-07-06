# Contributing to Antergos NeXT

## Who's behind this

This project is maintained **solo** by Michał (c-ludenberg). I'm recovering from an ankle injury, so updates may be slow. Contributions are genuinely appreciated — they keep the project moving when I can't.

## How to contribute

### Issues

- **Bug reports**: Include the ISO build date, commit SHA, and steps to reproduce. Run Calamares with `-D8` for debug logs.
- **Feature requests**: Explain what you want and why. PRs are better than requests.
- **Questions**: If it's about using the ISO, check the [docs](https://antergos-next.github.io/antergos-iso/) first.

### Pull requests

1. Fork the repo, create a branch from `master`.
2. Make your changes. Keep commits small and signed (`git commit -S`).
3. Test your changes by building the ISO locally if possible.
4. Open a PR with a clear description of what and why.

### Before committing

This repo requires **GPG-signed commits**. Set up your key:

```bash
git config user.signingkey <your-key>
git config commit.gpgsign true
```

## Building locally

```bash
export WORKSPACE_DIR="$PWD"
mkdir -p ~/.config/artools/pacman.conf.d
cp pacman.conf.d/iso-x86_64.conf ~/.config/artools/pacman.conf.d/
sudo -E ./buildiso -p antergos
```

Use `./buildiso`, not the system `/usr/bin/buildiso` — the system one lacks `--overwrite='*'` and will fail with file conflicts.

## Key gotchas

- **`componentName` in `branding.desc` must match its directory name.** Calamares will bail if they don't match.
- **Package order in `profile.yaml` matters.** `calamares` must be before `calamares-branding-antergos-next` so branding overwrites defaults.
- **`[antergos-pkgs]` must be first in `iso-x86_64.conf`.** Custom packages take priority over Artix's.
- **Copy pacman.conf before building.** `buildiso` uses `~/.config/artools/pacman.conf.d/iso-x86_64.conf`. Without it, it falls back to the system one which lacks the custom repo.
- **`CMAKE_DISTRIBUTION_NAME` is a no-op.** Calamares ignores it. The "for <distro>" text comes from `versionedName` in the active branding.

## Code style

- Match the surrounding code. No changes are too small to be worth a PR.
- No unnecessary comments. Code should speak for itself.
- Keep YAML clean — two-space indentation, no trailing whitespace.

## Getting help

Open a discussion or ping the maintainer. If it's urgent, mention it. If it's not, be patient — I'll get to it.
