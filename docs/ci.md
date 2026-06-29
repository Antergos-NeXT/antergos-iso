---
title: CI/CD
layout: default
nav_order: 5
---

# CI/CD Pipeline

Two GitHub Actions workflows:

## Build ISO (`build.yml`)

Triggers on push/PR to `master`. Runs in an `artixlinux/artixlinux:base` container.

Steps:
1. Install dependencies (artools, squashfs-tools, git, sudo, python)
2. Set `WORKSPACE_DIR` to the checkout path
3. Override pacman config with `[antergos-pkgs]` repo
4. Mount a 12 GB tmpfs at `/var/lib/artools/buildiso`
5. Run `./buildiso -p antergos`
6. Upload the ISO directory as a build artifact

### Internet Archive upload

Currently **disabled** (`if: false`) until ISO is stable. When enabled, uploads the built ISO to the Internet Archive with metadata:

- Collection: `open_source_software`
- Access keys: `IA_ACCESS_KEY`, `IA_SECRET_KEY` (repo secrets)

### Secrets

| Secret | Purpose |
|--------|---------|
| `IA_ACCESS_KEY` | Internet Archive S3 access key |
| `IA_SECRET_KEY` | Internet Archive S3 secret key |

## Deploy docs (`pages.yml`)

Triggers on push to `master` only when files under `docs/` change. Builds a Jekyll site from `docs/` using the Just the Docs theme and deploys to GitHub Pages.

## antergos-packages CI

Separate workflow in the [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) repo. Builds all packages listed in `packages.yaml` and publishes them to GitHub Pages as a pacman repo.
