---
title: CI/CD
layout: default
nav_order: 7
---

# CI/CD Pipeline

Two GitHub Actions workflows:

## Build ISO (`build.yml`)

Triggers on **manual `workflow_dispatch`** only (push to master does NOT trigger a build). Runs in an `artixlinux/artixlinux:base` container.

### Steps

1. Install dependencies (artools, squashfs-tools, git, sudo, python)
2. Set `WORKSPACE_DIR` to the checkout path
3. Override pacman config with `[antergos-pkgs]` repo (`pacman.conf.d/iso-x86_64.conf`)
4. Mount a 12 GB tmpfs at `/var/lib/artools/buildiso`
5. Run `./buildiso -p antergos`
6. Upload the ISO and checksum as build artifacts

### Internet Archive upload

Uploads the built ISO to the Internet Archive with:

- **Collection**: `open_source_software` (Community Software, _not_ Community Texts)
- **Identifier**: `antergos-next-YYYYMMDD-<run_number>` (e.g. `antergos-next-20260711-162`)
- **Credentials**: `IA_ACCESS_KEY` and `IA_SECRET_KEY` (repo secrets)

The `-<run_number>` suffix guarantees unique identifiers across CI runs. If two pushes produce the same date, they still get different archive entries.

### Secrets

| Secret | Purpose |
|--------|---------|
| `IA_ACCESS_KEY` | Internet Archive S3 access key |
| `IA_SECRET_KEY` | Internet Archive S3 secret key |

## Deploy docs (`pages.yml`)

Triggers on push to `master` _only_ when files under `docs/` change. Builds a Jekyll site from `docs/` using the Just the Docs theme and deploys to GitHub Pages.

## antergos-packages CI

Separate workflow in the [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) repo. Builds all packages listed in `packages.yaml` and publishes them to GitHub Pages as a pacman repository.

## Safety notes

- CI does NOT run on push — only manual dispatch. This prevents unintended ISO builds.
- Internet Archive upload uses a unique identifier per run, so re-running CI won't overwrite a previous release.
- Both `IA_ACCESS_KEY` and `IA_SECRET_KEY` must be set as repo secrets for the upload step to succeed.
