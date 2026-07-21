---
title: Dinit
layout: default
parent: Init Systems
nav_order: 2
---

# Dinit

**Dinit** is a modern init system designed for speed and correctness. Written in C++, it focuses on parallel service startup and dependency management. **Dinit is the default init system in Antergos NeXT.**

Dinit handles dependencies automatically through declarative configuration files, avoiding the complexity of shell-script-based service definitions.

## Key concepts

| Concept | What it means |
|---------|---------------|
| Service files | Declarative `.conf` files in `/etc/dinit.d/` |
| Dependencies | Automatic — Dinit figures out start order from `depends-on` directives |
| Parallel startup | Very fast — starts services concurrently wherever possible |
| Process supervision | Optional — can restart crashed services if `type = process` |

## Basic commands

```bash
# Start a service
dinitctl start sshd

# Stop a service
dinitctl stop sshd

# Enable at boot
dinitctl enable sshd

# Disable at boot
dinitctl disable sshd

# Check status
dinitctl status sshd

# List all services
dinitctl list
```

## Example service file

`/etc/dinit.d/sshd.conf`:
```
type = process
command = /usr/bin/sshd -D
depends-on = dbus
depends-on = network
```

## Where services live

- **System services**: `/etc/dinit.d/` (config) — enabled via symlinks in `/etc/dinit.d/boot.d/`
- **User services**: similar structure under the user's config directory (for `dinit-user-spawn`)
- **Boot-enabling**: `dinitctl enable <service>` creates a symlink in `boot.d/`

Service files use a simple key-value syntax. The `type` can be:
- `process` — supervised (auto-restart on crash)
- `scripted` — runs and completes (one-shot tasks)
- `internal` — handled internally by dinit

## Common tasks

### Enable a service at boot

```bash
dinitctl enable sshd
```

Alternatively, create a symlink manually:

```bash
ln -s /etc/dinit.d/sshd /etc/dinit.d/boot.d/
```

### Check what's running

```bash
dinitctl list
```

### View logs

Dinit itself doesn't handle logging. Services log to syslog or their own log files under `/var/log/`. Use `less /var/log/messages` or check per-service log directories.

## Comparison with OpenRC

| | OpenRC | Dinit |
|---|--------|-------|
| Service format | Shell scripts | Declarative config |
| Dependencies | Manual (`need`/`use`) | Automatic |
| Speed | Fast | Very fast (more parallel) |
| Complexity | Low | Medium |
| Supervision | No built-in | Optional |

## Troubleshooting

### Service fails to start

Check the service file syntax first:

```bash
dinitctl start sshd
# If it fails, check:
cat /var/log/messages | grep dinit
```

Make sure all `depends-on` services are available (even if not enabled — dinit will start them as dependencies).

### "boot" service file missing

Dinit's `add_user_svc_dinit` in Calamares attempts to create `boot.d/` symlinks but does not create a `boot` service file. This is a known upstream limitation. Workaround: ensure services are enabled via `dinitctl enable` after install, or use the init-specific package handling in Calamares.

### pipewire doesn't start

On Antergos NeXT, `artix-pipewire-launcher` is patched to support dinit. If pipewire isn't starting, verify the launcher script at `/usr/bin/artix-pipewire-launcher` includes dinit in its supported init list. The XDG autostart entry at `/etc/xdg/autostart/pipewire.desktop` handles starting pipewire on login.

## When to use Dinit

Dinit is suitable for users who want fast boot times and automatic dependency resolution without managing shell-script-based service files. It is the default init in Antergos NeXT and requires no additional configuration.

Users migrating from systemd will find Dinit's declarative service files familiar. Users accustomed to OpenRC or Runit may prefer to switch — see [Changing init](changing-init) for instructions.

## Learn more

- [Dinit GitHub](https://github.com/davmac314/dinit)
- [Dinit documentation](https://davmac.org/projects/dinit/)
- [Artix Dinit page](https://wiki.artixlinux.org/Main/dinit)
