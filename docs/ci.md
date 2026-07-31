---
title: CI/CD
layout: default
nav_order: 7
---

# CI/CD Pipeline

Three GitHub Actions workflows:

## Build ISO (`build.yml`)

Triggers on **manual `workflow_dispatch`** only (push to master does NOT trigger a build). Runs in an `artixlinux/artixlinux:base` container with `--privileged`.

### Steps

1. Install dependencies (artools, squashfs-tools, git, sudo, python)
2. Set `WORKSPACE_DIR` to the checkout path
3. Override pacman config with `[antergos-pkgs]` repo (`pacman.conf.d/iso-x86_64.conf`)
4. Mount a 12 GB tmpfs at `/var/lib/artools/buildiso`
5. Run `./buildiso -p antergos`
6. Upload the ISO as a build artifact

### Internet Archive upload

The workflow includes an Internet Archive upload step, but it is **currently disabled** (`if: false`) — the maintainer is the only QA team and builds are manually verified first. When re-enabled it uploads with:

- **Collection**: `open_source_software` (Community Software, _not_ Community Texts)
- **Identifier**: `antergos-next-YYYYMMDD-<run_number>` (e.g. `antergos-next-20260711-162`)
- **Credentials**: `IA_ACCESS_KEY` and `IA_SECRET_KEY` (repo secrets)

The `-<run_number>` suffix guarantees unique identifiers across CI runs.

### Secrets

| Secret | Purpose |
|--------|---------|
| `IA_ACCESS_KEY` | Internet Archive S3 access key (for the disabled IA step) |
| `IA_SECRET_KEY` | Internet Archive S3 secret key |
| `GROQ_API_KEY` | Groq API key for the AI moderator |

## AI community moderator (`ai-moderator.yml`)

Triggers on issue open, issue/PR comment, discussion, and discussion comment. Uses the Groq API (`llama-3.1-8b-instant`) via `actions/github-script@v9` to check posts against the Code of Conduct and `CONTRIBUTING.md`. May warn, hide comments, or lock threads. See `ai-moderator.yml` for details.

## Deploy docs (`pages.yml`)

Triggers on push to `master` _only_ when files under `docs/` change. Builds a Jekyll site from `docs/` using the Just the Docs theme and deploys to GitHub Pages.

## antergos-packages CI

Separate workflow in the [antergos-packages](https://github.com/Antergos-NeXT/antergos-packages) repo. Builds all packages listed in `packages.yaml` and publishes them to GitHub Pages as a pacman repository.

## Safety notes

- CI does NOT run on push — only manual dispatch. This prevents unintended ISO builds.
- Internet Archive upload is disabled by default; when enabled it uses a unique identifier per run, so re-running CI won't overwrite a previous release.
- `GROQ_API_KEY` must be set as a repo secret for the AI moderator to function.
