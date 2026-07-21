---
title: Runit
layout: default
parent: Init Systems
nav_order: 3
---

# Runit

**Runit** is a UNIX init system with service supervision — a replacement for sysvinit and other init schemes. It's small, fast, and follows the Unix philosophy of doing one thing well. Written by Gerrit Pape, it's been around since the early 2000s and is battle-tested.

## Philosophy

Runit is built on the same ideas as daemontools (by DJ Bernstein): each service gets its own supervision directory with a `run` script, and a supervisor process (`runsv`) keeps it alive. If the service crashes, it's automatically restarted. No complex service files, no binary logs, no centralized daemon — just scripts and processes.

## Who uses it?

- **Void Linux** — its default init system
- **Artix Linux** — available as an alternative
- **AntiX** — defaults to runit
- Embedded systems, containers, minimal installs

## How it works

Runit boots in three stages:

```
Stage 1 (/etc/runit/1)    → One-time initialization (filesystems, udev, etc.)
Stage 2 (/etc/runit/2)    → runsvdir starts, supervises all services
Stage 3 (/etc/runit/3)    → Shutdown (kill processes, unmount, halt)
```

Services live in `/etc/sv/` and are enabled by symlinking into `/run/runit/service` (or `/etc/runit/runsvdir/default/`).

## Key concepts

| Concept | What it means |
|---------|---------------|
| Service directories | Each service is a directory with an executable `run` script |
| `runsv` | Supervises one service, restarts it if it crashes |
| `runsvdir` | Starts/stops supervisors for a collection of services |
| `sv` | Main control tool — start, stop, restart, status |
| Runlevels | Directories under `/etc/runit/runsvdir/` (default, single, etc.) |
| Logging | Optional — add a `log/` subdirectory with its own `run` script |

## Basic commands

```bash
# Start a service
sv up sshd

# Stop a service
sv down sshd

# Restart a service
sv restart sshd

# Check status
sv status sshd

# Enable at boot (create symlink)
ln -s /etc/sv/sshd /etc/runit/runsvdir/default/

# Disable at boot (remove symlink)
rm /etc/runit/runsvdir/default/sshd
```

## Example service

`/etc/sv/sshd/run`:
```bash
#!/bin/sh
exec /usr/bin/sshd -D
```

That's it. No config parsing, no dependency declarations, no unit files. If the script exits, runsv restarts it. If you want logging, add `log/run`:

`/etc/sv/sshd/log/run`:
```bash
#!/bin/sh
exec svlogd -tt /var/log/sshd
```

## Comparison with OpenRC

| | OpenRC | Runit |
|---|--------|-------|
| Service format | Shell scripts with `start()`/`stop()` | Executable `run` scripts |
| Dependencies | Manual (`need`/`use`) | None (automatic via sv) |
| Supervision | No built-in | Yes — auto-restart on crash |
| Logging | syslog or separate | Built-in per-service logging |
| Boot speed | Fast | Very fast |
| Complexity | Low | Low |

## When to use Runit

Runit is suitable for users who want a minimal supervision-based init with automatic service restart on crash. Its service model (one executable `run` script per service) is straightforward and requires no dependency declarations.

Users coming from Void Linux will find Runit familiar. For users who need dependency management between services, OpenRC or Dinit may be more appropriate.

## Learn more

- [Runit official site](https://smarden.org/runit/)
- [Runit FAQ](https://smarden.org/runit/faq)
- [Artix Runit page](https://wiki.artixlinux.org/Main/Runit)
- [Runit on Gentoo Wiki](https://wiki.gentoo.org/wiki/Runit)
