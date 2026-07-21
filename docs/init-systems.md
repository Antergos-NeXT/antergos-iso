---
title: Init Systems
layout: default
nav_order: 4
has_children: true
---

# Init Systems

An **init system** is PID 1 — the first process started by the kernel during boot. It is responsible for initializing the system: mounting filesystems, starting networking, launching services, and managing the display manager. All other processes descend from PID 1.

Antergos NeXT ships with **Dinit** as its default init system. The pages below describe the major init systems available on Artix Linux. To switch init on an installed system, see [Changing init](changing-init).

## Available init systems

| Init | Philosophy | Complexity | Speed | Used by |
|------|-----------|------------|-------|---------|
| [Dinit](dinit) | Modern, dependency-based, parallel | Medium | Very fast | Antergos NeXT (default), Chimera Linux, Artix |
| [OpenRC](openrc) | Traditional, modular, shell-script-based | Low | Fast | Gentoo, Artix, Devuan, Alpine |
| [Runit](runit) | Minimal, supervision-based, Unix-like | Low | Very fast | Void Linux, AntiX |
| [S6](s6) | Full supervision suite, modular | Medium-High | Very fast | Artix, embedded systems |

## Shared characteristics

- **No systemd** — all four are independent implementations
- **Service files** — services are configured via files in `/etc/`
- **Runlevels** — groups of services that start together under different conditions
- **Plain-text logging** — logs are written to `/var/log/`

## Comparison

| Aspect | Dinit | OpenRC | Runit | S6 |
|--------|-------|--------|-------|-----|
| Service format | Declarative `.conf` files | Shell scripts | Executable `run` scripts | `run` scripts + s6-rc database |
| Dependencies | Automatic | Manual (`need`/`use`) | None | Automatic (s6-rc) |
| Supervision | Optional | No | Yes (runsv) | Yes (s6-supervise) |
| Logging | None built-in | syslog | Per-service (optional) | Per-service (s6-log) |
| Init script | None needed | `/etc/init.d/` | `/etc/runit/1/2/3` | s6-linux-init |

## Switching init after installation

See [Changing init](changing-init) for step-by-step instructions on switching to OpenRC, Runit, or S6 on an installed system.
